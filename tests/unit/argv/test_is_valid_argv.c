#include "../common.h"
#include "usagef/argv/argv.h"
#include "usagef/const.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct Node {
  char *str;
  struct Node *next;
  struct Node *head;
} Node;

int strcmp_num_calls;
int *strcmp_return_vals;
char *strcmp_arg_1;
Node *strcmp_arg_2;

int strcmp(const char *arr_a, const char *arr_b) {
  strcmp_num_calls++;
  strcmp_arg_1 = (char *)arr_a;

  strcmp_arg_2->str = (char *)arr_b;
  strcmp_arg_2->next = (Node *)calloc(1, sizeof(Node));
  strcmp_arg_2->next->head = strcmp_arg_2->head;
  strcmp_arg_2 = strcmp_arg_2->next;

  return strcmp_return_vals[strcmp_num_calls - 1];
}

void free_node(Node *node) {
  Node *next;
  Node *curr;

  if (node == NULL)
    return;

  curr = node->head;
  while (curr != NULL) {
    next = curr->next;
    free(curr);
    curr = next;
  }
}

void strcmp_reset(int *return_vals) {
  strcmp_num_calls = 0;
  strcmp_return_vals = return_vals;
  strcmp_arg_1 = NULL;

  free_node(strcmp_arg_2);
  strcmp_arg_2 = (Node *)calloc(1, sizeof(Node));
  strcmp_arg_2->head = strcmp_arg_2;
}

char **create_argv(char *argv_1) {
  char **argv = (char **)malloc(sizeof(char *) * 2);
  argv[0] = (char *)malloc(sizeof(char));
  argv[1] = (char *)malloc(sizeof(char) * strlen(argv_1));
  strncpy(argv[1], argv_1, strlen(argv_1));
  return argv;
}

void free_argv(char **argv) {
  free(argv[1]);
  free(argv[0]);
  free(argv);
}

void test_is_valid_argv_success_1() {
  strcmp_reset((int[]){0});
  Node *head;
  int argc = 2;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 1);
  assert(strcmp_num_calls == 1);
  assert(strncmp(strcmp_arg_1, argv_1, strlen(argv_1)) == 0);
  head = strcmp_arg_2->head;
  assert(strncmp(head->str, ARG_VERSION, strlen(ARG_VERSION)) == 0);
  free_argv(argv);
}

void test_is_valid_argv_success_2() {
  strcmp_reset((int[]){1, 0});
  Node *head;
  int argc = 2;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 1);
  assert(strcmp_num_calls == 2);
  assert(strncmp(strcmp_arg_1, argv_1, strlen(argv_1)) == 0);
  head = strcmp_arg_2->head;
  assert(strncmp(head->str, ARG_VERSION, strlen(ARG_VERSION)) == 0);
  assert(strncmp(head->next->str, ARG_HELP, strlen(ARG_HELP)) == 0);
  free_argv(argv);
}

void test_is_valid_argv_fail() {
  strcmp_reset((int[]){1});
  Node *head;
  int argc = 2;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 0);
  assert(strcmp_num_calls == 2);
  assert(strncmp(strcmp_arg_1, argv_1, strlen(argv_1)) == 0);
  head = strcmp_arg_2->head;
  assert(strncmp(head->str, ARG_VERSION, strlen(ARG_VERSION)) == 0);
  assert(strncmp(head->next->str, ARG_HELP, strlen(ARG_HELP)) == 0);
  free_argv(argv);
}

void test_is_valid_argv_fail_no_args() {
  strcmp_reset((int[]){1});
  int argc = 0;
  char argv_1[] = "something";
  char **argv = create_argv(argv_1);

  int actual_return = is_valid_argv(argc, argv);

  assert(actual_return == 0);
  assert(strcmp_num_calls == 0);
  free_argv(argv);
}

int main(int argc, char **argv) {
  begin_tests(argv);
  test_is_valid_argv_success_1();
  test_is_valid_argv_success_2();
  test_is_valid_argv_fail();
  test_is_valid_argv_fail_no_args();
  return 0;
}
