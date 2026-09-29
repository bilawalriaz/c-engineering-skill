#include <stddef.h>

static int valid_span(const unsigned char *data, size_t size)
{
    return size == 0 || data != NULL;
}

int main(void)
{
    return valid_span(NULL, 0) ? 0 : 1;
}
