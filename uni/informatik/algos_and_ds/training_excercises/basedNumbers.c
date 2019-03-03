#include <stdio.h>
#include <stdlib.h>

typedef struct {
  char *arr;
  unsigned int base;
} basedNumber;

unsigned int sumOfBasedNumbers (basedNumber bn[], unsigned int size);
unsigned int charToDecimal(char ch);
unsigned int expo(unsigned int, unsigned int);
int length(char* arr);
unsigned int basedToDecimal(char* arr, unsigned int base);

/* int main(int argc, char* argv[]) { */
/*   basedNumber bn[] = {{"100", 10}, {"FF", 16}} ; */

/*   unsigned int res = sumOfBasedNumbers(bn, 2); */
/*   printf("%i", res); */
/*   return 0; */
/* } */


unsigned int sumOfBasedNumbers(basedNumber bn[], unsigned int size) {
  unsigned int sum = 0;
  for (int i = 0; i < size; i++) {
    sum += basedToDecimal(bn[i].arr, bn[i].base);
  }
  
  return sum;
}

unsigned int charToDecimal(char ch) {
  if (ch <= 57) return ch-48;
  if (ch < 97) {
    return ch - 55;
  }
  return ch - 87;
}

unsigned int basedToDecimal(char* arr, unsigned int base) {
  unsigned int decimal = 0;
  int len = length(arr);
  for (int i = 0; arr[i] != '\0'; i++) {
    decimal += charToDecimal(arr[i]) * expo(base, len-i-1);
  }
  return decimal;
}

unsigned int expo(unsigned int num, unsigned int exponent) {
  unsigned int res = 1;
  while (exponent--) res *= num;
  return res;
}

int length(char* arr) {
  int l = 0;
  for (int i = 0; arr[i] != '\0'; i++) {
    l++;
  }
  return l;
}


/* {”FF”, 16}, {”100”, 10 } */

/* {”FF”, 16}, {”100”, 8 } waere 64 */

/* Basis immer größer 1 und kleiner 36 i */


/* 1. To decimal */
/* F*16^1 + F*16^0 = 15*16 + 15*1 */
/* 1.1 Buchstaben to decimal */

/* 1.2 Decimal * basis hoch stelle - 1 */
/* for schleife bis \0 i faengt bei 0 an ist zaehler und laenge - i =exponent */
