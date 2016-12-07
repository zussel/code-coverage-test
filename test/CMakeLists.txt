add_executable(test_calc test_calc.cpp)

target_link_libraries(test_calc calc)

add_test(all_test test_calc)
