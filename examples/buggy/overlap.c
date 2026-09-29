#include <string.h>

void shift_right(char *text, size_t length)
{
    memcpy(text + 1, text, length);
}
