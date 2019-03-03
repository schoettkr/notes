#include <stdlib.h>
#include <stdio.h>

unsigned int binom (unsigned int, unsigned int);

int main(int argc, char* argv[]) {

  int n, k;
  if (argc != 3 || (n = atoi(argv[1])) < 0 || (k = atoi(argv[2])) < 0) {
    printf("wrong range\n");
    return 0; 
  }

  unsigned int res = binom(n, k);

  printf("%d choose %d = %d\n", n, k, res);
  return 0;
}

unsigned int binom(unsigned int n, unsigned int k) {
  if (k == 0 || k == n) return 1;

  return binom(n-1, k-1) + binom(n-1, k);
}
