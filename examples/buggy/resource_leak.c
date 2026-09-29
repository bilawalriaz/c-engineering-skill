#include <stdio.h>
#include <stdlib.h>

int load_file(const char *path)
{
    FILE *file = fopen(path, "rb");
    void *buffer;
    if (file == NULL) return -1;
    buffer = malloc(64);
    if (buffer == NULL) return -1; /* file leaked */
    free(buffer);
    fclose(file);
    return 0;
}
