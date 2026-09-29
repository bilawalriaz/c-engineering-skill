# Constrained and unusual platforms

Do not assume a full hosted libc, POSIX, filesystem, dynamic loader, threads, or standard startup. Establish capabilities from repository headers, SDK docs, linker scripts, known-good examples, and target builds. Record loader format, ABI, syscalls, graphics/runtime rules, memory limits, and callback constraints.

Keep platform substitutions behind narrow interfaces. Check exact SDK types and calling conventions. Avoid hallucinating APIs from a related platform or version. A host build can test portable logic but cannot establish target ABI, timing, hardware behavior, or loader compatibility; say so in results.
