#include <iostream>
#include <cstring>

using namespace std;

struct Mitarbeiter {
  char name[31];
  int alter;
  float gehalt;
};

int main () {
  int anzahl = 0;
  Mitarbeiter personal[30];

  char eingabe = '0';
  do {
    cout << endl;
    cout << "1: Mitarbeiter anzeigen " << endl;
    cout << "2: Altersdurchschnitt anzeigen " << endl;
    cout << "3: Mitarbeiter einstellen " << endl;
    cout << "4: Gehaltserhoehung" << endl;
    cout << "5: Topverdiener anzeigen " << endl;
    cout << "6: Mitarbeiter entlassen " << endl;
    cout << "x: Programm beenden " << endl;

    // Befehl von Nutzer einlesen
    cin >> eingabe;
    cout << endl;

    switch(eingabe)
      {
      case '1': { // MA anzeigen
        for (int i = 0; i < anzahl; i++) {
          cout << "Mitarbeiter " << anzahl+1 << ": "  << personal[i].name;
          cout << " ist " << personal[i].alter << " Jahre alt und hat ein Gehalt von ";
          cout << personal[i].gehalt << "$." << endl;
        }
        break;
      }
      case '2': { // Durchschnittsalter
        int sum = 0;
        for (int i = 0; i < anzahl ; i++) {
          sum += personal[i].alter;
        }
        float avg = sum / anzahl;
        cout << "Durchschnittsalter = " << avg << endl;
        break;
      }
      case '3': { // MA einstellen
        Mitarbeiter newEmployee;
        cout << "Name: ";
        cin >> newEmployee.name;
        cout << "Alter: ";
        cin >> newEmployee.alter;
        cout << "Gehalt: ";
        cin >> newEmployee.gehalt;
        personal[anzahl++] = newEmployee;
        break;
      }
      case '4': { // Gehaltserhoehung um 10%
        for (int i = 0; i < anzahl ; i++) {
          personal[i].gehalt = personal[i].gehalt*1.1;
        }
        break;
      }
      case '5': { // Topverdiener ueber 20% anzeigen
        int sum = 0;
        for (int i = 0; i < anzahl ; i++) {
          sum += personal[i].alter;
        }
        float avg = sum / anzahl;
        float top = avg * 1.2;

        cout << "Topverdiener:";

        for (int i = 0; i < anzahl ; i++) {
          if (personal[i].gehalt > top) {
            cout << personal[i].name << endl;
          }
        }
        break;
      }
      case '6': { // Mitarbeiter entlassen; alternativ letztes Element auf zu entlassenden Mitarbeiter kopieren und Anzahl dekrementieren
        char name[31];
        cout << "Bitte Namen von dem zu entlassenden Mitarbeiter eingeben: ";
        cin >> name;
        int idx;
        int found = 0;

        for (int i = 0; i < anzahl; i++) {
          if (strcmp(personal[i].name,name) == 0) {
            idx = i;
            found = 1;
            break;
          }
        }
        if (found) {
          Mitarbeiter tmp;
          strcpy(tmp.name, personal[anzahl].name);
          tmp.alter = personal[anzahl].alter;
          tmp.gehalt = personal[anzahl].gehalt;

          personal[anzahl] = personal[idx];
          personal[idx] = tmp;
          Mitarbeiter empty;
          personal[anzahl--] = empty;

        } else cout << "Mitarbeiter nicht gefunden!";
        
        break;
      }
      case 'x': {
        cout << "Goodbye!";
        break;
      }
      default: {
        cout << "Invalid action";
      }
      }
  } while (eingabe != 'x');

}
