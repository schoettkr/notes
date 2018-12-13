typedef unsigned long size_t;
#define NULL 0L

extern int printf(const char *restrict __format, ...);
extern void *malloc(size_t);
extern void *calloc(size_t, size_t);
extern void *realloc (void *, size_t);
extern void free (void *);

typedef struct charset {
  unsigned char bits[7];
} charset_t;

typedef enum { CS_UNION,  // Vereinigung
               CS_CUT,    // Schnitt
               CS_SYMDIFF // Symmetrische Differenz 
} csopt_t;

charset_t *charset_new(const char* elements);
int        charset_op(charset_t* s1, const charset_t *s2, csopt_t op);
char      *charset_tos(const charset_t* s);
charset_t* copyChset(const charset_t* );

// Task 1
charset_t* charset_new (const char* elements) {
  charset_t* newSet = malloc(sizeof(charset_t));

  for (int i = 0; elements[i] != '\0'; ++i) {
    char ch = elements[i];
    if (!(ch >= 65 && ch <= 90) && !(ch >= 97 && ch <= 122)) { // ensure alphabetical character
      continue;
    }

    int shift = ch <= 90 ? 65 : 97;
    int bitPosition = (ch - shift)*2; // is the position in sequential memory layout
    if (shift == 97) ++bitPosition; // lowercase letters after uppercase

    unsigned char mask = 1 << (bitPosition % 8); // bit to set (mod by 8 -> individual char arrays)
    int byteIndex = bitPosition / 8;

    
    newSet->bits[byteIndex] = newSet->bits[byteIndex] | mask;
  }

  return newSet;
}

// Task 2
// 0 on success, -1 on failure (null pointers, invalid op)
// s1 is target
int charset_op(charset_t* s1, const charset_t *s2, csopt_t op) {
  if (s1 == NULL || s2 == NULL) return -1;

  if (op == CS_UNION) {
    for (int i = 0; i < 7; ++i) {
      s1->bits[i] = s1->bits[i] | s2->bits[i];
    }
  } else if (op == CS_CUT) {
    for (int i = 0; i < 7; ++i) {
      s1->bits[i] = s1->bits[i] & s2->bits[i];
    }
  } else if (op == CS_SYMDIFF) {
    for (int i = 0; i < 7; ++i) {
      s1->bits[i] = s1->bits[i] ^ s2->bits[i];
    }
  } else return -1;
  
  return 0;
}

// Task 3 Set to String (alphabeitsch sortiert, groß vor klein Aa, Bb, Cc..)
char* charset_tos(const charset_t* s) {

  // Determine size of string
  charset_t* cp = copyChset(s);
  int size = 0;
  for (int i = 0; i < 7; ++i) {
    while (cp->bits[i]) {
      size += cp->bits[i] & 1;
      cp->bits[i] >>= 1;
    }
  }
  free(cp);

  // Allocate size memory for string
  char* string = (char*) malloc(size);

  for (int b = 0, j = 0; b < 7; ++b) {
    for (int i = 0, flag = 1; i < 8; ++i, flag <<= 1) {
      char letter = (s->bits[b] & flag);
      if (letter) {
        char shift = i % 2 ? 97 : 65;
        char ascii = shift + b * 4 + i/2;
        string[j++] = ascii;
      }
    }
  }

  return string;
}

int main() {
  /* charset_t* pama = charset_new("AaBbCcZzLlMmWwXxYyZz"); */
  charset_t* pama = charset_new("ABCabZcHz");
  /* charset_t* pama = charset_new("ABBBbba"); */
  /* charset_t* pama = charset_new("ABCDEFGHIJKLMNOPQRSTUVWXYZ"); */
  /* charset_t* pama = charset_new("abcdefghijklmnopqrstuvwxyz"); */
  /* charset_t* pama = charset_new("ABC"); */

  char* st = charset_tos(pama);
  printf("%s\n", st);

  /* free(pama); */
  return 0;
}

// Helper function to copy charset
charset_t* copyChset(const charset_t* s) {
  charset_t* newSet = (charset_t*)malloc(sizeof(charset_t));

  for (int i = 0; i < 7; ++i) {
    newSet->bits[i] = s->bits[i];
  }

  return newSet;
}
