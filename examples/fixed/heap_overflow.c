#include <stdlib.h>

int main(void)
{
    unsigned char *bytes = malloc(5);
    if (bytes == NULL) return 2;
    bytes[4] = 1;
    free(bytes);
    return 0;
}
