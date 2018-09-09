#include <iostream>

using namespace std;

int main()
{
  int a, b;
  cout << "Please enter an integer for A\n";
  cin >> a;

  cout << "Please enter an integer for B\n";
  cin >> b;
  
  int quotient = a/b;
  int remainder = a%b;

  cout << "The quotient is " << quotient << "\n";
  cout << "The remainder is " << remainder << "\n";
  return 0;
}
