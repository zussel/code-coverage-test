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

find_package(Git)

if(GIT_FOUND)
     message("git found: ${GIT_EXECUTABLE}")
else()
     message("git not found")
endif()

set (GIT_ARG "--version")
set (GIT_HEADER_ARGS "--no-pager" "log" "-1")
set (GIT_CMD_ARGS "--pretty=format:%H" "--pretty=format:%aN" "--pretty=format:%ae" "--pretty=format:%cN" "--pretty=format:%ce" "--pretty=format:%s")

message(STATUS "git cmd: ${GIT_EXECUTABLE}")
message(STATUS "git args: ${GIT_HEADER_ARGS}")

foreach(CMD ${GIT_CMD_ARGS})
  execute_process(COMMAND ${GIT_EXECUTABLE} ${GIT_HEADER_ARGS} ${CMD}
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    RESULT_VARIABLE GIT_RESULT
    OUTPUT_VARIABLE GIT_VER)

  message(STATUS "git ver[${GIT_RESULT}]: ${GIT_VER}")
endforeach(CMD)

set(SOURCE_DIR "src")

find_program( GCOV_PATH gcov )
# add target for coverage by gcov
ADD_CUSTOM_TARGET(gcov)

file(GLOB_RECURSE SOURCES RELATIVE ${PROJECT_SOURCE_DIR} "${PROJECT_SOURCE_DIR}/${SOURCE_DIR}/*.*pp")
foreach(SOURCE ${SOURCES})
  ADD_CUSTOM_COMMAND(TARGET gcov POST_BUILD
    COMMAND get_filename_component(FILENAME ${SOURCE} NAME)
		COMMAND ;
		COMMENT "call gcov for ${FILENAME} (${SOURCE})"
	)

#    message(STATUS "source file: ${SOURCE}")
#    get_filename_component(FILENAME ${SOURCE} NAME)
#    message(STATUS "source file: ${FILENAME}")
#    set(GCNO_FILE "${FILENAME}.gcno")
#    message(STATUS "searching for ${GCNO_FILE}")
  #  find_file(GCNO_FILEPATH ${GCNO_FILE} PATHS ${CMAKE_BINARY_DIR})
#    file(GLOB_RECURSE GCNO_FILES RELATIVE ${PROJECT_SOURCE_DIR} ${GCNO_FILE})
#    message(STATUS "source file: ${GCNO_FILES}")

#    message(STATUS "gcov: ${GCOV_PATH}")

#    execute_process(COMMAND ${GCOV_PATH} ${SOURCE} "-o" ${GCNO_FILES}
#      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
#      RESULT_VARIABLE GCOV_RESULT
#      OUTPUT_VARIABLE GCOV_VER
#    )
    
#    message(STATUS "git ver[${GCOV_RESULT}]: ${GCOV_VER}")
endforeach(SOURCE)
