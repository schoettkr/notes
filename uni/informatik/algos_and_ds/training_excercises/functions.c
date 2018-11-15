#include <stdio.h>
/* unsigned int checksum1(unsigned int n) Quersumme von n in Dezimalschreibweise. */

unsigned int checksum1(unsigned int);
unsigned int digits(unsigned int);
unsigned int sumOdd(unsigned int);
unsigned int sum(unsigned int);

int main()
{

  printf("Sum: %d\n", sum(5));
  printf("Sum: %d\n", sum(10));

  printf("Odd sum: %d\n", sumOdd(5));
  printf("Odd sum: %d\n", sumOdd(10));

  printf("Digits: %d\n", digits(1));
  printf("Digits: %d\n", digits(10));
  printf("Digits: %d\n", digits(14));
  printf("Digits: %d\n", digits(28));
  printf("Digits: %d\n", digits(100));
  printf("Digits: %d\n", digits(101));
  printf("Digits: %d\n", digits(1201));
  printf("Digits: %d\n", digits(9999));
  checksum1(770);
  checksum1(66);
  checksum1(550);

  checksum1(554);
  checksum1(5);
  checksum1(6);
  return 0;
}

unsigned int checksum1(unsigned int n)
{

  unsigned int digitSum = 0;
  unsigned int quotient = 1;
  unsigned int remainder = 0;

  while (quotient > 0){
    quotient = n / 10;
    remainder = n % 10;
    n = quotient;
    digitSum += remainder;
  }

  return digitSum;
}

unsigned int digits(unsigned int n)
{
  int length = 1;

  while (n > 9) {
    length++;
    n = n/10;
  }

  return length;
}

unsigned int sumOdd(unsigned int n)
{
  
  unsigned int oddSum = 0;

  /* for (int i = 1; i <= n; i += 2) { */// dangerours approach but least control sequences / assembly
  /*   sum += i; */
  /* } */


  for (int i = 0; i <= n; i++) {
    if (i % 2 != 0) oddSum += i;
  }

  return oddSum;
}

unsigned int sum(unsigned int n)
{
  unsigned int sum = 0;
  for (int i = 1; i <= n; i++) { // theoretically n could be 0 ! so i = 1 holds danger
    sum += i;
  }
  return sum;
}
