# Debug a C crash

Record build flags, target, input, and full trace. Reduce the reproducer. Rebuild with symbols; use ASan/UBSan for memory/UB, TSan for races, and a debugger for state transitions. Treat the crash site as evidence, not necessarily the corruption source. Fix root cause, add a regression case, and rerun normal and instrumented tests.
