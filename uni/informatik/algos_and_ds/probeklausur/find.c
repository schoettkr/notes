#include <stdio.h>
#include <stdlib.h>

int stringLength(int count, const char* string) {
  if (string[count] == '\0') return count;
  return stringLength(++count, string);
}

int compareLetters(const char* word, const char* term, int index) {
  if (stringLength(0, word) != stringLength(0, term)) return -1;
  if (word[index] != term[index]) return -1;
  if (word[index] == '\0' && term[index] == 0) return 1;
  return compareLetters(word, term, ++index);
}

int compareWords(const char** words, const char* searchTerm, int index) {
  if (words[index][0] == '\0') return -1;
  int res = compareLetters(words[index], searchTerm, 0);
  if (res != -1) return index;
  return compareWords(words, searchTerm, ++index);
}


int main() {
  const char* bou[4] = {"Hund", "Katze", "Maus", ""};
  /* int len = stringLength(0, bou); */
  int pos = compareWords(bou, "Maus", 0);

  printf("%d\n", pos);

  return 0;
}
