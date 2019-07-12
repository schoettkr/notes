#include <iostream>
using namespace std;

class Rational {
private:
  int n;
  int d;
  int ggT(int, int);
public:
  Rational();
  Rational(int, int);
  ~Rational();
  int getN();
  int getD();
  void setN(int);
  void setD(int);
  // .. to be continued
  void add(Rational);
  void sub(Rational);
  void mul(Rational);
  void div(Rational);
};

Rational::Rational() {
  n = 0;
  d = 1;
}

void Rational::add(Rational r) {
  n = n * r.d + r.n * d;
  d = d * r.d;
}

void Rational::sub(Rational r) {
  n = n * r.d - r.n * d;
  d = d * r.d;
}

void Rational::mul(Rational r) {
  n = n * r.n;
  d = d * r.d;
}
void Rational::div(Rational r) {
  n = n * r.d;
  d = d * r.n;
}

int main () {
  return 0;
}
