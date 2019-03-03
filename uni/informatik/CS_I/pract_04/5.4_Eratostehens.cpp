#include <iostream>

using namespace std;


int main() {

  int S = 20;

  bool primes[S];
  int i = 0;

  for(i = 0; i < S; ++i) {
    primes[i] = true;
  }

  for(i = 2; i < S; ++i) {
    if (primes[i]) {
      for(int current = i+i; current < S; current = current+i) {
        primes[current] = false;
      }
    }
  }


  for(int i = 2; i < S; ++i) {
    cout << "Zahl: " << (i) << "| Prim " << (primes[i] ? "true" : "false") << endl;
  }

  // 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53


  return 0;
}
