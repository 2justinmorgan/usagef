#include "stdlib.h"
#include "string.h"

char *str_cpy(char *source) {
  int i = 0;
  int len = strlen(source);
  char *destination = (char *)calloc(len + 1, sizeof(char));
  for (i = 0; i < len; i++) {
    destination[i] = source[i];
  }
  destination[i] = '\0';
  return destination;
}
