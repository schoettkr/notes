#include <stdlib.h>
#include <stdio.h>

// MDCLXVI

char* arab2rom(unsigned int arab) {
  char* rom = (char*) malloc(sizeof(char)+1);
  if (rom == NULL) return NULL;
  int size = 1;

  /* size = 1: |M|\0|; */
  /* size = 2: |M|D|\0|; */
  for (int i = 0; arab; i++) {
    if (size > 1) {
      rom = (char*)realloc(rom, size+1);
      if (rom == NULL) return NULL;
    }
    if (arab >= 1000) {
      rom[size-1] = 'M';
      arab -= 1000;
    } else if (arab >= 500) {
      rom[size-1] = 'D';
      arab -= 500;
    } else if (arab >= 100) {
      rom[size-1] = 'C';
      arab -= 100;
    } else if (arab >= 50) {
      rom[size-1] = 'L';
      arab -= 50;
    } else if (arab >= 10) {
      rom[size-1] = 'X';
      arab -= 10;
    } else if (arab >= 5) {
      rom[size-1] = 'V';
      arab -= 5;
    } else if (arab >= 1) {
      rom[size-1] = 'I';
      arab -= 1;
    }

    size++;
  }
  rom[size-1] = '\0';
  return rom;
}

int main() {
  char* res = arab2rom(1557);

  printf("%s\n", res);

  free(res);
  return 0;
}


















/* char* arab2rom(unsigned int arab) { */
/*   if (arab < 0 || arab > 4999) return NULL; */
/*   int romSize = 0, copyArab = arab; */
/*   while (copyArab >= 1000) { */
/*     copyArab -= 1000; */
/*     romSize++; */
/*   } */
/*   while (copyArab >= 500) { */
/*     copyArab -= 500; */
/*     romSize++; */
/*   } */
/*   while (copyArab >= 100) { */
/*     copyArab -= 100; */
/*     romSize++; */
/*   } */
/*   while (copyArab >= 50) { */
/*     copyArab -= 50; */
/*     romSize++; */
/*   } */
/*   while (copyArab >= 10) { */
/*     copyArab -= 10; */
/*     romSize++; */
/*   } */
/*   while (copyArab >= 5) { */
/*     copyArab -= 5; */
/*     romSize++; */
/*   } */
/*   while (copyArab >= 1) { */
/*     copyArab -= 1; */
/*     romSize++; */
/*   } */

/*   char* romNum = (char*) malloc(romSize+1); */
/*   romNum[romSize] = '\0'; */

/*   for (int i = 0; i < romSize; i++) { */
/*     if (arab >= 1000) { */
/*       arab -= 1000; */
/*       romNum[i] = 'M'; */
/*     } else if (arab >= 500) { */
/*       arab -= 500; */
/*       romNum[i] = 'D'; */
/*     } else if (arab >= 100) { */
/*       arab -= 100; */
/*       romNum[i] = 'C'; */
/*     } else if (arab >= 50) { */
/*       arab -= 50; */
/*       romNum[i] = 'L'; */
/*     } else if (arab >= 10) { */
/*       arab -= 10; */
/*       romNum[i] = 'X'; */
/*     } else if (arab >= 5) { */
/*       arab -= 5; */
/*       romNum[i] = 'V'; */
/*     } else if (arab >= 1) { */
/*       arab -= 1; */
/*       romNum[i] = 'I'; */
/*     } */
/*   } */

/*   return romNum; */
/* } */
