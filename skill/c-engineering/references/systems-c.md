# Systems C

Treat OS interfaces, syscalls, descriptors, mappings, process/thread lifecycle, and signals as explicit ownership and error contracts. Distinguish portable C from POSIX and OS-specific behavior. Read the target ABI and kernel/API documentation before relying on layouts or flags.

For parsers and IPC, validate lengths before pointer arithmetic or allocation; make byte order explicit and avoid casting serialized bytes to structs. For low-level lock-free code, document the memory model and prove lifetime as well as atomic ordering. Use sanitizers and fault-injection tests where feasible.
