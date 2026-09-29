#include <stdlib.h>

int *make_array(size_t count)
{
    int *items = malloc(sizeof items * count); /* sizeof items is pointer size */
    return items;
}
