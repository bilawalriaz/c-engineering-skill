#include <stdlib.h>

int main(void)
{
    volatile unsigned char *bytes = malloc(4);
    if (bytes == NULL) return 2;
    bytes[4] = 1; /* one byte past the allocation */
    free((void *)bytes);
    return 0;
}
