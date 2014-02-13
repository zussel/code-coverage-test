#include "calculator.hpp"

#include <iostream>
#include <stdexcept>

int main (int, char *[])
{

  calculator calc;

  int res = calc.add(1, 5);
  
  res = calc.minus(7, res);
  
  res = calc.divide(20, res);
  
  try {
    res = calc.divide(20, 0);
  } catch(std::logic_error &) {
    // correct exception was caught
  } catch(std::exception) {
    // unexpected exception was caught
    return 1;
  }
  
  res = calc.multiply(5, res);

  calc.store(res);
  
  res = calc.restore();

  std::cout << "result: " << res << "\n";

  return 0;
}
