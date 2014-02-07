cmake_minimum_required(VERSION 2.6)

project(code-coverage-test)

# add module path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")

# contains the full path to the top level directory of your build tree 
MESSAGE( STATUS "PROJECT_BINARY_DIR: " ${PROJECT_BINARY_DIR} )

# contains the full path to the root of your project source directory,
# i.e. to the nearest directory where CMakeLists.txt contains the PROJECT() command 
MESSAGE( STATUS "PROJECT_SOURCE_DIR: " ${PROJECT_SOURCE_DIR} )

MESSAGE( STATUS "CMAKE_BINARY_DIR: " ${CMAKE_BINARY_DIR} )

#include(CodeCoverage)

option(COVERALLS "Enable generation sending of coveralls data" true)

if (COVERALLS AND CMAKE_BUILD_TYPE STREQUAL "Debug")
  message(STATUS "will generate coveralls data")
  set(CMAKE_CXX_FLAGS "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
  set(CMAKE_C_FLAGS "-g -O0 -Wall -W -fprofile-arcs -ftest-coverage")
  #SET(CMAKE_SHARED_LINKER_FLAGS="-fprofile-arcs -ftest-coverage")
  set(CMAKE_EXE_LINKER_FLAGS "-fprofile-arcs -ftest-coverage")
  
  include(Coveralls)
  
  setup_target_for_coveralls(coveralls test coveralls)

endif()

ADD_CUSTOM_TARGET(debug
  COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Debug ${CMAKE_SOURCE_DIR} WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build
  COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build
  COMMENT "Switch CMAKE_BUILD_TYPE to Debug"
)

ADD_CUSTOM_TARGET(release
  COMMAND ${CMAKE_COMMAND} -DCMAKE_BUILD_TYPE=Release ${CMAKE_SOURCE_DIR}/build WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build
  COMMAND ${CMAKE_COMMAND} --build ${CMAKE_BINARY_DIR} --target all WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/build
  COMMENT "Switch CMAKE_BUILD_TYPE to Release"
)

include_directories(${PROJECT_SOURCE_DIR}/include)

add_subdirectory(src)

add_executable(test_calc test_calc.cpp)

target_link_libraries(test_calc calc)

#setup_target_for_coverage(coverage test_calc coverage)
