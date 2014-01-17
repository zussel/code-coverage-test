cmake_minimum_required(VERSION 2.6)

project(code-coverage-test)

# add module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

include(CodeCoverage)

set(CMAKE_CXX_FLAGS "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
 
set(CMAKE_C_FLAGS "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
 
#SET(CMAKE_SHARED_LINKER_FLAGS="-fprofile-arcs -ftest-coverage")
set(CMAKE_EXE_LINKER_FLAGS "-fprofile-arcs -ftest-coverage")

include_directories(${PROJECT_SOURCE_DIR}/include)

add_subdirectory(src)

add_executable(test_calc test_calc.cpp)

target_link_libraries(test_calc calc)

setup_target_for_coverage(coverage test_calc coverage)
