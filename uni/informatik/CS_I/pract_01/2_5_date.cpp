#include <iostream>

using namespace std;

int main()
{
  int  day, month, year, date;
  cout << "Please enter a date in the format DDMMYYYY: ";
  cin >> date;

  day = date / 1000000;
  month = (date / 10000) - day * 100;
  year = date - (date / 10000) * 10000;

  cout << "\n Day: " << day;
  cout << "\n Month: " << month;
  cout << "\n Year: " << year << endl;

  return 0;
}
