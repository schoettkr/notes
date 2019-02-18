### 1. Generic
#### Convert to binary
```c++
int main() {
   // Find highest power
   int temp = decimal;
   while (temp != 0) {
      potenz++;
      temp = temp >> 1;
   }

   cout << "Binary: ";
   while (potenz != 0) {
      // Shift MSB to LSB position, &compare against 1
      cout << ((decimal >> (potenz - 1)) & 1);
      potenz--; 
   }
   cout << endl;
}
```
#### Digit sum (Quersumme)
```c++
// Iterative
while (x != 0) {
    sum += x % 10;
    x/= 10;
}

// Recursive
int qs (int n) {
   if (n==0) return 0;
   return (n % 10) + qs (n / 10);
}
```
#### Greatest common divisor (ggt)
```c++
// Iterative
while (a!=b) {
    if (a>b) a-=b;
    else b-=a;
}
cout << a;

// Recursive
int euclid(int x, int y) {
   if (x==y) return x;
   else if (x>y) 
      return euclid(x-y,y); 
    else 
      return euclid(y-x,x);
}
```
#### Horner method
```c++
// Iterative calculation
int horner_iterativ(unsigned int n, int x) {
   int output = 0;
   int n_max = n;
   for (int i = n_max; i >= 0; --i) {
      printf("a(%d) = ", i);
      output += zahl() * power(x, n);
      n = n - 1;
   }
   return output;
}

// Recursive calc. w/ descending a's 
int horner_recursive(unsigned int n, int x, int a){
   int a_tmp;
   if (n == 0)
      return a;
   else {
      printf("a(%d) = ", n - 1);
      a_tmp = zahl();
      return a * power(x, n) + horner_recursive(n - 1, x, a_tmp);
   }
}
```
#### Check if prime
```c++
int primTest(int n) {
    for (int i = 2; i <= (int)sqrt(n); i++) {
        if (n % i == 0) {
            return 0;
        }
    }
    return 1;
}
```
#### Prime factorization
```c++
int i, zahl, check = 1;
while (check != zahl) {
    for (i = 2; i < zahl; i++) {
        if ((zahl % i == 0) && (primTest(i) == 1)) {
            cout << "Primfaktor: " << i << endl;
            check *= i;
        }
    }
}
```
#### Check if string is palindrom
```c++
bool palin(string name) {
    int len = name.length();
    int check = 0;

    for (int i = 0; i < len/2 + 1; i++) {
        if (name[i] == name[(len - 1) - i])
            check += 0;
        else
            check += 1;
    }
    return check == 0 ? true : false;
}
```
#### Find substring (needle in haystack)
```c++
bool contains(string haystack, string needle){
    if (haystack.size() < needle.size())
        return false;
    int needleSize = needle.size();
    for (int i = 0; i < haystack.size(); i++){
        if (haystack.substr(i, needleSize) == needle)
                return true;
    }
    return false;
}
```

### 2. Arrays
#### Dynamically allocate
```c++
int* array = new int[sizeof(int)];
```
#### Find smallest value
```c++
int findSmallest(int* array, int low, int high) {
    int min = array[low];
    int pos = low;
    
    for (int i = low; i <= high; i++) {
        if (array[i] < min) {
            min = array[i];
            pos = i;
        }
    }  
    return pos;
}
```
#### Shuffle array
```c++
void shuffleArray(int* array, int size) {
   int temp = 0;
   int j = 0;
   
   for (int i = size - 1; i >= 0; i--) {
      j = rand() % (i + 1);
      temp = array[j];
      array[j] = array[i];
      array[i] = temp;
   }
}
```

