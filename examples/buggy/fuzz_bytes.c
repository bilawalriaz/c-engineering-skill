#include <stddef.h>
#include <stdint.h>

/* Intentionally unsafe target: reads a 4-byte length without checking input. */
int LLVMFuzzerTestOneInput(const uint8_t *data, size_t size)
{
    size_t length = *(const uint32_t *)data;
    return size >= length ? 0 : 0;
}
