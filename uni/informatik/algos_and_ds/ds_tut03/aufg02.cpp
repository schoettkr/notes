#include <iostream>
using namespace std;

void readString(void);

int main() {
  readString();

  // while (true) {
  //   ch = getchar();
  //   cout << ch << endl;
  //   if (ch == '\n') break;
  // }

  return 0;
}

void readString() {
  char c = 0;
  char *s_old = 0, *s_new = 0;
  int count = 0;
  int length = 0;
  do {
    c = getchar();
    s_new = new char[count+1];
    for (int i = 0; i < count; i++) {
      s_new[i] = s_old[i];
    }
    s_new[count++] = c;
    delete[] s_old;
  } while (c != '\n');

  printf("%s", s_new);
}
