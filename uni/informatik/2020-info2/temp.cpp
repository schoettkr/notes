#include <iostream>
using namespace std;

int main(int argc, char *argv[]) {
  int upperLimit = 0;
  cout << "Enter upper limit for primes: ";
  cin >> upperLimit;
  cout << endl;

  char* nums = new char[upperLimit];
  for (int i = 0; i < upperLimit; i++) {
    nums[i] = 0;
  }

  for (int i = 2; i < upperLimit - 2; i++) { // alt.: i < sqrt(upperlimit)
    if (nums[i-2] != 0) {
      continue; // already marked
    } else {
      for (int j = i+i; j < upperLimit - 2; j += i) {
        nums[j-2] = 1;
      }
      cout << i << "|";
    }
  }
  cout << endl;

  delete[] nums;

  return 0;
}
