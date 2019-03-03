#include <iostream>
#include <iomanip>

using namespace std;

int main()
{
  int seconds;
  cout << "Please enter seconds that you want to convert to HH:MM:ss\n";
  cin >> seconds;

  // int hours = seconds / 3600;
  // seconds = seconds - 3600 * hours;
  // int minutes = seconds / 60;
  // seconds = seconds - 60 * minutes;

  int hours = seconds / 3600;
  int minutes = seconds % 3600 / 60;
  seconds =  seconds % 3600 % 60;

  // cout << hours << ":" << minutes << ":" << seconds;
  cout << internal << setfill('0') << setw(2) << hours << ":" <<  setw(2) << minutes << ":" << setw(2) << seconds << endl;

  return 0;
}
