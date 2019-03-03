#include <iostream>

using namespace std;

int qp(int);
int beharrlichkeit(int);

int main() {
  int currentNum = 0;
  int currentMaxBh = 0;
  for (int i = 1000000; i < 2000000; i++) {
    int res = beharrlichkeit(i);
    if (res > currentMaxBh) {
      currentMaxBh = res;
      currentNum = i;
    }
  }
  cout << "Num = " << currentNum << endl;
  cout << "Beharrlichkeit = " << currentMaxBh << endl;

  return 0;
}

int beharrlichkeit(int a) {
  int bh = 0;
  while (a > 9) {
    a = qp(a);
    bh++;
  }

  return bh;
}

int qp(int zahl) {
  int res = 1;
  while (zahl > 0) {
    res *= zahl % 10;
    zahl /= 10; 
  }
  return res;
}

