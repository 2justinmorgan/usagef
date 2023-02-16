#ifndef TESTS_COMMON_H
#define TESTS_COMMON_H

void assert_base(int is_one, const char *file_path, const char *name_func,
                 int line_num);
void begin_tests(char **argv);

#define assert(is_one) assert_base(is_one, __FILE__, __func__, __LINE__)

#endif
