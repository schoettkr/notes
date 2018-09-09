#include <iostream>

using namespace std;

int main()
{
  int  day, month, year;
  float date;
  cout << "Please enter a date in the format DDMMYYYY: ";
  cin >> date;

  day = date / 1000000;
  month = (int(date / 10000)) % day;
  // year = date / ((int(date) / 1000);

  cout << "\n Day: " << day;
  cout << "\n Month: " << month;
  cout << "\n Year: " << year;

  return 0;
}
