#include <stdlib.h>
#include <stdio.h>
typedef struct { int start; int ende; } Interval;

/* (abbba, 2, 2) */
/* (abbba, 1, 3) */
/* (abbba, 0, 4) */
/* (abbba, -1, 5) abort */

Interval palindromCheck(const char* string, int beginValid, int endValid) {
  if (string[endValid] == '\0' || beginValid < 0 || string[beginValid] != string[endValid]) {
    Interval longest = {0,0};
    longest.ende = --endValid;
    longest.start = ++beginValid;
    return longest;
  }
  return palindromCheck(string, --beginValid, ++endValid);
}

Interval* paliHelper(const char* eingabe, Interval* currentLongest, int index) {
  if (eingabe[index] == '\0') {
    return currentLongest;
  }
  Interval temp = palindromCheck(eingabe, index, index);
  if (temp.ende - temp.start > currentLongest->ende - currentLongest->start) {
    currentLongest->start = temp.start;
    currentLongest->ende = temp.ende;
  }
  temp = palindromCheck(eingabe, index, index+1);
  if (temp.ende - temp.start > currentLongest->ende - currentLongest->start) {
    currentLongest->start = temp.start;
    currentLongest->ende = temp.ende;
  }

  return paliHelper(eingabe, currentLongest, ++index);
}

Interval* findLPalindrom(const char* eingabe) {
  Interval* currentLongest = (Interval*) calloc(1, sizeof(Interval));
  currentLongest = paliHelper(eingabe, currentLongest, 0);

  return currentLongest;
}

int main() {
  /* const char* p = "babad"; */
  /* const char* p = "abbba"; */
  const char* p = "sfnebenabbaottoassrentner";

  Interval* res = findLPalindrom(p);

  printf("%d bis %d\n", res->start, res->ende);

  free(res);
  return 0;
}
