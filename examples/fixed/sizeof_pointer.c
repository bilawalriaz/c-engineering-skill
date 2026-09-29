#include <stdint.h>
#include <stdlib.h>

int *make_array(size_t count);

int *make_array(size_t count)
{
    if (count > SIZE_MAX / sizeof(int)) return NULL;
    return malloc(sizeof(int) * count);
}
