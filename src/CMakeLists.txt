set(DIR_USAGEF ${DIR_SRC}/usagef)

set(USAGEF_SOURCE_FILES ${DIR_USAGEF}/argv/is_valid_argv.c ${DIR_USAGEF}/run.c
                        ${DIR_USAGEF}/const.c)

add_executable(${PROJECT_NAME} ${DIR_SRC}/usagef.c ${DIR_SRC}/usagef_config.c
                               ${USAGEF_SOURCE_FILES})

set_target_properties(${PROJECT_NAME}
                      PROPERTIES COMPILE_FLAGS "-pedantic -Wall -Werror -std=c89")

target_include_directories(${PROJECT_NAME} PUBLIC ${DIR_BUILD})
