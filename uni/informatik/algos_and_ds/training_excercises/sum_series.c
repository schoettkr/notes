#include <stdio.h>

int main() {

  int sum = 0, num;

  while(scanf("%d", &num) == 1 && num != 0) {
    sum += num;
  }

  printf("%d\n", sum);

  return 0;
}
