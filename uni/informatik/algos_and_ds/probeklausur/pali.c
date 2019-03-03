#include <stdlib.h>
#include <stdio.h>
typedef struct { int start; int ende; } Interval;

/* (abbba, 2, 2) */
/* (abbba, 1, 3) */
/* (abbba, 0, 4) */
/* (abbba, -1, 5) abort */

Interval palindromCheck(const char* string, int beginValid, int endValid) {
  while (beginValid >= 0 && string[endValid] != '\0' && string[beginValid] == string[endValid]) {
    beginValid--;
    endValid++;
  }

  Interval longest = {beginValid+1, endValid-1};

  return longest;
}

Interval* findLPalindrom(const char* eingabe) {
  Interval* currentLongest = (Interval*) calloc(1, sizeof(Interval));

  for (int i = 0; eingabe[i] != '\0'; i++) {
    Interval temp = palindromCheck(eingabe, i, i);
    if (temp.ende - temp.start > currentLongest->ende - currentLongest->start) {
      currentLongest->start = temp.start;
      currentLongest->ende = temp.ende;
    }
    temp = palindromCheck(eingabe, i, i+1);
    if (temp.ende - temp.start > currentLongest->ende - currentLongest->start) {
      currentLongest->start = temp.start;
      currentLongest->ende = temp.ende;
    }
  }

  return currentLongest;
}

int main() {
  /* const char* p = "babad"; */
  const char* p = "abbba";

  Interval* res = findLPalindrom(p);

  printf("%d bis %d\n", res->start, res->ende);

  free(res);
  return 0;
}
