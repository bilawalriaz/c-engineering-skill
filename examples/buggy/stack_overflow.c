#include <stddef.h>

int copy_input(const char *input, size_t length)
{
    char buffer[8];
    for (size_t i = 0; i <= length; ++i) buffer[i] = input[i];
    return buffer[0];
}
