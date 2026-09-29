#include <stddef.h>

int has_bytes(int length, size_t capacity);

int has_bytes(int length, size_t capacity)
{
    return length >= 0 && (size_t)length <= capacity;
}
