set(DIR_USAGEF ${DIR_SRC}/usagef)

if(IS_STATIC_CHECKING EQUAL 1)
  set(CMAKE_C_CLANG_TIDY "clang-tidy")
endif()

set(USAGEF_SOURCE_FILES ${DIR_USAGEF}/argv/is_valid_argv.c ${DIR_USAGEF}/run.c
                        ${DIR_USAGEF}/const.c)

if(IS_DEV_SETUP EQUAL 1)
  add_library(${LIB_SRC} SHARED ${USAGEF_SOURCE_FILES})
endif()

add_executable(${PROJECT_NAME} ${DIR_SRC}/usagef.c ${DIR_SRC}/usagef_config.c
                               ${USAGEF_SOURCE_FILES})

set_target_properties(${PROJECT_NAME}
                      PROPERTIES COMPILE_FLAGS "${COMPILE_FLAGS_BASE} -std=c89")

target_include_directories(${PROJECT_NAME} PUBLIC ${DIR_BUILD})
