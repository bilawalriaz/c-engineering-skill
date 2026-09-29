#include <stddef.h>
#include <stdint.h>
#include <stdlib.h>

void *allocate_items(size_t count, size_t item_size);

void *allocate_items(size_t count, size_t item_size)
{
    if (item_size != 0 && count > SIZE_MAX / item_size) {
        return NULL;
    }
    return malloc(count * item_size);
}
