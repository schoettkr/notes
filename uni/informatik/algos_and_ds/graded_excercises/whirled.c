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
const char* iterateChars(const char*, int direction, const char* originalStartP);

const char *whirled(const char * const str)
{
  iterateChars(str, 1, str);

  return str;
}

// direction = 1 forward
// direction = -1 backward
const char* iterateChars(const char* str, int direction, const char* originalStartP) {
  if (direction == 1 && *str == 0) {
    /* printf("\nEncountered delimiter\n"); */
    // reached end of charr
    return iterateChars(--str, -1, originalStartP);
  } else if (direction == -1 && str == originalStartP) {
    /* printf("\nReached start at %d\n", *originalStartP); */
    printf("%c", shiftLetter(*str));
    return str;
  }

  if (direction == 1) {
    /* printf("%c", shiftLetter(*str)); */
    return iterateChars(++str, 1, originalStartP);
  } else if (direction == -1) {
    printf("%c", shiftLetter(*str));
    return iterateChars(--str, -1, originalStartP);
  }

  return str;
}

char shiftLetter(char letter) {
  char lowBound;

  if (letter >= 65 && letter <= 90) lowBound = 65;
  else if (letter >= 97 && letter <= 122) lowBound = 97;
  else return letter;

  char shiftedLetter = letter + 25 - 2*(letter - lowBound);

  return shiftedLetter;
}
