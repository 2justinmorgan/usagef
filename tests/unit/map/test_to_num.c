#include "../common.h"
#include "usagef/const.h"
#include "usagef/map/map.h"
#include <stdio.h>
#include <stdlib.h>

void test_to_num_empty() {
  char string[] = "";
  assert(to_num(string) == HASH_TABLE_SIZE_INIT);
}

void test_to_num_base() {
  char string[] = "hello";
  assert(to_num(string) == 261238937);
}

void test_to_num_large() {
  char string[] = "hhasdkfasdjfisdjfasdk    JKJDKJF74729sdfksakdlfj aksfksjeo";
  assert(to_num(string) == 1962997644);
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_to_num_empty();
  test_to_num_base();
  test_to_num_large();
  return 0;
}
