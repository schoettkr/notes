#include <iostream>

using namespace std;

int main ()
{
  int freeFallTime;
  float earthAcceleration = 9.81, speed, distance;
  cout << "Bitte Zeitdauer in Sekunden im freien Fall eingeben\n";
  cin >> freeFallTime;

  speed = freeFallTime * earthAcceleration;
  distance = 0.5 * earthAcceleration * (freeFallTime * freeFallTime);


  cout << "Geschwindigkeit = " << speed << endl;
  cout << "Zurück gelegte Strecke = " << distance << endl;

  return 0;
}
