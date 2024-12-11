#include "../slibs/stdlib.h"
#include "../slibs/string.h"
#include "input.h"

Item *get_item(char *argv_item_string) {
  int i = -1;
  int j = 0;
  int len = strlen(argv_item_string);
  char *argv_item = (char *)calloc(1, len + 1);
  Item *item = (Item *)calloc(1, sizeof(Item));

  for (j = 0; j < len; j++) {
    argv_item[j] = argv_item_string[j];
  }

  item->section_name = &argv_item[0];
  while (argv_item[++i] != ':') {
  }
  argv_item[i] = '\0';
  item->args = &argv_item[i + 1];
  while (argv_item[++i] != ':') {
  }
  argv_item[i] = '\0';
  item->description = (i + 1) < len ? &argv_item[i + 1] : &argv_item[i];

  return item;
}
