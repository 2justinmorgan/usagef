#include "common.h"
#include <stdio.h>
#include <unistd.h>

void assert_base(int is_one, const char *file_path, const char *name_func,
                 int line_num) {
  if (is_one == 1) {
    return;
  }
  (void)fprintf(stderr, "assert failed %s:%s:%d\n", file_path, name_func,
                line_num);
  _exit(1);
}
