#include <stdlib.h>

int grow(unsigned char **buffer, size_t size)
{
    *buffer = realloc(*buffer, size); /* loses original pointer on failure */
    return *buffer == NULL ? -1 : 0;
}
