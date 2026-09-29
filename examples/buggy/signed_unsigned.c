#include <stddef.h>

int has_bytes(int length, size_t capacity)
{
    return (size_t)length <= capacity; /* negative length becomes very large */
}
