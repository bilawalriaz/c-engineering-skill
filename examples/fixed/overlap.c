#include <string.h>

void shift_right(char *text, size_t length);

void shift_right(char *text, size_t length)
{
    memmove(text + 1, text, length);
}
