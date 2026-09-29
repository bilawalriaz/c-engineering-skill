#include <stdlib.h>

int grow(unsigned char **buffer, size_t size);

int grow(unsigned char **buffer, size_t size)
{
    unsigned char *next;
    if (buffer == NULL || size == 0) {
        return -1;
    }
    next = realloc(*buffer, size);
    if (next == NULL) {
        return -1;
    }
    *buffer = next;
    return 0;
}
