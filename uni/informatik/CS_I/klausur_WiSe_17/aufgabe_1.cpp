#include <iostream>
#include <fstream>

using namespace std;

int findWord(char matrix[12][12]);
void printLine(char matrix[12][12], int row);

int main() {
  ifstream file("wort.txt");
  if (!file) {
    cout << "Couldnt open file";
    return -1;
  }
  char rm [12][12];
  for (int row = 0; row < 12; row++) {
    for (int col = 0; col < 12; col++) {
      // Important 1
      file >> rm[row][col];
    }
  }

  printLine(rm,findWord(rm));

  return 0;
}

int findWord(char matrix[12][12]) {
  string word;
  cout << "Please enter search word:\n";
  cin >> word;

  // Important 2
  if (word.length() == 0 || word.length() > 12) return -1;

  for (int row = 0; row < 12; row++) {
    for (int col = 0; col < 12; col++) {
      if (matrix[row][col] == word[0]) {
        for (int i = 0; i < word.length(); i++) {
          if (matrix[row][col+i] != word[i]) break;
          if (i == word.length()-1) {
            cout << "Found word at row " << row << " column " << col << endl;
            return row;
          }
        }
      }
    }
  }
  cout << "Didnt find word\n";
  return -1;
}

void printLine(char matrix[12][12], int row) {
  if (row == -1) return;
  for (int col = 0; col < 12; col++) {
    cout << " ";
    cout << matrix[row][col];
    cout << " ";
  }
  cout << endl;
}
