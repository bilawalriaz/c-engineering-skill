# Investigate memory corruption

Trace buffer extents and all writers; verify bytes versus elements, checked size arithmetic, terminators, overlap, and object lifetime. Instrument the earliest feasible boundary. Examine realloc handling, ownership transfer, and partial cleanup. Minimize a sanitizer reproducer and retain it as a test. Do not infer that absence of an ASan report proves safety.
