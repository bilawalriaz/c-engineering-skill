#include <stdlib.h>

int main(void)
{
    void *resource = malloc(32);
    if (resource == NULL) return 1;
    free(resource);
    return 0;
}
