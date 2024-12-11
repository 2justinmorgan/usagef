#include "../const.h"
#include "../slibs/string.h"
#include "map.h"

unsigned int to_num(const char *string) {
  int i = 0;
  unsigned int shift_amount = HASH_BIT_SHIFT_AMOUNT;
  unsigned int hash = HASH_TABLE_SIZE_INIT;

  for (i = 0; i < strlen(string); i++) {
    hash = ((hash << shift_amount) + hash) + (int)string[i];
  }

  return hash;
}