### 3. Matrices
#### Dynamically allocate
```c++
int** array = new int*[SIZE];
for (int i = 0; i < SIZE; i++) {
  array[i] = new int[SIZE];
}
```
#### Arithmetics
```c
// mat3 = mat1 + mat2
void add_mat(int **mat1, int **mat2, int **mat3, int n, int m) {
   for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
         mat3[i][j] = mat1[i][j] + mat2[i][j];
      }
   }
}

// mat3 = mat1 - mat2
void sub_mat(int **mat1, int **mat2, int **mat3, int n, int m) {
   for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
         mat3[i][j] = mat1[i][j] - mat2[i][j];
      }
   }
} 
``` 
#### Transpose
```c++
// Transpose mat into mat_t
void trans_mat(int **mat, int **mat_t, int n, int m) {
   for (int i = 0; i < n; i++) {
      for (int j = 0; j < m; j++) {
         mat_t[i][j] = mat[j][i];
      }
   }
}
```
#### Determinant
```c
// Get cofactor at position matrix[0][cur_row]
void cofactor(int **temp, int **matrix, int n, int cur_row) {
   for (int i = 0; i < n; i++) {
      for (int j = 0; j < n; j++) {
         if (j == cur_row) {
            temp[i][j] = matrix[i + 1][j + 1];
         }
         else {
            if (cur_row == 0) {
               temp[i][j] = matrix[i + 1][j + 1];
            } 
            else {
               temp[i][j] = matrix[i + 1][j];
            }
         }
      }
   }
}

int determinant(int **matrix, int n) {
   int **temp, prod, sign;

   if (n == 1) {
      return matrix[0][0];
   }

   else {
      // Cofactor matrix
      temp = create_custom_2D_matrix(n - 1, n - 1);
      prod = 0;
      sign = 1;

      for (int i = 0; i < n; i++) {
         cofactor(temp, matrix, n - 1, i);
         prod += sign * matrix[0][i] * determinant(temp, n - 1);
         sign = -sign;
      }
      
      free(temp);
      return prod;
   }
}
```
#### N/E/S/W Sums
```c++
int nord(int matrix[N][N]) {
   int sum = 0;
   for (int i = 0; i < N/2; i++) {
      for (int j = i + 1; j < N - 1 - i; j++) {
         sum += matrix[i][j];
      }
   }
   return sum;
}

int west(int matrix[N][N]) {
   int sum = 0;
   for (int j = 0; j < N / 2; j++) {
      for (int i = 1 + j; i < N - 1 - j; i++) {
         sum += matrix[i][j];
      }
   }
   return sum;
}

int sud(int matrix[N][N]) {
   int sum = 0;
   for (int i = N - 1; i > N / 2; i--) {
      for (int j = N - i; j < i; j++) {
         sum += matrix[i][j];
      }
   }
   return sum;
}

int ost(int matrix[N][N]) {
   int sum = 0;
   for (int j = N - 1; j >  N / 2; j--) {
      for (int i = N - j; i <= j - 1; i++) {
         sum += matrix[i][j];
      }
   }
   return sum;
}
```

### 4. Sorting
#### Bubble sort
```c++
void bubble_sort(int *arr, int size) {
   int swap = 1, min;
   while (swap) {
      swap = 0;
      for (int i = 0; i <= size - 2; i++) {
         min = arr[i];
         if (arr[i + 1] < min) {
            min = arr[i + 1];
            arr[i + 1] = arr[i];
            arr[i] = min;
            swap = 1;
         }
      }
   }
}
```

#### Selection sort
```c
int* sortArray(int* array, int size) {
   int min, pos, temp;
   int swapping = 0;

   // We'll only be working in our subarray
   int* subarray = malloc(size * sizeof(int));
   subarray = array;

   // Iterating over whole array
   for (int i = 0; i < size; i++) {
      min = subarray[i];

      // Do we have a value higher than the first in our array?
      for (int j = i + 1; j < size; j++) {
         if (subarray[j] < min) {
            min = subarray[j]; 
            pos = j;
            swapping = 1;
         }
      }

      // Swap positions with current comparing element and smallest element
      if (swapping) {
         temp = subarray[pos];
         subarray[pos] = subarray[i];
         subarray[i] = temp;
      }
   }
   return subarray;
}
```

### 5. Recursion
#### Faculty
```c++
int fak(int x) {
   if (x <= 1) return 1;
   return x * fak(x - 1);
}
```
#### Fibonacci
```c++
int fibo(int n) {
   if (n <= 0) 
      return 0;
   else if (n == 1)
      return 1;
   else 
      return fibo(n - 1) + fibo(n - 2);
}
```
#### Multiply
```c++
int mult(int a, int b) {
   if (a == 1)
      return b;
   else if (b == 1) {
      return a;
   }
   else
      return mult(a, 1) * mult(1, b);
}
```
#### Power
```c++
int expo(int a, unsigned int b) {
   if (b == 0)
      return 1;
   else
      return a * expo(a, b - 1);
}
```
#### Binominal
```c++
unsigned int binom(unsigned int n,unsigned int k) {
   if ((n == k) || (k == 0)) return 1;
   else if ((0 < k) && (k < n))
      return binom(n - 1, k - 1) + binom(n -1, k);
   else
      return 0;
}
```

