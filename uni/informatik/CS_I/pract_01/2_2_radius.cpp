#include <iostream>
#include <cmath>

using namespace std;

int main()
{
  float radius, pi, area, perimeter;
  // pi = 3.14 or M_PI; if cmath library is allowed
  cout << "Please enter a radius\n";
  cin >> radius;
  
  float radiusTimesPi = M_PI * radius;
  area = radius * radiusTimesPi;
  perimeter = radiusTimesPi * 2;

  cout << "The area of the circle is " << area << "\n";
  cout << "The perimeter of the circle is " << perimeter << "\n";
  return 0;
}
