# Error handling

For every function, define success results, failure results, whether outputs are modified on failure, and ownership after each result. Preserve useful diagnostics and the primary failure when cleanup also fails.

Audit allocation failure, partial initialization, malformed input, callbacks, file/socket failure, short I/O, timeout, thread creation, and cleanup. On POSIX, APIs that use `errno` generally set it only on indicated failure; save it before cleanup can overwrite it. Do not inspect `errno` after success unless the API specifically defines that use.

Assertions document programmer invariants; they are not input validation because builds may disable them and malformed external data is recoverable. Do not convert failure into success by discarding return values, and do not silently truncate. For outputs, either leave them unchanged on failure or document a valid partial-result contract.
