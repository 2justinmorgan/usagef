#include "input.h"
#include "../slibs/stdlib.h"
#include "../slibs/string.h"
#include "../const.h"

Definition *get_definition(int argc, char **argv) {
  int i = 0;
  int mult = HASH_TABLE_SIZE_MULTIPLIER;
  Definition *def = (Definition *)calloc(1, sizeof(Definition));
  def->sections_map = (Item *)calloc(argc * mult, sizeof(Item));
  StrNode *sect_names_map = (StrNode *)calloc(argc * mult, sizeof(StrNode));

  for (i = 0; i < argc; i += 2) {
    if (strcmp(argv[i], ARG_NAME) == 0) {
		  def->prog_name = (char *)calloc(strlen(argv[i + 1]), sizeof(char));
			def->prog_name = 
    }
  }
}
