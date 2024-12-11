
/* NOLINTNEXTLINE(llvm-header-guard) */
#ifndef USAGEF_ARGV_H
#define USAGEF_ARGV_H

#define ITEM_ALIGNMENT_SIZE 64
#define STRNODE_ALIGNMENT_SIZE 32
#define DEFINITION_ALIGNMENT_SIZE 64

typedef struct Item {
  char *section_name;
  char *args;
  char *description;
  struct Item *next;
  struct Item *last;
} __attribute__((aligned(ITEM_ALIGNMENT_SIZE))) Item;

typedef struct StrNode {
  char *string;
  struct Node *next;
  struct Node *last;
} __attribute__((aligned(STRNODE_ALIGNMENT_SIZE))) StrNode;

typedef struct Definition {
  char *prog_name;
  char *argv_args;
  char *description;
  char **section_names;
  Item *sections_map;
} __attribute__((aligned(DEFINITION_ALIGNMENT_SIZE))) Definition;

int is_valid_argv(int argc, char **argv);
Item *get_item(char *argv_item_string);
Definition *get_definition(int argc, char **argv);

#endif