### 6. Numbers
#### Bitwise Operations
```c++
cout << "\na AND b = " << (a & b) << endl;
cout << "a OR b = " << (a | b) << endl;
cout << "a XOR b = " << (a ^ b) << endl;
```
#### Bitwise Multiply
```c++
for (int i = 0; i < sizeof(int) * 8; i++) {
   if ((1 << i) & b) {
      prod += a << i;
   }
}
```
#### Rounding
```c++
float div = a / b;

// floor up to x.49999, ceil from x.5
cout << a << "/" << b << div << " (vor dem Ruden)\n";
cout << a << "/" << b <<  (int)(div + 0.5) << " (nach dem Runden)\n";
```
#### Reverse
```c++
// Iterative
long zahl_spiegeln (long n) {
   long reverse_number = 0;
   int rest;

   while (n != 0) {
      rest = n%10;
      reverse_number = reverse_number*10 + rest;
      n /= 10;
   }
   return reverse_number;
}

// Recursive
int reverse2(int i, int j) {
    if(i == 0){
        return j; 
      }
    return reverse2(i / 10, j * 10 + i % 10);
}
```
#### Perfect number (Komplette Zahl)
```c++
int komplett(int zahl) {
   int temp = zahl, sum = 0;
   zahl--;

   while (zahl != 0) {
      if (temp % zahl == 0) {
         sum += zahl;
      }
      zahl--;
   }
   return sum == temp ? 1 : 0;
}
```

### 7. Strings
#### Initialisation
```
char test[6] = "Hallo";
```
```
char test[] = "Hallo";
```
#### Manipulation
Purpose | Code | Remarks
--- | --- | ---
Length | `int strlen(char *s)` | Returns length w/out `'\0'`
Compare | `int strcmp( char* s1, char *s2)` | Returns:  < 0 (s1 < s2), > 0 (s1 > s2), = 0 (s1 == s2)
Copy | `char *strcpy(char *dest, char *src)` | Copies `src` into `dest` including `'\0'`
Append | `char *strcat(char *dest, char *src)` | Appends `dest` to `src`, adds `'\0'`

### 8. I/O
#### 4.1. Overview
##### Create file and write to it
```c++
#include <iostream> 
#include <fstream> 
using namespace std; 

main() {
   // Open output file
   ofstream fout ("test");
   if(!fout) {
      cout << "Outputfile nicht zu oeffnen \n";
      return 1; 
    }
    // Write to file
   fout << "Hello\n";
    fout << 100 << ' ' << hex << 100 << endl;
    fout.close();
    
    // Open input file
    ifstream fin("test");
   if(!fin) {
      cout << "Inputfile nicht zu oeffnen\n"; return 1;
   }
   char str[80];
   int i,j;
    // Save previously created string/hex numbers in variables
   fin >> str >> i >> j;
   cout << str << ' ' << i << ' ' << j << endl; 
    fin.close();
   return 0;
}
```
##### Copy a file
```c++
#include <fstream> 
#include <libc.h>
using namespace std; 

// Function to write to error stream
void error(char *s) {
   cerr << s << endl; 
   exit(1);
} 

main() {
   // Anlegen eines Objektes der Klasse ifstream 
   ifstream von("files.c");
    if(!von)
      error("Fehler beim Oeffnen der Quelle");
    // Anlegen eines Objektes der Klasse ofstream 
    ofstream nach("ziel"); 
    if(!nach)
      error("Fehler beim Oeffnen des Ziels"); 
    char c;
    // solange ohne Fehler
    while(von.get(c))
      // zeichenweise kopieren if(!von.eof())
      nach.put(c); 
    error("Fehler beim Kopieren Quelle "); 
    von.close();
    nach.close();
    return(0);
}
```
# Todo
- file io
- klausur uebeungsaufgbaen stuff
- common gotchas 
- nuetzliche methoden
- aus klausuren most common tasks raussuchen
