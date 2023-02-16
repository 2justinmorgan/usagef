set(DIR_TESTS_UNIT ${DIR_TESTS}/unit)

# adds an executable to test the source path (a .c file in the src/usagef dir)
# note: each .c file in src/usagef contains one function definition (one unit)
function(add_test_unit source_path)
  get_filename_component(source_file_name "${source_path}" NAME)
  string(REGEX REPLACE "${source_file_name}$" "test_${source_file_name}"
                       test_source_path ${source_path})
  string(REPLACE "/" "__" source_path_snaked ${source_path})
  string(REPLACE ".c" "" source_path_snaked_no_c ${source_path_snaked})
  string(CONCAT test_name "${PROJECT_NAME}_test_unit__"
                ${source_path_snaked_no_c})

  add_executable(${test_name} ${DIR_TESTS_UNIT}/common.c
                              ${DIR_TESTS_UNIT}/${test_source_path})

  set_target_properties(
    ${test_name} PROPERTIES COMPILE_FLAGS "${COMPILE_FLAGS_BASE} -std=c99")

  target_include_directories(${test_name} PUBLIC ${DIR_SRC})
  target_link_directories(${test_name} PUBLIC ${DIR_SRC})
  target_link_libraries(${test_name} ${LIB_SRC})
endfunction()

add_test_unit(run.c)
add_test_unit(const.c)
add_test_unit(argv/is_valid_argv.c)
