int printf(const char * restrict, ...);

void *malloc(unsigned long);

const char *whirled(const char * const str); // Deklaration der Aufgabenfunktion

int main(int carg, const char **varg){
  if (carg != 2) return -1; // ein Parameter uebergeben?
  printf("Die verwürfelte Version von \"%s\" ist \"%s\".\n", // gibt Ergebnis aus
         varg[1],whirled(varg[1]));
  return 0; // 0 bedeutet alles okay
}
// Ihr Code ab hier

char shiftLetter(char);

int charrLength(const char* str, int length) {
  if (*str == 0) {
    return ++length; // add one for delimiting 0
  }

  return charrLength(++str, ++length);
}

void shiftCharr(char * currentCharP, const char * endOfCharr, const  char* originalCharP) {
  if (*originalCharP == 0) {
    return;
  }

  *currentCharP = shiftLetter(*endOfCharr);

  shiftCharr(++currentCharP, --endOfCharr, ++originalCharP);
}

char shiftLetter(char letter) {
  char lowBound;

  if (letter >= 65 && letter <= 90) lowBound = 65;
  else if (letter >= 97 && letter <= 122) lowBound = 97;
  else return letter;

  char shiftedLetter = letter + 25 - 2*(letter - lowBound);

  return shiftedLetter;
}

const char* whirled(const char * const str)
{
  int size = charrLength(str, 0);
  char * whirledCharr = (char*)malloc(size);

  /* eg str =0x10 -> a; 0x11 -> b; 0x12 -> c; 0x13 -> \0 
   size = 4 but last usable char is at str + size - 2 */
  const char * endOfCharr = str+size-2; 

  shiftCharr(whirledCharr, endOfCharr, str);

  return whirledCharr;
}
