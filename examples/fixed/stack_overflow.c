#include <stddef.h>

int copy_input(const char *input, size_t length);

int copy_input(const char *input, size_t length)
{
    char buffer[8];
    if (input == NULL || length > sizeof buffer) return -1;
    for (size_t i = 0; i < length; ++i) buffer[i] = input[i];
    return length == 0 ? 0 : buffer[0];
}
