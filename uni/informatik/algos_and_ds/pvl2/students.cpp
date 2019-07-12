#include <iostream>
#include <stdio.h>
using namespace std;

const int MAXSTUDENTS = 1000;
void readString(char *&);

class Student {
private:
  char * name;
  char ** lehrveranstaltungen;
public:
  unsigned int matrikelnummer;
  Student(char * name, unsigned int matrikelnummer, char ** lehrveranstaltungen) : lehrveranstaltungen (0) {
    this->name = name;
    this->matrikelnummer = matrikelnummer;
    this->lehrveranstaltungen = lehrveranstaltungen;
  }
  ~Student() {
    delete [] name;
    for (int i = 0; i < 30; i++) {
      if (lehrveranstaltungen[i]) {
        delete [] lehrveranstaltungen[i];
      }
    }
    delete [] lehrveranstaltungen;
  }
  void summary();
};

void Student::summary() {
  cout << "Name: " << name << endl;
  cout << "Matrnr: " << matrikelnummer << endl;
  cout << "Lehrveranstaltungen:" << endl;
  for (int i = 0; i < 30; i++) {
    if (lehrveranstaltungen[i]) {
      for (int k = 0; lehrveranstaltungen[i][k] != '\0'; k++) {
        cout << lehrveranstaltungen[i][k];
      }
      cout << endl;
    }
  }
}

int isStudentPresent(Student ** students, int searchMatrNr, int lowB, int highB) {
  while (highB >= lowB) {
    int middle = (highB + lowB) / 2;
    if (students[middle]->matrikelnummer == searchMatrNr) {
      return middle;
    } else if (students[middle]->matrikelnummer > searchMatrNr) {
      highB = middle-1;
    } else {
      lowB = middle+1;
    }
  }
  return -1;
}

Student * createStudent() {
  cout << "Namen eingeben: ";
  char * nameInput = new char[0];
  readString(nameInput);
  cout << endl;

  cout << "Matrikelnummer eingeben: ";
  char * matrNrInput = new char[0];
  readString(matrNrInput);
  cout << endl;

  unsigned int matrNr;
  sscanf(matrNrInput, "%u", &matrNr);
  delete [] matrNrInput;

  int lvCount = 0;
  char ** lvs = new char * [30]{0};
  while (lvCount < 30) {
  cout << "Titel fuer belegte Lehrveranstaltung eingeben (Beenden via '0'): ";
  char * lvInput = new char[0];
  readString(lvInput);
  if (*lvInput == '0') {
    delete [] lvInput;
    break;
  }
  cout << endl;
  lvs[lvCount++] = lvInput;
  }

  Student * s = new Student(nameInput, matrNr, lvs);
  return s;
}

void readString(char * &str) {
  int pos = 0;
  char * tempStr = NULL;
  while (1) {
    tempStr = str;
    str = new char[pos+1];

    for (int i = 0; i < pos; i++) str[i] = tempStr[i];
    delete [] tempStr;

    char c = getchar();
    if (c == '\n') break;
    str[pos++] = c;
  }
  str[pos] = '\0';
}

Student * insertStudent(Student ** students, Student * newStudent, int * currentSize) {
  if (isStudentPresent(students, newStudent->matrikelnummer, 0, (*currentSize)-1) != -1) {
    return NULL;
  }
  if (*currentSize == 0) {
    students[*currentSize] = newStudent;
  } else {
    int index = *currentSize - 1;
    while ((index >= 0) &&
           students[index]->matrikelnummer > newStudent->matrikelnummer) {
      students[index+1] = students[index];
      index -= 1;
    }
    index += 1;
    students[index] = newStudent;
  }
  (*currentSize)++;
  return newStudent;
}

int deleteStudent(Student ** students, int deleteMatrNr, int * currentSize) {
  int isDeletionPossible = isStudentPresent(students, deleteMatrNr, 0, *(currentSize)-1);
  if (isDeletionPossible != -1) {
    int i = isDeletionPossible;
    delete students[i];
    while (i <= *currentSize) {
      if (i < MAXSTUDENTS-1) {
        students[i] = students[i+1];
      } else {
        students[i] = NULL;
      }
      i++;
    }
    (*currentSize) -= 1;
    return 1;
  }

  return -1;
}

int main() {
  int currentSize = 0;
  Student * students[MAXSTUDENTS] = {0};

  bool running = true;
  while (running) {
    cout << "Studentenverwaltung" << endl << "===================" << endl;
    cout << "Auswahlmenü: " << endl;
    cout << "A - Anlegen eines neuen Studenten und der bisher belegten Lehrveranstaltungen" << endl;
    cout << "S - Suchen eines Studenten" << endl;
    cout << "L - Löschen eines Studenten" << endl;
    cout << "E - Programmende\n" << endl;
    char action = getchar(); getchar();

    switch (action) {
    case 'A': {
      if (currentSize < MAXSTUDENTS) {
        Student * newStudent = createStudent();
        Student * res = insertStudent(students, newStudent, &currentSize);
        if (!res) {
          cout << "Es existiert bereits ein Student mit dieser Matrikelnr" << endl;
        }
                    
      } else {
        cout << "Die maximale Kapazitaet an Studenten ist bereits ausgeschoepft." << endl;
        cout << "Bitte loeschen Sie zunaechst einen Studenten (L)." << endl;
      }
      break;
    }
    case 'S': {
      cout << "Geben Sie die zu suchende Matrikelnummer ein: ";
      char * searchMatrNrInput = {};
      readString(searchMatrNrInput);
      unsigned int searchmatrNr;
      sscanf(searchMatrNrInput, "%u", &searchmatrNr);
      int isPresent = isStudentPresent(students, searchmatrNr, 0, currentSize-1);
      if (isPresent != -1) {
        cout << "Der Student mit der Matrikelnr " << searchMatrNrInput << " befindet sich im Datensatz:" << endl;
        cout << "Dies sind die verknuepften Daten:" << endl;
        students[isPresent]->summary();
      } else {
        cout << "Der Student mit der Matrikelnr " << searchMatrNrInput << " befindet sich nicht im Datensatz" << endl;
      }
      delete [] searchMatrNrInput ;
      break;
    }
    case 'L': {
      cout << "Geben Sie die Matrikelnr des zu loeschenden Students ein: ";
      char * deleteMatrNrInput = {};
      readString(deleteMatrNrInput);
      unsigned int deletematrNr;
      sscanf(deleteMatrNrInput, "%u", &deletematrNr);
      int result = deleteStudent(students, deletematrNr, &currentSize);
      if (result == -1) {
        cout << "Der Student konnte nicht gefunden und ergo nicht geloescht werden" << endl;
      } else {
        cout << "Der Student mit der Matrikelnr " << deleteMatrNrInput << " wurde erfolgreich geloescht" << endl;
      }
      delete [] deleteMatrNrInput ;
      break;
    }
    case 'E': {
      running = false;
      break; 
    }
    default: {
      cout << "Ungueltige Eingabe" << endl;
      break;
    }
    }
  }

  for (int i = 0; i < MAXSTUDENTS; i++) {
    if (students[i]) {
      delete students[i];
    }
  }

  return 0;
}
