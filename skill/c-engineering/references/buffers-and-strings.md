# Buffers and strings

Before every new or changed write, record allocation extent, max write, units (bytes or elements), terminator rule, size arithmetic, overlap rule, source/destination lifetime, and zero-length behavior. Test capacity−1, exactly capacity, and capacity+1 where meaningful.

- `memcpy(dst, src, n)` copies exactly `n` bytes and requires valid ranges that do not overlap. `memmove` permits overlap. `memset` writes `n` bytes, not `n` elements.
- `strcpy`/`strcat` require a sufficiently large destination and terminated source. Prefer length-aware APIs or explicit checked copies. `strncpy` may leave the result unterminated when the source is at least `n`, and pads the remainder with NUL bytes; it is not a general safe `strcpy` replacement.
- `snprintf` writes at most `size` bytes including a terminator when `size > 0`; its return is the number of bytes that would have been written excluding the terminator. Check negative return and truncation (`(size_t)r >= size`). `sprintf` has no capacity argument.
- `scanf` string conversions need field widths and correct pointer types; parsing with `strto*` often makes range/error handling clearer.
- `read`, `recv`, `fread` and peers may return fewer bytes than requested. Loop according to the API contract, handle EOF, error, and `EINTR` where applicable. Writes can be partial too.

A zero-length operation still needs valid API-specific pointer arguments; do not assume null pointers are accepted merely because `n == 0`. Check additions for a terminator (`len + 1`) before allocation.
