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

    int shift = ch <= 90 ? 65 : (97-26);
    int bitPosition = ch - shift; // is the position in sequential memory layout

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

  for (int b = 0, j = 0; b < 4; ++b) {
    for (int i = 0, flag = 1; i < 8; flag <<= 1, ++i) {
      if (b == 3 && i > 3) break; // iterated through all possible uppercase letters

      char letter = (s->bits[b] & flag);
      letter = letter ? i + 65 + b*8 : 0;

      if (letter >= 65 && letter <= 90) { // set uppercase letter
        printf("%c\n", letter);
        string[j] = letter;
        j++;
      }

      if (b == 0) {
        char bit = s->bits[b+3] & (1 << (i+1));
        if (bit) {
          char pos = -1;
          while (bit > 1 || bit < -1) {
            bit /= 2;
            pos++;
          }
          if (!pos) continue;
          char ascii = pos+96;
          printf("%c\n", ascii);
        }
      } else {
        char bit = s->bits[b+3] & (1 << i);
        if (bit) {
          char pos = 0;
          while (bit > 1 || bit < -1) {
            bit /= 2;
            pos++;
          }
          char ascii = 98 + 5 + (b-1) * 8 + pos;
          printf("%c\n", ascii);
        }
      }
    }
  }
  
  printf("determined size: %d\n", size);

  return string;
}

int main() {
  charset_t* pama = charset_new("AaBbCcZzLlMmWwXxYyZz");

  char* st = charset_tos(pama);
  printf("%s\n", st);

  free(pama);
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
