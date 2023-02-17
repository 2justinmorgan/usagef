#include "common.h"
#include "usagef/const.h"
#include <stdio.h>
#include <string.h>

void test_const_char_arrays() {
  assert(0 == strcmp(USAGEF_VERSION, "test-default"));
  assert(0 == strcmp(ARG_VERSION, "--version"));
  assert(0 == strcmp(USAGEF_VERSION_FORMAT, "%s\n"));
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_const_char_arrays();
  return 0;
}
