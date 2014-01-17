#include "calculator.hpp"

#include <iostream>

int main (int, char *[])
{

  calculator calc;

  int res = calc.add(1, 5);
  
  res = calc.minus(7, res);
  
  res = calc.divide(20, res);
  
  res = calc.multiply(5, res);

  calc.store(res);
  
  res = calc.restore();

  std::cout << "result: " << res << "\n";

  return 0;
}
