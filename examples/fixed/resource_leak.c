#include <stdio.h>
#include <stdlib.h>

int load_file(const char *path);

int load_file(const char *path)
{
    FILE *file = fopen(path, "rb");
    void *buffer;
    int result = -1;
    if (file == NULL) return -1;
    buffer = malloc(64);
    if (buffer == NULL) goto cleanup;
    free(buffer);
    result = 0;
cleanup:
    if (fclose(file) != 0 && result == 0) result = -1;
    return result;
}
