int power(int x, unsigned int n) {
  if (n == 0) return 1;
  int y = x;
  for (int i = 1; i < n; i++) {
    x *= y;
  }
  return x;
}

int poly1(int x, unsigned int n) {
  int poly = 0;
  int j = 0;

  while (j <= n) {
    poly += power(x, j++);
  }

  return poly;
}

int polyAlter(int x, unsigned int n) {
  int poly = 0;
  for (int i = 0; i <= n; i++) {
    poly = poly + (power(-1, i) * power(x, i));
  }
  return poly;
}
