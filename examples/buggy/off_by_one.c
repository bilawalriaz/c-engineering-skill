#include <stddef.h>

void clear_bytes(unsigned char *buffer, size_t length)
{
    for (size_t i = 0; i <= length; ++i) buffer[i] = 0;
}
