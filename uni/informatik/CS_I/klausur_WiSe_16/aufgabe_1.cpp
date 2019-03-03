#include <iostream>
using namespace std;

int main() {
  int arrSize = 10;
  int arr[arrSize] = {1,2,3,4,3,2,5,6,2,1};

  int teilfolgen = 0;

  for (int col = 0; col < arrSize-1; col++) {
    int seqLength = 0;
    int i = 0;
    while (arr[col+i] < arr[col+i+1]) {
      seqLength++;
      i++;
    }
    if (seqLength != 0) {
      teilfolgen++;
      col += seqLength;
    }
  }
  for (int col = 0; col < arrSize-1; col++) {
    int seqLength = 0;
    int i = 0;
    while (arr[col+i] > arr[col+i+1]) {
      seqLength++;
      i++;
    }
    if (seqLength != 0) {
      teilfolgen++;
      col += seqLength;
    }
  }
 
  cout << "Anzahl Teilfolgen = " << teilfolgen << endl;

  return 0;
}
