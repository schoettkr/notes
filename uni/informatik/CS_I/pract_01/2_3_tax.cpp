#include <iostream>

using namespace std;

int main()
{
  float netto, brutto, taxrate, tax;

  cout << "Please enter a taxrate: ";
  cin >> taxrate;

  cout << "\nPlease enter a netto value: ";
  cin >> netto;

  brutto = netto * (1 + taxrate);
  cout << "\n The brutto value is: " << brutto;

  tax = netto * taxrate;
  cout << "\n The tax amounts to: " << tax << endl;

  return 0;
}
