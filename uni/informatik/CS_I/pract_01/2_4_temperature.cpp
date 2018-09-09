#include <iostream>

using namespace std;

int main()
{
  float fahrenheit, celsius;

  cout << "Please enter a temperature in fahrenheit that should be converted to celsius: ";
  cin >> fahrenheit;

  celsius = (fahrenheit - 32.0) * (5.0/9.0); // Attention: Do a float division else a multiplication with 0 will happen 

  cout << "\n" << fahrenheit << "F is equal to " << celsius << "C" << endl;
  return 0;
}
