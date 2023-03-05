#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>
#include "mpi.h"

#define I 60000
#define J 30

/*---Global scope---*/
int k;                                                                                                 // number of neighbors to search
double a[I][J];                                                                                        // 60000 elements with 30 coordinates

struct timeval startwtime, endwtime;
double seq_time;

/**--Data structure--*/
struct data {
  double dist;                                                                                         // distance of two elements
  int pos;                                                                                             // position of the new element
};

/***------Function declarations------***/
int compareFunc(const void* a, const void* b);                                                         // compare function for qsort, ascending
void getData();                                                                                        // get data from .mat file

/****-----------main programm-----------****/
int main(int argc, char** argv)
{
   if (argc != 2 || atoi(argv[1]) < 1 || atoi(argv[1]) >= 60000) {                                     // check if user gave k neighbors
     printf("Usage: %s neighbors < 1 , or >= 60000\n ",
 	   argv[1]);
     exit(1);
   }
 
   k = atoi(argv[1]);
 
   int i,j,l, cnt, cnt2 = 0, shift = 0;                                                                // iteretors, counter used for struct
   double distance;
   int numtasks, id, next, previous, blocks = 0, block, flag = 0, flag2 = 0, flag3 = 0;                // Mpi variables
   double sendcnt, recvcnt, source;

   getData();

   MPI_Init(&argc, &argv);                                                                             // MPI initialization
   MPI_Comm_size(MPI_COMM_WORLD, &numtasks);
   MPI_Comm_rank(MPI_COMM_WORLD, &id);

   previous = id - 1;
   next = id + 1;
   if(id == 0)  previous = numtasks - 1;
   if(id == (numtasks - 1))  next = 0;

   block = I/numtasks;                                                                                 // number of elements per block

   double originbuf[block][J];                                                                         // Table to store original block
   double recvbuf[block][J];                                                                           // Table to store received block

   MPI_Request reqs[(numtasks-1)*2];                                                                   // for non blocking sends, receives
   MPI_Status status[(numtasks-1)*2];

   struct data** array = (struct data**)malloc(block * sizeof(struct data));
   for(i = 0; i < block; i++)
      array[i] = (struct data*)malloc(k * sizeof(struct data));

   if (numtasks <= 4) {                                                                                // define source process and elements to send/receive, then perform collective scatter
      source = 0;
      sendcnt = J*(block);
      recvcnt = sendcnt;
      MPI_Scatter(a, sendcnt, MPI_DOUBLE, originbuf, recvcnt, MPI_DOUBLE, source, MPI_COMM_WORLD);
      printf("rank= %d  Results: %lf %lf\n",id,originbuf[0][0],originbuf[3][29]);
   }
   else {
      printf("Must specify %d processors. Terminating.\n", numtasks);
      MPI_Finalize();
      exit(1);
   }

   gettimeofday (&startwtime, NULL);

   MPI_Isend(originbuf, sendcnt, MPI_DOUBLE, next, 0, MPI_COMM_WORLD, &reqs[0]);
   MPI_Irecv(recvbuf, recvcnt, MPI_DOUBLE, previous, MPI_ANY_TAG, MPI_COMM_WORLD, &reqs[1]);

   /*******--------------KNN-------------*******/
   /***-First, find neighbors in original block-***/
   for(i = 0; i < block; i++)
   {
      cnt = 1;                                                                                         // initialize counter for every i element
      for(j = 0; j < block; j++)
      {
         if(j == i) continue;                                                                          // distance = 0, duh
         distance = 0;                                                                                 // initialize distance for every j
         for(l = 0; l < J; l++)  distance += pow(originbuf[i][l]-originbuf[j][l], 2);
         distance = sqrt(distance);
         printf("Distance between %d and %d is : %lf\n", i+(id*(block)), j+(id*(block)), distance);
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

   cnt = 0;

   while(flag == 0 || flag2 == 0) {
      MPI_Test(&reqs[0], &flag2, &status[0]);
      MPI_Test(&reqs[1], &flag, &status[1]);
   }

   /*****----Now, find neighbors from other blocks and update----*****/
   while(blocks != (numtasks-1)) {                                                                     // While blocks checked are not numtasks-1
      if(flag)  flag = 0;
      else{
         MPI_Irecv(recvbuf, recvcnt, MPI_DOUBLE, previous, MPI_ANY_TAG, MPI_COMM_WORLD, &reqs[blocks*2+1]);
         while(flag2 == 0 || flag3 == 0) {
            if((blocks-1) < (numtasks-2))
               MPI_Test(&reqs[(blocks-1)*2+2], &flag2, &status[(blocks-1)*2+2]);                       // check if Send was true
            else
               flag2 = 1;
            MPI_Test(&reqs[blocks*2+1], &flag3, &status[blocks*2+1]);                                  // check if Receive is true
         }
         flag2 = 0;                                                                                    // reset flags
         flag3 = 0;
      }
      if(blocks < (numtasks-2)) MPI_Isend(recvbuf, recvcnt, MPI_DOUBLE, next, 0, MPI_COMM_WORLD, &reqs[blocks*2+2]);
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
      blocks++;                                                                                       // finished with current block
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

   /*****------Results------*****/
   for(i = 0; i < block; i++)
   {
      printf("RESULT : [%d] element has element : ", i+id*block);
      for (j = 0; j < k; j++)
         printf("%d as neighbor.  ", array[i][j].pos);
      printf("\n\n");
   }

   for(i = 0; i < block; i++) free(array[i]);
   free(array);

   //MPI_Waitall((numtasks-1)*2, reqs, status);
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
