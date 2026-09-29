# Sanitizers

Sanitizers instrument a build and report selected defects reached at runtime; they are not proofs and may alter timing, memory use, ABI, or layout. Preserve debug symbols (`-g`) and frame pointers where supported. Verify both instrumentation and the runtime on the actual host.

- **AddressSanitizer (ASan):** out-of-bounds and lifetime errors such as use-after-free and double free. Leak detection is integrated on some platforms, with separate availability/configuration elsewhere.
- **UndefinedBehaviorSanitizer (UBSan):** selected UB including signed overflow, invalid shifts, and misaligned/null access. It does not detect every instance of UB.
- **ThreadSanitizer (TSan):** data races in instrumented code. Use a separate build; TSan generally cannot be combined with ASan and has substantial memory/runtime cost.
- **MemorySanitizer (MSan):** uninitialized reads; effective only when relevant code and dependencies are instrumented, which can make it difficult to use on ordinary system libraries.

`-fsanitize=address,undefined` is a useful combined development configuration where supported. Test the sanitizer runtime with a minimal program before interpreting a failed build as a source defect. A clean report covers only executed paths. Do not ship sanitizer runtimes as production hardening without platform-specific review.
