#include "../common.h"
#include "usagef/output/output.h"
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

int calloc_num_calls;
int calloc_arg1;
int calloc_arg2;

void *calloc(size_t arg1, size_t arg2) {
  int *actual = (int *)malloc(arg2 * arg1);
  for (int i = 0; i < arg1; i++)
    actual[i] = 0;

  calloc_num_calls++;
  calloc_arg1 = arg1;
  calloc_arg2 = arg2;

  return actual;
}

void reset_calloc() {
  calloc_num_calls = 0;
  calloc_arg1 = -1;
  calloc_arg2 = -1;
}

void test_get_desc_row_indices_base_1() {
  reset_calloc();
  int column2_width = 25;
  char *desc = "";
  int desc_len = strlen(desc);
  int expected[] = {1, 0};

  int *actual = get_desc_row_indices(column2_width, desc, desc_len);

  for (int i = 0; i < sizeof(expected) / sizeof(expected[0]); i++)
    assert(actual[i] == expected[i]);
  assert(calloc_num_calls = 1);
  assert(calloc_arg1 == 2);
  assert(calloc_arg2 == sizeof(int));

  free(actual);
}

void test_get_desc_row_indices_base_2() {
  reset_calloc();
  int column2_width = 25;
  char *desc = "this is my desc that must take some time to detail to you too";
  int desc_len = strlen(desc);
  int expected[] = {3, 20, 21, 43, 44, 60};

  int *actual = get_desc_row_indices(column2_width, desc, desc_len);

  for (int i = 0; i < sizeof(expected) / sizeof(expected[0]); i++)
    assert(actual[i] == expected[i]);
  assert(calloc_num_calls = 1);
  assert(calloc_arg1 == desc_len);
  assert(calloc_arg2 == sizeof(int));

  free(actual);
}

void test_get_desc_row_indices_multi_empty_line_end() {
  reset_calloc();
  int column2_width = 8;
  char *desc = "012345   901 34 6789";
  int desc_len = strlen(desc);
  int expected[] = {3, 7, 9, 15, 16, 19};

  int *actual = get_desc_row_indices(column2_width, desc, desc_len);

  for (int i = 0; i < sizeof(expected) / sizeof(expected[0]); i++)
    assert(actual[i] == expected[i]);
  assert(calloc_num_calls = 1);
  assert(calloc_arg1 == desc_len);
  assert(calloc_arg2 == sizeof(int));

  free(actual);
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_get_desc_row_indices_base_1();
  test_get_desc_row_indices_base_2();
  test_get_desc_row_indices_multi_empty_line_end();
  return 0;
}
