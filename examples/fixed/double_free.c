#include <stdlib.h>

int main(void)
{
    int *value = malloc(sizeof *value);
    if (value == NULL) return 1;
    free(value);
    value = NULL;
    free(value);
    return 0;
}
