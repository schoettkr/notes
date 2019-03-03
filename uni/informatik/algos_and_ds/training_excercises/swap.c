#include <stdlib.h>
#include <stdio.h>

void swap(double*, double*);

int main(int argc, char* argv[]) {

  if (argc != 3) {
    printf("Not enough data!\n");
    return -1;
  }


  double x = atof(argv[1]);
  double y = atof(argv[2]);

  swap(&x,&y);

  return 0;
}

void swap(double *x, double *y) {
  *x = *x + *y;
  *y = *x - *y;
  *x = *x - *y;
  
  printf("%.3f %.3f\n", *x, *y);
}
