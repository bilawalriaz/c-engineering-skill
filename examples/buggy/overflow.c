#include <stddef.h>
#include <stdlib.h>

void *allocate_items(size_t count, size_t item_size)
{
    /* Multiplication can wrap, yielding an undersized allocation. */
    return malloc(count * item_size);
}
