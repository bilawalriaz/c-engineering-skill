#include <string.h>

void copy_name(char *dst, const char *src)
{
    strncpy(dst, src, 8); /* may leave dst unterminated */
}
