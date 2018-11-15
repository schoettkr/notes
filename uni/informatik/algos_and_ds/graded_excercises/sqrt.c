#include <stdio.h>
#include <limits.h>
unsigned long int heron(unsigned long int, unsigned long int);
unsigned long int squareroot(unsigned long int );

int main () {
  squareroot(ULONG_MAX);
  squareroot(81);
  squareroot(12345);
  squareroot(9999);

  /* unsigned long res = squareroot(ULONG_MAX); */
  /* printf("%lu\n", res); */
  return 0;
}

unsigned long int squareroot(unsigned long int val)
{
  if (val == 0) return 0;
  /* unsigned long startVal = (unsigned long)(((long double) val / 2.0 + 1)); */

  unsigned long startVal;
  if (val % 2 == 0) {
    startVal = (val + 1) / 2;
  } else {
    startVal = val / 2;
  }



  unsigned long res = heron(startVal, val);


  printf("%lu\n", res);
  return res;
}

unsigned long int heron(unsigned long int lastApprox, unsigned long int sourceNum)
{
  unsigned long int currentApprox = 0.5 * (lastApprox + (sourceNum/lastApprox));

  if (currentApprox >= lastApprox) return currentApprox;
  else return heron(currentApprox, sourceNum);
}
