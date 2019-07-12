#include <iostream>
using namespace std;

struct Person {
  string name;
  string wohnort;
  string telefon;
};

void printPerson(Person* p); 

int main() {
  char telefonbuchSize;
  cout << "Wieviele Personen soll das Telefonbuch erfassen koennen?\n";
  cin >> telefonbuchSize;
  Person telefonbuch[int(telefonbuchSize)];
  int eintraege = 0;

  char eingabe = '0';
  char suche = '0';

  do {
    cout << "Geben Sie '1' ein um Personen ins Telefonbuch einzutragen.\n";
    cout << "Geben Sie '2' ein um nach Personen im Telefonbuch zu suchen.\n";
    cout << "Geben Sie 'x' ein um das Programm zu beenden.\n";

    cin >> eingabe;

    switch (eingabe) {
      case '1': {
        Person eintrag;
        cout << "Name der Person: ";
        cin >> eintrag.name;
        cout << "Wohnort der Person: ";
        cin >> eintrag.wohnort;
        cout << "Telefonnummer der Person: ";
        cin >> eintrag.telefon;
        telefonbuch[eintraege++] = eintrag;
        break;
      }
      case '2': {
        cout << "\nMittels welchem Kriterium soll gesucht werden?\n";
        cout << "1: Name\n2: Wohnort\n3: Telefonnummer\n";
        cin >> suche;
        string suchbegriff;
        switch (suche) {
          case '1': {
            cout << "Nach welchem Namen soll gesucht werden?\n";
            cin >> suchbegriff;
            break;
          }
          case '2': {
            cout << "Nach welchem Wohnort soll gesucht werden?\n";
            cin >> suchbegriff;
            break;
          }
          case '3': {
            cout << "Nach welcher Telefonnummer soll gesucht werden?\n";
            cin >> suchbegriff;
            break;
          }
          default : {
            cout << "Ungueltiges Suchkriterium\n";
          }
        }
        for (int i = 0; i < eintraege; i++) {
          Person p = telefonbuch[i];
          if (suche == '1') {
            if (suchbegriff.compare(p.name) == 0) {
              printPerson(&p);
            }
          } else if (suche == '2') {
            if (suchbegriff.compare(p.wohnort) == 0) {
              printPerson(&p);
            }
          } else if (suche == '3') {
            if (suchbegriff.compare(p.telefon) == 0) {
              printPerson(&p);
            }
          }
        }
        break;
      }
      case 'x': {
        cout << "Auf Wiedersehen!" << endl;
        break;
      }
      default: {
        cout << "Ungueltige Eingabe";
      }
    }
  } while (eingabe != 'x' && eintraege < telefonbuchSize);
}

void printPerson(Person* p) {
  cout << "Person gefunden! Hier die Daten:\n";
  cout << "\tName: " << (*p).name << endl;
  cout << "\tWohnort: " << p->wohnort << endl;
  cout << "\tTelefonummer: " << p->telefon << endl;
}
