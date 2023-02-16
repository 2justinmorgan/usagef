#include "common.h"
#include <libgen.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
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

void begin_tests(char **argv) {
  fprintf(stdout, "running %s\n", basename(argv[0]));
}
