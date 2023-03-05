#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include <math.h>

#define I 60000
#define J 30

/*---Global scope---*/
int k;                                                                           // number of neighbors to search
double a[I][J];                                                                  // 60000 elements with 30 coordinates

struct timeval startwtime, endwtime;
double seq_time;

/**--Data structure--*/
struct data {
  double dist;                                                                   // distance of two elements
  int pos;                                                                       // position of 2nd element
};

/***-Function declarations-***/
int compareFunc(const void* a, const void* b);                                   // compare function for qsort, ascending
void getData();

/****-----------main programm-----------****/
int main(int argc, char** argv)
{

  if (argc != 2 || atoi(argv[1])<1 || atoi(argv[1]) >  59999) {                  // check if user gave k neighbors
    printf("Usage: %s neighbors < 1\n ",
	   argv[1]);
    exit(1);
  }

  k = atoi(argv[1]);

  int i,j,l, cnt;                                                                // iteretors

  struct data** array = (struct data**)malloc(I * sizeof(struct data*));
  for(i = 0; i < I; i++)
     array[i] = (struct data*)malloc(k * sizeof(struct data));
  double distance;

  getData();

  printf("\n\n");
  gettimeofday (&startwtime, NULL);
  /*--calculate distance between i and j--*/
  for(i = 0; i < I; i++)
  {
    cnt = 1;                                                                     // initialize counters for every i element
    for(j = 0; j < I; j++)
    {
        if(j == i) continue;                                                     // distance = 0, duh
        distance = 0.00000000;                                                   // initialize dist sum for every j
        for(l = 0; l < J; l++)
        {
          distance += pow(a[i][l]-a[j][l], 2);
        }
        //printf("Distance between %d and %d is : %lf\n", i, j, distance);
        distance = sqrt(distance);
        if(cnt <= k)
        {
          array[i][cnt-1].dist = distance;
          array[i][cnt-1].pos = j;
          if(cnt == k) qsort(array, cnt, sizeof(struct data), compareFunc);
          cnt++;
        }
        else if( (cnt > k) && (array[i][cnt-2].dist > distance) )
        {
          array[i][k-1].dist = distance;
          array[i][k-1].pos = j;
          qsort(array[i], k, sizeof(struct data), compareFunc);
        }
    }
  }
  gettimeofday (&endwtime, NULL);
  seq_time = (double)((endwtime.tv_usec - startwtime.tv_usec)/1.0e6
            + endwtime.tv_sec - startwtime.tv_sec);

  for(i = 0; i < I; i++)
  {
     printf("RESULT : [%d] element has element : ", i);
     for (j = 0; j < k; j++)
         printf("%d as neighbor.  ", array[i][j].pos);
     printf("\n\n");
  }

  printf("Wall clock time = %f\n", seq_time);
  for(i = 0; i < I; i++) free(array[i]);
  free(array);
  return 0;
}

int compareFunc(const void* a, const void* b) {
   struct data *a1 = (struct data *)a;
   struct data *a2 = (struct data *)b;
   if((*a1).dist > (*a2).dist) return 1;
   else if((*a1).dist < (*a2).dist) return -1;
   else return 0;
}

void getData()
{
   int i,j;
   FILE *file = fopen("matFile.txt", "r");
   for(i = 0; i < I; i++){
      for(j = 0; j < J; j++)
      {
         fscanf(file, "%lf,", &a[i][j]);
      }
   }

    fclose(file);
}
