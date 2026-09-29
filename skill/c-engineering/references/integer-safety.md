# Integer safety

C integer conversions can change value. Unsigned arithmetic wraps modulo 2^N; signed overflow is undefined. Integer promotions and usual arithmetic conversions may convert a negative signed value to a large unsigned value.

Before calculating allocation or indexing sizes, prove each operation representable. For multiplication, check `count > SIZE_MAX / element_size` when `element_size != 0`; for addition, check `a > SIZE_MAX - b`. Validate signed input is nonnegative before converting to `size_t`, and range-check before narrowing. Do not add casts just to silence `-Wconversion`.

`sizeof` reports the size of the operand's type, not the allocation behind a pointer. Prefer `sizeof *ptr` for an element allocation and preserve count separately. For fixed-width protocol values, use `<stdint.h>` types only when available and explicitly define byte order and range. Plain `char` signedness is implementation-defined.
