#include <stdlib.h>

unsigned int rom2arab(char* rom) {
  int num = 0, i = 0;

  while (rom[i] != '\0') {
    char letter = rom[i];

    if (letter == 'M') {
      num += 1000;
    } else if (letter == 'D') {
      num += 500;
    } else if (letter == 'C') {
      num += 100;
    } else if (letter == 'L') {
      num += 50;
    } else if (letter == 'X') {
      num += 10;
    } else if (letter == 'I') {
      num += 1;
    }

    i++;
  }

  return num;
}

char* arab2rom(unsigned int arab) {
  unsigned int copy = arab;
  int requiredChars = 0;
  while (arab > 0) {
    requiredChars += arab / 1000;
    arab %= 1000;

    requiredChars += arab / 500;
    arab %= 500;

    requiredChars += arab / 100;
    arab %= 100;

    requiredChars += arab / 50;
    arab %= 50;

    requiredChars += arab / 10;
    arab %= 10;

    requiredChars += arab / 5;
    arab %= 5;

    requiredChars += arab / 1;
    arab %= 1;
  }

  char* romeNum = (char*) malloc(sizeof(char)*requiredChars+1);
  romeNum[requiredChars] = '\0';

  for (int i = 0; i < requiredChars; i++) {
    if (copy / 1000) {
      romeNum[i] = 'M';
      copy -= 1000;
    } else if (copy/500){
      romeNum[i] = 'D';
      copy-= 500;
    } else if (copy/100){
      romeNum[i] = 'C';
      copy-= 100;
    } else if (copy/50){
      romeNum[i] = 'L';
      copy-= 50;
    } else if (copy/10){
      romeNum[i] = 'X';
      copy-= 10;
    } else if (copy/5){
      romeNum[i] = 'V';
      copy-= 5;
    } else if (copy/1){
      romeNum[i] = 'I';
      copy-= 1;
    }
  }

  return romeNum;
}
