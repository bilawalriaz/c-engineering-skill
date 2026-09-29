#include <stddef.h>
#include <stdint.h>
#include <string.h>

/* Demonstrates a bounded byte-span parser suitable for libFuzzer. */
int parse_bytes(const uint8_t *data, size_t size)
{
    uint32_t length;
    if (data == NULL || size < sizeof length) {
        return -1;
    }
    memcpy(&length, data, sizeof length);
    if ((uintmax_t)length > (uintmax_t)(size - sizeof length)) {
        return -1;
    }
    return 0;
}

#ifndef C_ENGINEERING_TEST
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    (void)parse_bytes(data, size);
    return 0;
}
#endif
