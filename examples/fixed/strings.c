#include <stddef.h>
#include <string.h>

int copy_name(char *dst, size_t capacity, const char *src);

int copy_name(char *dst, size_t capacity, const char *src)
{
    size_t length;
    if (dst == NULL || src == NULL || capacity == 0) {
        return -1;
    }
    length = strlen(src);
    if (length >= capacity) {
        return -1;
    }
    memcpy(dst, src, length + 1);
    return 0;
}
