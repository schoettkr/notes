#include <iostream>

using namespace std;

void eratosthenes (int, int&, int&);
void nIntervalls(void);
void printFormattedLine(int, int, int);
void printPrimeArr(int* arr, int size);

int main() {
  nIntervalls();
  return 0;
}

// A.)
void eratosthenes (int N, int &P, int &S) {
  P = 0, S = 0;
  int *primes = new int[N-1]();

  for (int i = 2; i < N-1; i++) {
    if (primes[i-2] == 1) continue;
    int number = i;
    if ((number * number) > N) break;
    for (int k = i*i; k <= N; k += number) {
      primes[k-2] = 1;
      S++;
    }
  }

  for (int i = 0; i < N-1;  i++) {
    if (primes[i] == 0) P++;
  }
  delete [] primes;
}

void printHeading();
// B.)
void nIntervalls() {
  printHeading();
  for (int i = 2; i <= 20; i++) {
    int N = 1 << i;
    int P = 0, S = 0;
    eratosthenes(N, P, S);
    cout.width(8);
    printFormattedLine(N, P, S);
  }
}

void printFormattedLine(int N, int P, int S) {
  cout.width(8);
  cout << right << N;
  cout.width(8);
  cout << right << P;
  cout.width(8);
  cout << right << S;
  cout << endl;
}

void printHeading() {
  cout.width(8);
  cout << right << 'N';
  cout.width(8);
  cout << right << 'P';
  cout.width(8);
  cout << right << 'S';
  cout << endl;
}

void printPrimeArr(int* arr, int size) {
  int i = 0;
  while (i < size) {
    if (arr[i] == 0) {
      cout << i+2 << endl;
    }
    i++;
  }
}
