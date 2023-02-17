#include "../common.h"
#include "usagef/argv/argv.h"
#include "usagef/const.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int strcmp_num_calls;
int strcmp_return_val;
char *strcmp_arg_1;
char *strcmp_arg_2;

int strcmp(const char *arr_a, const char *arr_b) {
  strcmp_num_calls++;
  strcmp_arg_1 = (char *)arr_a;
  strcmp_arg_2 = (char *)arr_b;
  return strcmp_return_val;
}

void strcmp_reset(int return_val) {
  strcmp_num_calls = 0;
  strcmp_return_val = return_val;
  strcmp_arg_1 = NULL;
  strcmp_arg_2 = NULL;
}

char **create_argv(char *argv_1) {
  char **argv = (char **)malloc(sizeof(char *) * 2);
  argv[0] = (char *)malloc(sizeof(char));
  argv[1] = (char *)malloc(sizeof(char) * strlen(argv_1));
  strncpy(argv[1], argv_1, strlen(argv_1));
  return argv;
}

void free_argv(char **argv) {
  free(argv[1]);
  free(argv[0]);
  free(argv);
}

void test_is_valid_argv_success() {
  strcmp_reset(0);
  int argc = 2;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 1);
  assert(strcmp_num_calls == 1);
  assert(strncmp(strcmp_arg_1, argv_1, strlen(argv_1)) == 0);
  assert(strncmp(strcmp_arg_2, ARG_VERSION, strlen(ARG_VERSION)) == 0);
  free_argv(argv);
}

void test_is_valid_argv_fail() {
  strcmp_reset(1);
  int argc = 2;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 0);
  assert(strcmp_num_calls == 1);
  assert(strncmp(strcmp_arg_1, argv_1, strlen(argv_1)) == 0);
  assert(strncmp(strcmp_arg_2, ARG_VERSION, strlen(ARG_VERSION)) == 0);
  free_argv(argv);
}

void test_is_valid_argv_fail_no_args() {
  strcmp_reset(1);
  int argc = 0;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 0);
  assert(strcmp_num_calls == 0);
  free_argv(argv);
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_is_valid_argv_success();
  test_is_valid_argv_fail();
  test_is_valid_argv_fail_no_args();
  return 0;
}
