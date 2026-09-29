#include <stdlib.h>

int main(void)
{
    void *resource = malloc(32);
    return resource == NULL;
}
