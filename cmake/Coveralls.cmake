# Check prereqs
FIND_PROGRAM( GCOV_PATH gcov )

IF(NOT GCOV_PATH)
	MESSAGE(FATAL_ERROR "gcov not found! Aborting...")
ELSE()
  MESSAGE(STATUS "Found Gcov")
ENDIF() # NOT GCOV_PATH

find_package(Git)

if(NOT GIT_FOUND)
     message(FATAL_ERROR "git not found")
endif()

IF(NOT CMAKE_COMPILER_IS_GNUCXX)
	# Clang version 3.0.0 and greater now supports gcov as well.
	MESSAGE(WARNING "Compiler is not GNU gcc! Clang Version 3.0.0 and greater supports gcov as well, but older versions don't.")
	
	IF(NOT "${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
		MESSAGE(FATAL_ERROR "Compiler is not GNU gcc! Aborting...")
	ENDIF()
ENDIF() # NOT CMAKE_COMPILER_IS_GNUCXX

IF ( NOT CMAKE_BUILD_TYPE STREQUAL "Debug")
  MESSAGE( WARNING "Code coverage results with an optimized (non-Debug) build may be misleading" )
ENDIF() # NOT CMAKE_BUILD_TYPE STREQUAL "Debug"

FUNCTION(SETUP_TARGET_FOR_COVERALLS target testapp output)

  message(STATUS "setting up coveralls target")

  file(MAKE_DIRECTORY ${output})

  set (GIT_ARG "--version")
  set (GIT_COMMON_HEAD_ARGS "--no-pager" "log" "-1")

  set (committer_email "--pretty=format:%ce")
  set (author_email "--pretty=format:%aN")
  set (author_name "--pretty=format:%ae")
  set (message "--pretty=format:%s")
  set (committer_name "--pretty=format:%cN")
  set (id "--pretty=format:%H")
  
  set (GIT_HEAD_ARGS committer_email author_email author_name message committer_name id)

  foreach(CMD ${GIT_HEAD_ARGS})
#    message(STATUS "cmd: ${CMD} ${${CMD}}")
    execute_process(COMMAND ${GIT_EXECUTABLE} ${GIT_COMMON_HEAD_ARGS} ${${CMD}}
      WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
      OUTPUT_VARIABLE GIT_INFO)

      message(STATUS "'${CMD}': u'${GIT_INFO}'")
  endforeach(CMD)

  set(SOURCE_DIR "src")

  # add target for coverage by gcov
  ADD_CUSTOM_TARGET(${target})

  file(GLOB_RECURSE SOURCES RELATIVE ${PROJECT_SOURCE_DIR} "${PROJECT_SOURCE_DIR}/${SOURCE_DIR}/*.*pp")
  foreach(SOURCE ${SOURCES})
    ADD_CUSTOM_COMMAND(TARGET ${target} POST_BUILD
      COMMAND echo ARGS "hallo"
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

ENDFUNCTION()
