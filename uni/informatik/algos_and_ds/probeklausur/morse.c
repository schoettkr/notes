#include <stdlib.h>
#include <stdio.h>

char translate(char*, int, int);

char* parse_morese(char* morsecode) {
  int j = 0, translationSize = 1; // hier hatte ich 0 war falsch weil die foor loop sonst den letzten buchstabend nicht mitzaehlt
  for (int i = 0; morsecode[i] != '\0'; i++) {
    if (morsecode[i] == ' ') translationSize++;
  }
  char * translation = (char*)malloc(sizeof(char)*translationSize + 1);
  for (int i = 0; i < translationSize; i++) {
    int charstart = j, charend = j;
    while (morsecode[charend] != ' ' && morsecode[charend] != '\0') charend++;
    j = charend + 1;
    char letter = translate(morsecode, charstart, charend-1);
    translation[i] = letter;
  }
  translation[translationSize] = '\0';
  return translation;
}

char translate(char* code, int start, int end) {
  if (code[end] == '-') {
    if (code[start] == '*') return 'A';
    return 'O';
  }
  if (code[start] == '-') return 'G';
  if (code[start+1] == '-') return 'L';
  return 'S';
}

int main() {
  char* lesecret = parse_morese("--- *-** --* *-");
  printf("%s\n", lesecret);
  lesecret = parse_morese("--* *-** *- ***");
  printf("%s\n", lesecret);
  lesecret = parse_morese("*** ---");
  printf("%s\n", lesecret);


  return 0;
}
