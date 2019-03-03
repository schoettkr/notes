#include <stdlib.h>
#include <stdio.h>

int compareFromLetter(const char* text, const char* pattern, int pos) {
  for (int i = 0; pattern[i] != '\0'; i++) {
    if (text[pos+i] == '\0' || ((text[pos+i] != pattern[i]) && pattern[i] != '?')) {
      return 0;
    }
  }
  return 1;
}

int* grep(const char* pattern, const char* text) {
  int size = 1;
  int* positionen = (int*) malloc(sizeof(int)*size);
  if (positionen == NULL) return NULL;

  for (int i = 0; text[i] != '\0'; i++) {
    int result = compareFromLetter(text, pattern, i);
    if (result) {
      if (size != 1) {
        positionen = (int*) realloc(positionen, sizeof(int)*size);
        if (positionen == NULL) return NULL;
      }
      positionen[size-1] = i;
      size++;
    }
  }
  return positionen;
}

int main() {
  /* grep("komp","Inkompetenzkompensationskompetenz")= {2,11,24} */
  /* int* res = grep("komp","Inkompetenzkompensationskompetenz"); */
  /* int* res = grep("?a?","aaaaa"); */
  int* res = grep("Algo","Algorithmus");

  /* printf("%d %d %d\n", res[0], res[1], res[2]); */
  /* printf("%d %d\n", res[0], res[1]); */
  printf("%d\n", res[0]);

  free(res);
  return 0;
}
