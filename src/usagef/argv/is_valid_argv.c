#include "../const.h"
#include "../slibs/string.h"
#include "argv.h"

int is_valid_argv(int argc, char **argv) {
  if (argc == 2 && strcmp(argv[1], ARG_VERSION) == 0) {
    return 1;
  }
  return 0;
}
