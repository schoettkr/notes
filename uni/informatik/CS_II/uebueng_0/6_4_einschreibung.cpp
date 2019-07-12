#include <iostream>
using namespace std;

struct Student {
  string name;
  int age;
};

int main() {
  Student lehrveranstaltung[30];

  bool einlesen = true;
  int anzahl = 0;
  while (einlesen && anzahl < 30) {
    cout << "Geben Sie die Daten fuer einen Studenten gemaess Aufforderung ein\n";
    Student newStudent;
    cout << "Name des Studenten: ";
    cin >> newStudent.name;
    cout << "Alter des Studenten: ";
    cin >> newStudent.age;
    lehrveranstaltung[anzahl++] = newStudent;

    cout << endl;
    cout << "Moechten Sie weitere Studenten erfassen? (y/n) ";
    char answer;
    cin >> answer;
    if (answer == 'n')
      einlesen = false;
  }
  cout << "Einleseprozess beendet. Dies sind die Daten aller Studenten:\n";
  for (int i = 0; i < anzahl; i++) {
    cout << "Student " << (i+1) << ":\n";
    cout << "\t Name: " << lehrveranstaltung[i].name << endl;
    cout << "\t Alter: " << lehrveranstaltung[i].age << endl;
  }
}
