#include <iostream>
using namespace std;

void herstellen(int drachen, int federn, int essenzen, int* stufe3, int* stufe2, int* stufe1) {
  if (drachen >= 8 && federn >= 10 && essenzen >= 8) {
    // Important to wrap in parens because else ++ happens first
    (*stufe3)++;
    drachen -= 8; federn -= 10; essenzen -= 8;
    return herstellen(drachen, federn, essenzen, stufe3, stufe2, stufe1);
  } else if (drachen >= 5 && federn >= 2 && essenzen >= 3) {
    // Important to wrap in parens because else ++ happens first
    (*stufe2)++; drachen -= 5; federn -= 2; essenzen -= 3;
    return herstellen(drachen, federn, essenzen, stufe3, stufe2, stufe1);
  } else if (drachen >= 2 && federn >= 1 && essenzen >= 1) {
    // Important to wrap in parens because else ++ happens first
    (*stufe1)++; drachen -= 2; federn -= 1; essenzen -= 2;
    return herstellen(drachen, federn, essenzen, stufe3, stufe2, stufe1);
  }
  return;
}

int shouldSell(float preisangebot, int anzahl) {
  if (preisangebot / anzahl < 128) return 0;
  return 1;
}

int main() {
  int stufe1 = 0, stufe2 = 0, stufe3 = 0, drachen, federn, essenzen; 

  cout << "Anzahl Drachenhaut?\n";
  cin >> drachen;

  cout << "Anzahl Federn?\n";
  cin >> federn;

  cout << "Anzahl Essenzen?\n";
  cin >> essenzen;

  herstellen(drachen, federn, essenzen, &stufe3, &stufe2, &stufe1);

  cout << "Stufe 3: " << stufe3 << endl;
  cout << "Stufe 2: " << stufe2 << endl;
  cout << "Stufe 1: " << stufe1 << endl;
  int gesamt = stufe3 + stufe2 + stufe1;
  cout << "Gesamt = " << gesamt << endl;

  cout << "Kommen wir num zum Verkauf\n";
  float preisangebot;
  cout << "Preisangebot?\n";
  cin >> preisangebot;

  int res = shouldSell(preisangebot, gesamt);

  if (res) cout << "Der Magier nimmt das Angebot an\n";
  else cout << "Der Magier lehnt ab\n";


  return 0;
}
