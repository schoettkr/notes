#include <iostream>
#include <iomanip>

using namespace std;

int main() {
  int rm[4][10];

  for (int i = 0; i < 10; i++) {
    cout << "Bitte Wert fuer letzte Reihe, Spalte " << i+1 << " eingeben\n";
    cin >> rm[3][i];
  }

  rm[0][0] = 1;
  rm[1][9] = 121;

  for (int row = 0; row < 2; row++) {
    for (int col = 0; col < 10; col++) {
      if ((row == 0 && col == 0) || (row == 1 && col == 9)) continue;
      if (row == 0) {
        rm[row][col] = rm[row][col-1] + col + 1;
      }
      if (row == 1) {
        rm[row][col] = rm[row-1][col] + rm[row-1][col+1];
      }
    }
  }

  rm[2][0] = 0;
  for (int col = 1; col < 10; col++) {
    rm[2][col] = (rm[0][col]*rm[0][col]) - (rm[0][col-1]*rm[0][col-1]);
  }

  int summen[10];
  for (int col = 0; col < 10; col++) {
    int colsum = 0;
    for (int row = 0; row < 4; row++) {
      colsum += rm[row][col];
    }
    summen[col] = colsum;
  }

  for (int i = 0; i < 10; i++) {
    cout << setfill('.') << setw(5) << summen[i];
    cout << " ";
  }
  cout << endl;

  return 0;
}
