#include <iostream>
using namespace std;

void summenformen() {
  int zahl;
  cout << "Bitte Zahl eingeben: ";
  cin >> zahl;
  cout << endl;

  int currentSum = 0;

  for (int i = 1; i <= zahl/2+1; i++) {
    int j = i;
    while (currentSum < zahl) {
      currentSum += j;
      j++;
    }
    // Important 1
    j--;

    if (currentSum == zahl) {
      for (int k = i; k < j; k++) {
        cout << k << " + ";
      }
      cout << j << endl;
    }
    // Important 2
    currentSum = 0;
  }
}

int main() {
  summenformen();

  return 0;
}
