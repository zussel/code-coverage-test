#ifndef CALCULATOR_HPP
#define CALCULATOR_HPP

class calculator
{
public:
  calculator();
  ~calculator();
  
  int add(int a, int b);
  int minus(int a, int b);
  
  int divide(int a, int divisor);
  int multiply(int a, int b);
  
  void store(int value);
  int restore();

private:
  int store_;
};

#endif /* CALCULATOR_HPP */
