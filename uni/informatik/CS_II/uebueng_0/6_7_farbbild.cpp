#include <iostream>
using namespace std;

struct pix {
  int r;
  int g;
  int b;
};

void seedFarbbild(pix farbbild[10][10]) {
  for (int row = 0; row < 10; row++) {
    for (int col = 0; col < 10; col++) {
      pix p;
      p.r = rand() % 256;
      p.g = rand() % 256;
      p.b = rand() % 256;
      farbbild[row][col] = p;
    }
  }
}

void printFarbbild(pix farbbild[10][10]) {
  for (int row = 0; row < 10; row++) {
    for (int col = 0; col < 10; col++) {
      pix p = farbbild[row][col];
      cout << "[" << p.r << ", " << p.g << ", " << p.b << "] ";
    }
    cout << "\n";
  }
}

int main() {
  pix farbbild[10][10];
  seedFarbbild(farbbild);
  printFarbbild(farbbild);
}
