
/* NOLINTNEXTLINE(llvm-header-guard) */
#ifndef USAGEF_ARGV_H
#define USAGEF_ARGV_H

#define ITEM_ALIGNMENT_SIZE 32

typedef struct Item {
  char *section_name;
  char *args;
  char *description;
  struct Item *next;
} __attribute__((aligned(ITEM_ALIGNMENT_SIZE))) Item;

int is_valid_argv(int argc, char **argv);
Item *get_item(char *argv_item_string);

#endif
