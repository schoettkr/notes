#include <iostream>
#include <stdio.h>

using namespace std;

/*            Complexity               */
/*
trp = O(n^2)
add = O(n^2)
mul = O(n^3)
sym = O(n^2)
 */

class Matrix {
public:
  int ** data;
  int rows;
  int columns;

  Matrix(int rows, int columns) {
    this->rows = rows;
    this->columns = columns;
    this->data = new int * [rows];
  }

  void set(int * a) {
    for (int i = 0; i < rows; i++) {
      data[i] = new int[columns];
      for (int j = 0; j < columns; j++) {
        data[i][j] = a[(i * columns) + j];
      }
    }
  }

  void out() {
    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        cout.width(5);
        cout << right << data[i][j];
      }
      cout << endl;
    }
    cout << endl;
  }

  void trp() {
    int newcols = rows;
    int newrows = columns;
    int ** transposed = new int * [newrows];

    for (int i = 0; i < newrows; i++) {
      transposed[i] = new int[newcols];
      for (int j = 0; j < newcols; j++) {
        transposed[i][j] = data[j][i];
      }
    }
    freeData();
    this->data = transposed;
    this->rows = newrows;
    this->columns = newcols;
  }

  void add(Matrix & m) {
    if (m.rows != this->rows || m.columns != this->columns) {
      cout << "Matrices are not compatible for addition in regards to their dimensions!" << endl;
      return;
    }

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        data[i][j] += m.data[i][j];
      }
    }
  }

  void mul(Matrix & m) {
    if (m.columns != this->rows || m.rows != this->columns) {
      cout << "Matrices are not compatible for multiplication in regards to their dimensions!" << endl;
      return;
    }

    for (int t = 0; t < rows; t++) {
      int result = 0;
      for (int i = 0; i < m.columns; i++) {
        for (int j = 0; j < m.rows; j++) {
          result += data[t][j] * m.data[j][i];
        }
        cout.width(5);
        cout << right << result;
        result = 0;
      }
      cout << endl;
    }
    cout << endl;
  }

  bool sym() {
    if (rows != columns) return false;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < columns; j++) {
        if (data[i][j] != data[j][i]) return false;
      }
    }
    return true;
  }

  void freeData() {
    for (int i = 0; i < rows; i++) {
      delete [] data[i];
    }
    delete [] data;
  }


  ~Matrix() {
    freeData();
  }
};

struct dimension {
  int rows;
  int cols;
  int total;
};

dimension getDimensions(FILE * file) {
  dimension d;
  fscanf(file, "%d", &d.rows);
  fscanf(file, "%d", &d.cols);
  d.total = d.rows * d.cols;
  return d;
}

void readIntoArray(FILE * file, int count, int * array) {
  for (int i = 0; i < count; i++) {
    fscanf(file, "%d", &(array[i]));
  }
}

int main(int argc, char ** argv) {

  if (argc < 3) {
    cout << "Too few arguments - please pass 2 filenames" << endl;
    return 0;
  }

  FILE * m1 = fopen(argv[1], "r");
  FILE * m2 = fopen(argv[2], "r");
  if (!(m1 && m2)) {
    cout << "Couldn't open those files." << endl;
    return 0;
  }

  dimension dm1 = getDimensions(m1);
  dimension dm2 = getDimensions(m2);

  Matrix * matrix1 = new Matrix(dm1.rows, dm1.cols);
  Matrix * matrix2 = new Matrix(dm2.rows, dm2.cols);

  int m1Values[dm1.total];
  int m2Values[dm2.total];

  readIntoArray(m1, dm1.total, m1Values);
  readIntoArray(m2, dm2.total, m2Values);

  fclose(m1);
  fclose(m2);

  matrix1->set(m1Values);
  matrix2->set(m2Values);

  matrix1->out();
  matrix2->out();
  matrix1->add(*matrix2);
  matrix1->out();
  matrix2->mul(*matrix1);
  matrix1->trp();
  matrix1->out();

  if (matrix2->sym()) {
    cout << "Matrix 2 is symmetric";
  } else {
    cout << "Matrix 2 is asymmetric";
  }
  cout << endl;

  delete matrix1;
  delete matrix2;
  return 0;
}
