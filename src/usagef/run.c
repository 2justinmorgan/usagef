#include "run.h"
#include "argv/argv.h"
#include "const.h"
#include "slibs/stdio.h"

int run(int argc, char **argv) {
  int is_valid = is_valid_argv(argc, argv);
  is_valid
      ? printf(USAGEF_VERSION_FORMAT, USAGEF_VERSION)
      : printf("Usage: usagef %s\n", ARG_VERSION);
  return !is_valid;
}
