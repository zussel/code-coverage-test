#include "calculator.hpp"

calculator::calculator()
  : store_(0)
{}

calculator::~calculator() {}

int calculator::add(int a, int b)
{
  return a + b;
}

int calculator::minus(int a, int b)
{
  return a - b;
}

int calculator::divide(int a, int divisor)
{
  return a / divisor;
}

int calculator::multiply(int a, int b)
{
  return a * b;
}

void calculator::store(int value)
{
  store_ = value;
}
  
int calculator::restore()
{
  return store_;
}
