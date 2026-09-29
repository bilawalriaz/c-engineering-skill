# Initialization

Every object must be initialized before its value is read. Automatic objects without initializers have indeterminate values; do not rely on stack reuse or zero-looking output. `malloc` returns uninitialized storage. `calloc` zeroes bytes, which is not a universal semantic initializer for every pointer or floating representation, though all-bits-zero is common.

Initialize structures with `{0}` when zero initialization is the intended contract, then set required fields. This does not replace validation of required values. Track partial initialization so cleanup only releases acquired members. Beware padding bytes in structs: do not compare whole structs with `memcmp` or serialize them as a portable format unless representation is explicitly part of the ABI.

`memset(&object, 0, sizeof object)` is byte fill, not general assignment for arbitrary values. Use a typed initializer when semantic initialization matters.
