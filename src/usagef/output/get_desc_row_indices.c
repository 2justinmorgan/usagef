#include "../slibs/stdlib.h"
#include "output.h"

/*
  returns indices that denote the start and end of description rows while
  the first element of this arr specifies the number of rows to be outputted
*/
int *get_desc_row_indices(int col_width, const char *desc, int desc_len) {
  int *row_indices = (int *)calloc(desc_len > 1 ? desc_len : 2, sizeof(int));
  int i = -1;
  int j = 1;
  int num_rows = 1;
  int word_start_i = -1;
  int is_empty = 0;
  int column_i = 0;

  row_indices[1] = -1;

  while (++i < desc_len) {
    is_empty = desc[i] == ' ';

    if (!is_empty && word_start_i == -1) {
      word_start_i = i;
    }
    if (is_empty) {
      word_start_i = -1;
    }

    if (++column_i != col_width) {
      continue;
    }

    num_rows++;
    i = is_empty ? i : (word_start_i - 1);
    row_indices[j++] = i;
    while (desc[i++] == ' ') {
    }
    row_indices[j++] = i - 1;
    i -= 2;
    column_i = 0;
    word_start_i = -1;
  }

  row_indices[0] = num_rows;
  row_indices[j] = desc_len > 0 ? i - 1 : 0;
  return row_indices;
}
