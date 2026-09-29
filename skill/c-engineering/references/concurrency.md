# Concurrency

In C11, conflicting non-atomic accesses without a happens-before relation form a data race and have undefined behavior. `volatile` does not make shared state atomic and does not synchronize threads. Use mutexes or atomics with a reasoned memory order.

For mutexes and condition variables, define lock order and protected state. Wait in a predicate loop because wakeups can be spurious. Define who owns shared objects, when callbacks may run, and how shutdown prevents new work before joining threads and freeing shared state. Avoid arbitrary sleeps: they change timing without establishing synchronization.

Use ThreadSanitizer when supported, then test lifecycle and contention paths. It cannot prove race freedom and may not support every runtime or low-level synchronization primitive. Atomic lock-free assumptions and memory-order changes require target/compiler evidence.
