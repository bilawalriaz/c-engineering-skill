#include <assert.h>
#include <stdint.h>
#include <stddef.h>
#define C_ENGINEERING_TEST
#include "../examples/fixed/fuzz_bytes.c"

int main(void)
{
    const uint8_t empty_payload[] = {0, 0, 0, 0};
    const uint8_t short_header[] = {0, 0, 0};
    const uint8_t too_long[] = {255, 255, 255, 127};
    assert(parse_bytes(empty_payload, sizeof empty_payload) == 0);
    assert(parse_bytes(short_header, sizeof short_header) == -1);
    assert(parse_bytes(too_long, sizeof too_long) == -1);
    assert(parse_bytes(NULL, 0) == -1);
    return 0;
}
