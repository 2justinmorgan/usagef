#include "common.h"
#include "usagef/const.h"
#include "usagef/run.h"
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int is_valid_argv_num_calls;
int is_valid_argv_return_val;
int is_valid_argv_arg_1;
char **is_valid_argv_arg_2;

int printf_num_calls;
char *printf_arg_1;
char *printf_arg_2;

int is_valid_argv(int argc, char **argv) {
  is_valid_argv_num_calls++;
  is_valid_argv_arg_1 = argc;
  is_valid_argv_arg_2 = argv;
  return is_valid_argv_return_val;
}

int printf(const char *format_arr, ...) {
  printf_num_calls++;
  va_list args;
  va_start(args, format_arr);
  printf_arg_1 = (char *)format_arr;
  printf_arg_2 = va_arg(args, char *);
  va_end(args);
  return -1;
}

void printf_reset() {
  printf_num_calls = 0;
  printf_arg_1 = NULL;
  printf_arg_2 = NULL;
}

void is_valid_argv_reset(int return_val) {
  is_valid_argv_num_calls = 0;
  is_valid_argv_return_val = return_val;
  is_valid_argv_arg_1 = -1;
  is_valid_argv_arg_2 = NULL;
}

char **create_argv() {
  char **argv = (char **)malloc(sizeof(char *));
  argv[0] = (char *)malloc(sizeof(char));
  return argv;
}

void free_argv(char **argv) {
  free(argv[0]);
  free(argv);
}

void test_run_success() {
  is_valid_argv_reset(1);
  printf_reset();
  const int argc = 101;
  char **argv = create_argv();

  int actual_return = run(argc, argv);

  assert(actual_return == 0);
  assert(is_valid_argv_num_calls == 1);
  assert(is_valid_argv_arg_1 == argc);
  assert(is_valid_argv_arg_2 == argv);
  assert(printf_num_calls == 1);
  assert(strcmp(printf_arg_1, USAGEF_VERSION_FORMAT) == 0);
  assert(strcmp(printf_arg_2, USAGEF_VERSION) == 0);
  free_argv(argv);
}

void test_run_fail() {
  is_valid_argv_reset(0);
  printf_reset();
  const int argc = 101;
  char **argv = create_argv();

  int actual_return = run(argc, argv);

  assert(actual_return == 1);
  assert(is_valid_argv_num_calls == 1);
  assert(is_valid_argv_arg_1 == argc);
  assert(is_valid_argv_arg_2 == argv);
  assert(printf_num_calls == 1);
  assert(strcmp(printf_arg_1, "Usage: usagef %s\n") == 0);
  assert(strcmp(printf_arg_2, ARG_VERSION) == 0);
  free_argv(argv);
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_run_success();
  test_run_fail();
  return 0;
}
