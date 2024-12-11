#include "../common.h"
#include "usagef/const.h"
#include "usagef/input/input.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int strlen_num_calls;
char *strlen_arg1;

long unsigned int strlen(const char *string) {
  long unsigned int len = 0;
  strlen_num_calls++;
  strlen_arg1 = (char *)string;
  while (string[++len] != '\0') {
  }
  return len;
}

void reset_strlen() {
  strlen_num_calls = 0;
  strlen_arg1 = "";
}

void free_all(Item *item) {
  free(item->section_name);
  free(item);
}

void test_get_item_empty() {
  reset_strlen();
  char *argv_item_string = "::";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, "") == 0);
  assert(strcmp(actual_return->args, "") == 0);
  assert(strcmp(actual_return->description, "") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_base() {
  reset_strlen();
  char *argv_item_string = "this one:here is great:to see";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, "this one") == 0);
  assert(strcmp(actual_return->args, "here is great") == 0);
  assert(strcmp(actual_return->description, "to see") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_extra_spaces() {
  reset_strlen();
  char *argv_item_string = " this  one  :  here is great  :   to see   ";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, " this  one  ") == 0);
  assert(strcmp(actual_return->args, "  here is great  ") == 0);
  assert(strcmp(actual_return->description, "   to see   ") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_empty_section_name() {
  reset_strlen();
  char *argv_item_string = ":  here is great  :   to see   ";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, "") == 0);
  assert(strcmp(actual_return->args, "  here is great  ") == 0);
  assert(strcmp(actual_return->description, "   to see   ") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_empty_section_name_blank() {
  reset_strlen();
  char *argv_item_string = " :  here is great  :   to see   ";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, " ") == 0);
  assert(strcmp(actual_return->args, "  here is great  ") == 0);
  assert(strcmp(actual_return->description, "   to see   ") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_empty_args() {
  reset_strlen();
  char *argv_item_string = " this  one  ::   to see   ";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, " this  one  ") == 0);
  assert(strcmp(actual_return->args, "") == 0);
  assert(strcmp(actual_return->description, "   to see   ") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_empty_args_blank() {
  reset_strlen();
  char *argv_item_string = " this  one  : :   to see   ";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, " this  one  ") == 0);
  assert(strcmp(actual_return->args, " ") == 0);
  assert(strcmp(actual_return->description, "   to see   ") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_empty_description() {
  reset_strlen();
  char *argv_item_string = " this  one  :  here is great  :";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, " this  one  ") == 0);
  assert(strcmp(actual_return->args, "  here is great  ") == 0);
  assert(strcmp(actual_return->description, "") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

void test_get_item_empty_description_blank() {
  reset_strlen();
  char *argv_item_string = " this  one  :  here is great  : ";

  Item *actual_return = get_item(argv_item_string);

  assert(strcmp(actual_return->section_name, " this  one  ") == 0);
  assert(strcmp(actual_return->args, "  here is great  ") == 0);
  assert(strcmp(actual_return->description, " ") == 0);
  assert(strlen_num_calls == 1);
  assert(strlen_arg1 == argv_item_string);
  free_all(actual_return);
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_get_item_empty();
  test_get_item_base();
  test_get_item_extra_spaces();
  test_get_item_empty_section_name();
  test_get_item_empty_section_name_blank();
  test_get_item_empty_args();
  test_get_item_empty_args_blank();
  test_get_item_empty_description();
  test_get_item_empty_description_blank();
  return 0;
}
