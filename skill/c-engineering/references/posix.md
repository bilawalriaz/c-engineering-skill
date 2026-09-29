# POSIX interfaces

This guidance applies only when the target uses POSIX. Confirm feature-test macros, target version, and headers. Windows and embedded APIs differ.

A file descriptor is a process-level small integer; `FILE *` is a buffered stdio object with separate ownership. For `read`/`write`, handle partial counts and `EINTR`, EOF, nonblocking `EAGAIN`/`EWOULDBLOCK`, and application-level deadlines as required. Do not spin on zero progress. A zero-byte read on a stream commonly indicates EOF; zero-byte write behavior is API/context dependent.

`poll`/`select` wait for readiness; readiness does not promise a full transfer. `epoll` is Linux-specific. `mmap` length, offset alignment, mapping lifetime, and file truncation are separate concerns. `fork` duplicates process state; only async-signal-safe functions are permitted in the child of a multithreaded process before `exec`. Handle descriptors across exec with close-on-exec. Signal handlers have strict async-signal-safety limits; use a self-pipe/event mechanism for complex work. Pthreads APIs return error numbers directly rather than generally using `errno`.
