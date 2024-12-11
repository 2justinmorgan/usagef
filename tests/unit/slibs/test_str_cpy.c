#include "../common.h"
#include "usagef/slibs/string.h"
#include <stddef.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int calloc_num_calls;
int calloc_arg1;
int calloc_arg2;

void *calloc(size_t nitems, size_t size) {
  calloc_num_calls++;
  calloc_arg1 = (int)nitems;
  calloc_arg2 = (int)size;
  return (char *)malloc(size * nitems);
}

void reset_calloc() {
  calloc_num_calls = 0;
  calloc_arg1 = -1;
  calloc_arg2 = -1;
}

void test_str_cpy_empty(char *test_type) {
  reset_calloc();
  char *input_str = "";
  char *actual = str_cpy(input_str);
  assert(strcmp(actual, "") == 0);
  if (strcmp(test_type, TEST_TYPE_VALGRIND) != 0) {
    assert(calloc_num_calls == 1);
    assert(calloc_arg1 == strlen(input_str) + 1);
    assert(calloc_arg2 == 1);
  }
  actual[0] = 'A';
  free(actual);
}

void test_str_cpy_base(char *test_type) {
  reset_calloc();
  char *input_str = "wowzers";
  char *actual = str_cpy(input_str);
  assert(strcmp(actual, "wowzers") == 0);
  if (strcmp(test_type, TEST_TYPE_VALGRIND) != 0) {
    assert(calloc_num_calls == 1);
    assert(calloc_arg1 == strlen(input_str) + 1);
    assert(calloc_arg2 == 1);
  }
  actual[0] = 'A';
  free(actual);
}

void test_str_cpy_blank(char *test_type) {
  reset_calloc();
  char *input_str = " ";
  char *actual = str_cpy(input_str);
  assert(strcmp(actual, " ") == 0);
  if (strcmp(test_type, TEST_TYPE_VALGRIND) != 0) {
    assert(calloc_num_calls == 1);
    assert(calloc_arg1 == strlen(input_str) + 1);
    assert(calloc_arg2 == 1);
  }
  actual[0] = 'A';
  free(actual);
}

void check_args(int argc, char **argv) {
  char args[255];
  char f[] = "--test-type <%s|%s|%s>";
  sprintf(args, f, TEST_TYPE_COVERAGE, TEST_TYPE_UNIT, TEST_TYPE_VALGRIND);
  if (argc < 3) {
    fprintf(stderr, "Usage: %s %s\n", argv[0], args);
    exit(1);
  }
}

int main(int argc, char **argv) {
  check_args(argc, argv);
  begin_tests(argv);
  test_str_cpy_empty(argv[2]);
  test_str_cpy_base(argv[2]);
  test_str_cpy_blank(argv[2]);
  return 0;
}
