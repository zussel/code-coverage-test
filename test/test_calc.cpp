#include "calculator.hpp"

#include <iostream>
#include <stdexcept>

using namespace std;

int main (int, char *[])
{

  calculator calc;

  int res = calc.add(1, 5);
  
//  res = calc.minus(7, res);
  
  res = calc.divide(20, res);
  
  try {
    res = calc.divide(20, 0);
  } catch(logic_error &) {
    // correct exception was caught
  } catch(exception &) {
    // unexpected exception was caught
    return 1;
  }
  
  res = calc.multiply(5, res);

  calc.store(res);
  
  res = calc.restore();

  std::cout << "result: " << res << "\n";

  return 0;
}
