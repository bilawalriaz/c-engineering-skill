# Pointers, aliasing, and alignment

A pointer is not a general integer address. Pointer arithmetic and subtraction are defined within the same array object (plus one-past for limited operations); do not form arbitrary pointers by integer arithmetic. Pointer provenance models continue to evolve; avoid relying on nonportable address reconstruction.

Do not cast a byte buffer to a wider pointer and dereference unless alignment, object lifetime/effective type, size, and aliasing rules all permit it. For serialized data, copy bytes into a correctly declared scalar with `memcpy`, then convert byte order explicitly. `memcpy` requires nonoverlapping ranges; use `memmove` for overlap. Access through character types is permitted to inspect object representation, but does not make arbitrary reverse casts valid.

Check alignment before APIs requiring it. `malloc` provides alignment suitable for types with fundamental alignment; over-aligned or device memory may need platform-specific allocation. Do not assume packed structs are safely aligned or portable wire formats.
