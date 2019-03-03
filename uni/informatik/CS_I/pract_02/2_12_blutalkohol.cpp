#include <iostream>

using namespace std;

int main ()
{
  int mililiter;
  cout << "How much did you drink (ml)?\n";
  cin >> mililiter;

  float volume;
  cout << "How much volume (%) does the booze have?\n";
  cin >> volume;

  float bodyweight;
  cout << "Finally, how much do you weigh (kg)?\n";
  cin >> bodyweight;

  float absorbedAlcohol = mililiter * (volume  / 100.0) * 0.8;
  float BAK = absorbedAlcohol / (bodyweight * 0.62);
  
  cout << "BAK = " << BAK << endl;
  return 0;
}
