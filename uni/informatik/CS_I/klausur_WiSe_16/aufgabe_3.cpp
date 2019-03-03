#include <iostream>

using namespace std;

int main() {
  struct wetterdaten {
    int datum;
    float temp;
    char wetter[50];
    float regen;
  };
  wetterdaten juni[30];
  wetterdaten uno = {1, 20.5, "Sonne", 10};
  juni[0] = uno;
  wetterdaten dos = {2, 28.5, "Sonne", 20};
  juni[1] = dos;
  wetterdaten tres = {3, 33.5, "Sonne", 8};
  juni[2] = tres;
  wetterdaten cuatro = {4, 13.8, "Regen", 55};
  juni[3] = cuatro;
  wetterdaten cinco = {0};
  juni[4] = cinco;

  float d_temp = 0;
  int tage = 0;
  string regen = "Regen";
  for (int i = 0; juni[i].datum != 0 && i < 30; i++) {
    wetterdaten current = juni[i];
    // if (current.wetter != "Regen") {
    if (regen.compare(current.wetter) != 0) {
      d_temp += current.temp;
      tage++;
    }
  }
  d_temp /= tage;

  cout << "Durchschnitsstemp = " << d_temp << endl;

  return 0;
}
