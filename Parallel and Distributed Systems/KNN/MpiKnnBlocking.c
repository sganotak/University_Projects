#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>
#include "mpi.h"

#define I 60000
#define J 30

/*---Global scope---*/
int k;                                                                                                // number of neighbors to search
double a[I][J];                                                                                       // 60000 elements with 30 coordinates

struct timeval startwtime, endwtime;
double seq_time;

/**--Data structure--*/
struct data {
  double dist;                                                                                        // distance of two elements
  int pos;                                                                                            // position of the new element
};

/***------Function declarations------***/
int compareFunc(const void* a, const void* b);                                                        // compare function for qsort, ascending
void getData();

/****-----------main programm-----------****/
int main(int argc, char** argv)
{
   if (argc != 2 || atoi(argv[1]) < 1 || atoi(argv[1]) >= 60000) {                                    // check if user gave k neighbors
     printf("Usage: %s neighbors < 1 , or >= 60000\n ",
 	   argv[1]);
     exit(1);
   }
  
   k = atoi(argv[1]);
 
   int i,j,l, cnt, cnt2 = 0;                                                                          // iteretors, counter used for struct
   double distance;
   int numtasks, id, next, previous, block, blocks = 0, shift=0;                                      // Mpi variables
   double sendcnt, recvcnt, source;

   getData();                                                                                         // get data from .mat file

   MPI_Init(&argc, &argv);                                                                            // MPI initialization
   MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
   MPI_Comm_rank(MPI_COMM_WORLD, &id);

   previous = id - 1;
   next = id + 1;
   if(id == 0)  previous = numtasks - 1;
   if(id == (numtasks - 1))  next = 0;

   block = I/numtasks;
   double originbuf[block][J];                                                                        // Table to store original block
   double recvbuf[block][J];                                                                          // Table to store received block

   struct data** array = (struct data**)malloc(block * sizeof(struct data*));
   for(i = 0; i < block; i++)
      array[i] = (struct data*)malloc(k * sizeof(struct data));

   if (numtasks <= 8) {                                                                               // define source process and elements to send/receive, then perform collective scatter
      source = 0;
      sendcnt = J*(block);
      recvcnt = sendcnt;
      MPI_Scatter(a, sendcnt, MPI_DOUBLE, originbuf, recvcnt, MPI_DOUBLE, source, MPI_COMM_WORLD);
      //printf("rank= %d  Results: %lf %lf\n",id,sendbuf[0][0],sendbuf[3][29]);
   }
   else {
      printf("Must specify %d processors. Terminating.\n", numtasks);
      exit(1);
   }

   gettimeofday (&startwtime, NULL);

	
   /*******--------------KNN-------------*******/
   /***---for origin block---***/
   for(i = 0; i < block; i++)
   {
      cnt = 1;                                                                                        // initialize counter for every i element
      for(j = 0; j < block; j++)
      {
         if(j == i) continue;                                                                         // distance = 0, duh
         distance = 0;                                                                                // initialize distance for every j
         for(l = 0; l < J; l++)  distance += pow(originbuf[i][l]-originbuf[j][l], 2);
         distance = sqrt(distance);
         //printf("Distance between %d and %d is : %lf\n", i+(id*(block)), j, distance);
         if(cnt <= k)
         {
            array[i][cnt-1].dist = distance;
            array[i][cnt-1].pos = j+(id*(block));
            if(cnt == k) qsort(array[i], cnt, sizeof(struct data), compareFunc);
            cnt++;
         }
         else
         {
            if(array[i][cnt-2].dist > distance)
            {
               array[i][cnt-2].dist = distance;
               array[i][cnt-2].pos = j+(id*(block));
               qsort(array[i], k, sizeof(struct data), compareFunc);
            }
         }
      }
   }

	
	/*****-----for the other blocks-----*****/
	while(blocks != (numtasks-1)) {
		if(id != 0 && blocks == 0){
			MPI_Recv(recvbuf, recvcnt, MPI_DOUBLE, previous, MPI_ANY_TAG, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
			/*for(i = 0; i<block;i++)
			{
				for(j=0;j<J;j++)
					printf("%lf  ", a[i][j]);
			}
			printf("id %d received from previous.\n\n", id);*/
			MPI_Send(originbuf, sendcnt, MPI_DOUBLE, next, 0, MPI_COMM_WORLD);
		}
		if(id == 0 && blocks == 0){
			MPI_Send(originbuf, sendcnt, MPI_DOUBLE, next, 0, MPI_COMM_WORLD);
			MPI_Recv(recvbuf, recvcnt, MPI_DOUBLE, previous, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
		}

		if(id != 0  && blocks > 0) {
			MPI_Recv(recvbuf, recvcnt, MPI_DOUBLE, previous, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
			/*for(i = 0; i<block;i++)
			{
				for(j=0;j<J;j++)
					printf("%lf  ", a[i][j]);
			}
			printf("id %d received from previous.\n\n", id);*/
		}

		if(id == 0 && blocks > 0){
			MPI_Recv(recvbuf, recvcnt, MPI_DOUBLE, previous, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
			/*for(i = 0; i<block;i++)
			{
				for(j=0;j<J;j++)
					printf("%lf  ", a[i][j]);
			}
			printf("id %d received from previous.\n\n", id);*/
		}
		for(i = 0; i < block; i++)
      {
         for(j = 0; j < block; j++)
         {
            distance = 0;                                                                              // initialize distance for every j
            for(l = 0; l < J; l++)  distance += pow(originbuf[i][l]-recvbuf[j][l], 2);
            distance = sqrt(distance);
            if(shift) {
               //printf("distance between %d and %d is : %lf\n", i+id*block, j+cnt2*block, distance);
               if(array[i][k-1].dist > distance)
               {
                  array[i][k-1].dist = distance;
                  array[i][k-1].pos = j+cnt2*block;
                  qsort(array[i], k, sizeof(struct data), compareFunc);
               }
            }
            else {
               //printf("distance between %d and %d is : %lf\n", i+id*block, j+(previous-cnt)*block, distance);
               if(array[i][k-1].dist > distance)
               {
                  array[i][k-1].dist = distance;
                  array[i][k-1].pos = j+(previous-cnt)*block;
                  qsort(array[i], k, sizeof(struct data), compareFunc);
               }
            }
         }
      }
		MPI_Send(recvbuf, sendcnt, MPI_DOUBLE, next, 0, MPI_COMM_WORLD);
      blocks++;
      if(shift) {
         cnt2--;
         continue;
      }
      if(id == 0)  cnt = blocks;
      else if((previous-cnt) > 0)  cnt++;
      else if((previous-cnt) == 0) {
         cnt2 = numtasks - 1;
         shift = 1;
      }
   }

   gettimeofday (&endwtime, NULL);
   seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6
             + endwtime.tv_sec - startwtime.tv_sec);

   /****------RESULTS------****/
   for(i = 0; i < block; i++)
   {
      printf("RESULT : [%d] element has element : ", i+(id*(block)));
      for (j = 0; j < k; j++)
         printf("%d as neighbor.  ", array[i][j].pos);
      printf("\n\n");
   }

   for(i = 0; i < block; i++) free(array[i]);
   free(array);

   MPI_Finalize();

   printf("Wall clock time = %f\n", seq_time);
   return 0;
}


int compareFunc(const void* a, const void* b) {
   struct data *a1 = (struct data *)a;
   struct data *a2 = (struct data *)b;
   if( (*a1).dist > (*a2).dist) return 1;
   else if( (*a1).dist < (*a2).dist) return -1;
   else return 0;
}

void getData() {
   int i, j;
   FILE *file = fopen("matFile.txt", "r");
   for(i = 0; i < I; i++){
      for(j = 0; j < J; j++)
      {
         fscanf(file, "%lf,", &a[i][j]);
      }
   }
   fclose(file);
}
