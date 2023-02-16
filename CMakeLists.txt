cmake_minimum_required(VERSION 3.18.4)

set(USAGEF_VERSION 0.1.0)

project(
  usagef
  LANGUAGES C
  VERSION ${USAGEF_VERSION})

set(DIR_HOME ${PROJECT_SOURCE_DIR})
set(DIR_BUILD ${DIR_HOME}/build)
set(DIR_SRC ${DIR_HOME}/src)
set(DIR_TESTS ${DIR_HOME}/tests)
set(LIB_SRC src)
set(COMPILE_FLAGS_BASE "-pedantic -Wall -Werror")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${DIR_BUILD})
set(EXECUTABLE_OUTPUT_PATH ${DIR_BUILD})

configure_file(${DIR_SRC}/${PROJECT_NAME}_config.h.in ${PROJECT_NAME}_config.h)

add_subdirectory(${DIR_SRC})

if(IS_DEV_SETUP EQUAL 1)
  add_subdirectory(${DIR_TESTS})
endif()
