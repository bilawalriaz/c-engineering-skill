#include <stddef.h>
#include <string.h>

int copy_bytes(unsigned char *dst, size_t capacity, const unsigned char *src, size_t length);

int copy_bytes(unsigned char *dst, size_t capacity,
               const unsigned char *src, size_t length)
{
    if (length > capacity || (length != 0 && (dst == NULL || src == NULL))) {
        return -1;
    }
    if (length != 0) {
        memmove(dst, src, length);
    }
    return 0;
}
