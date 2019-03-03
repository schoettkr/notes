#include <iostream>

using namespace std;

int reverse (int n) {
  int rev = 0;
  while (n) {
    rev = rev * 10 + (n%10);
    n /= 10;
  }
  return rev;
}

int main() {
  int results[21] = {0};
  int counter = 0;
  for (int i = 1; i < 100000000; i++) {
    if (i*4 == reverse(i)) {
      results[counter] = i;
      counter++;
    }
    if (counter == 21) break;
  }

  for (int i = 0; i < counter; i++) {
    cout << results[i] << " ";
  }
  cout << endl;

  return 0;
}
