add_library(calc SHARED calculator.cpp)

set_target_properties(calc
                      PROPERTIES
                      VERSION 0.1.0
                      SOVERSION 1)
