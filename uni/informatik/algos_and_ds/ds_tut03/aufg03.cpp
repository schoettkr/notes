#include <iostream>
using namespace std;

double** generateMatrix(int N, int M);

int main() {
  double random = rand() % 100;

  return 0;
}

double** generateMatrix(int N, int M) {
  double** matrix = new double* [N];
  for (int i = 0; i < N; i++) {
    matrix[i] = new double[M];
  }

  return matrix;
}

double** transposeMatrix(int N, int M, double** matrix) {
  double** new_matrix = generateMatrix(M, N);
  for (int i = 0; i < N; i++) {
    for (int k = 0; k < M; k++) {
      new_matrix[k][i] = matrix[i][a];
    }
  }

  return new_matrix;
}

void printMatrix(int N, int M, double** matrix) {
  for (int rows = 0; rows < N; rows++) {
    for (int cols = 0; cols < M; cols++) {
      printf("%f", matrix[rows][cols]);
    }
    printf("\n");
  }
}
