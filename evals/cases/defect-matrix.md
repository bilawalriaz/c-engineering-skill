# Defect matrix

Each row maps a runnable specimen to a corrected example. Compile-fail and sanitizer findings depend on compiler, target, flags, and the executed path; manual contract review remains necessary.

| Defect | Buggy specimen | Corrected example | Likely evidence |
|---|---|---|---|
| Heap buffer overflow | `buggy/heap_overflow.c` | `fixed/heap_overflow.c` | ASan runtime test in `tests/test-scripts.sh` |
| Stack buffer overflow and off-by-one loop | `buggy/stack_overflow.c`, `buggy/off_by_one.c` | `fixed/stack_overflow.c`, `fixed/off_by_one.c` | compiler bounds warning, ASan, exact-boundary tests |
| Use-after-free, dangling return, bad ownership transfer | `buggy/ownership.c` | `fixed/ownership.c` | ASan and owner/borrower review |
| Double free | `buggy/double_free.c` | `fixed/double_free.c` | ASan/runtime and analyzer |
| Memory leak | `buggy/leak.c` | `fixed/leak.c` | LeakSanitizer where supported; ownership review |
| Resource leak on allocation failure | `buggy/resource_leak.c` | `fixed/resource_leak.c` | analyzer and injected-failure path test |
| Signed/unsigned conversion | `buggy/signed_unsigned.c` | `fixed/signed_unsigned.c` | `-Wconversion`, negative-length boundary test |
| Integer overflow in allocation size | `buggy/overflow.c` | `fixed/overflow.c` | `SIZE_MAX` boundary test; analyzer; UBSan for signed arithmetic |
| `sizeof(pointer)` allocation | `buggy/sizeof_pointer.c` | `fixed/sizeof_pointer.c` | review allocation extent and count boundaries |
| Missing string terminator | `buggy/strings.c` | `fixed/strings.c` | analyzer, ASan on use, exact-capacity tests |
| Unsafe realloc assignment | `buggy/realloc.c` | `fixed/realloc.c` | allocation-failure injection and ownership review |
| Partial write / ignored result | `buggy/io.c`, `buggy/ignored_result.c` | `fixed/io.c`, `fixed/ignored_result.c` | controlled pipe/socket test and analyzer |
| Uninitialized variable | `buggy/uninitialized.c` | `fixed/uninitialized.c` | compiler warning, MemorySanitizer (instrument all relevant code), analyzer |
| Overlapping `memcpy` | `buggy/overlap.c` | `fixed/overlap.c` | analyzer and overlap-specific test |
| Data race | `buggy/race.c` | `fixed/race.c` | ThreadSanitizer and synchronization proof |
| Parser out-of-bounds/alignment | `buggy/fuzz_bytes.c` | `fixed/fuzz_bytes.c` | libFuzzer+ASan/UBSan; fixed parser has empty/short/oversize unit cases |

Sanitizers do not detect every conversion, ownership, race, or cleanup defect on every host. Several cases also require controlled failure injection or platform-specific runtime support beyond this small suite.
