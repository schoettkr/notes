#include <iostream>
#include <cstring>

using namespace std;

struct tier
{
  char art[20]; // Welches Tier?
  int gewicht; // Gewicht in kg
  float futtermenge; // Futtermenge in kg
};

int main() {
  tier raubkatze[20];
  tier a =  { "Puma", 50, 0.0};
  raubkatze[0] = a;
  tier b = { "Luchs", 4, 0.0};
  raubkatze[1] = b;
  tier c = { "Leopard", 30, 0.0};
  raubkatze[2] = c;
  tier d = { "Luchs", 4, 0.0};
  raubkatze[3] =  d;
  tier e = { "Simons Cat", 4, 0.0};
  raubkatze[4] = e;
  tier ende = {0};
  raubkatze[5] = ende;

  for (int i = 0; raubkatze[i].gewicht != 0 && i < 20; i++) {
    raubkatze[i].futtermenge = (raubkatze[i].gewicht / 3.0) * 1.5;
  }

  float futterLuxe = 0.0;
  int anzahlLuxe = 0;

  for (int i = 0; raubkatze[i].gewicht != 0 && i < 20; i++) {
    tier current = raubkatze[i];
    // if (strcmp(current.art, "Luchs") == 0) {
    if (strcmp(current.art, "Luchs") == 0) {
      futterLuxe += current.futtermenge;
      anzahlLuxe++;
    }
  }
  float futterProLux = futterLuxe/anzahlLuxe;
  int luxGehege = 22/futterProLux;
  cout << "Im Gehege leben " << luxGehege << " Luchse" << endl;
  

  return 0;
}
