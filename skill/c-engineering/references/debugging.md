# Debugging C failures

Capture the exact compiler/linker command, target, optimization, input, environment, and failing assertion or sanitizer trace. Reproduce with the smallest input. Preserve the first fault; later crashes may be consequences of earlier corruption.

Rebuild with symbols and moderate optimization (`-g -O1 -fno-omit-frame-pointer`) when compatible. Use ASan/UBSan for bounds, lifetime, and selected UB; TSan for races; debugger/watchpoints for state transitions; core files only where permitted. A crash location may be where corruption became visible, not where it began.

After a fix, add a regression test, run it under the relevant configuration, and inspect ownership and cleanup on neighboring error paths. Do not suppress the report or change timing with sleeps as a fix.
