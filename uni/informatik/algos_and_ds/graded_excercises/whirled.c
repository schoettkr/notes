int printf(const char * restrict, ...);

void *malloc(unsigned long);

const char *whirled(const char * const str); // Deklaration der Aufgabenfunktion

/* int main(int carg, const char **varg){ */
/*   if (carg != 2) return -1; // ein Parameter uebergeben? */
/*   printf("Die verwürfelte Version von \"%s\" ist \"%s\".\n", // gibt Ergebnis aus */
/*          varg[1],whirled(varg[1])); */
/*   return 0; // 0 bedeutet alles okay */
/* } */
// Ihr Code ab hier

int main(int argc, const char **argv) {
  if (argc != 2) return -1;
  whirled(argv[1]);

  return 0;
}

char shiftLetter(char);
const char* iterateChars(const char*);

const char *whirled(const char * const str)
{
  iterateChars(str);

  return str;
}

const char* iterateChars(const char* str) {
  if (*str == 0) {
    printf("\nEncountered delimiter\n");
    return str;
  }

  printf("%c", shiftLetter(*str));
  return iterateChars(++str);
}

char shiftLetter(char letter) {
  char lowBound;

  if (letter >= 65 && letter <= 90) lowBound = 65;
  else if (letter >= 97 && letter <= 122) lowBound = 97;
  else return letter;

  char shiftedLetter = letter + 25 - 2*(letter - lowBound);

  return shiftedLetter;
}
