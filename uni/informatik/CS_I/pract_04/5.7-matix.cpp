#include <iostream>

using namespace std;

int main() {
  const int rows = 5;
  const int cols = 3;

  int A[rows][cols], B[rows][cols];

  // Populate Matrix A with values 1-3 in each column
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      A[i][j] = j+1;
    }
  }

  // Spaltensummen
  for (int i = 0; i < rows; i++) {
    int sum = 0;
    for (int j = 0; j < cols; j++) {
      sum += A[i][j];
    }
    cout << "Spaltensumme(" << (i + 1) << ") " << sum << endl;
  }

  // Elementweise quadrieren und in B
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int squared = A[i][j] * A[i][j];
      B[i][j] = squared;
    }
  }
  // cout << B[4][2] << endl;

  // Matrix C als Ergebnis der elementweisen Addition von A und B
  int C[rows][cols];
  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      int sum = A[i][j] + B[i][j];
      C[i][j] = sum;
    }
  }
  // cout << C[4][2] << endl;

  for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
      cout << C[i][j] << "\t";
    }
   cout << "\n";
  }


  
}
