#include <iostream>
using namespace std;

int* removeNegativesAddDoubles(int*);

int main() {
  int start[7]  = {1,-5,2,3,4,5,0};

  int* res = removeNegativesAddDoubles(start);
  
  cout << res[0] << ", " << res[1] << endl;
  cout << res[2] << ", " << res[3] << endl;
  cout << res[4] << ", " << res[5] << endl;
  delete [] res;
  return 0;
}

int* removeNegativesAddDoubles(int* numbers) {
  int requiredSpace = 1;
  for (int i = 0; numbers[i] != 0; i++) {
    if (numbers[i] > 0) requiredSpace += 2;
  }

  cout << requiredSpace << endl;
  int* result = new int[requiredSpace];
  for (int k = 0, i = 0; numbers[i] != 0; i++) {
    if (numbers[i] > 0) {
      result[i+k] = numbers[i];
      k++;
      result[i+k] = numbers[i]*2;
    } else {
      k--;
    }
  }
  result[requiredSpace-1] = 0;

  return result;
}
