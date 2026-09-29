---
name: c-engineering
description: Apply rigorous, evidence-driven C engineering to C code changes, reviews, debugging, porting, and performance work. Use when modifying or assessing C code, build configuration, FFI, systems code, or embedded code.
---

# C Engineering

Use this skill whenever the task changes or evaluates C code, its build, or its boundary with another language or platform. A successful compile is necessary evidence, not proof of correct C. Prefer observable compiler, runtime, test, analyzer, and platform-documentation evidence to model intuition.

## Workflow

1. Read repository guidance, build files, tests, target C dialect, supported platforms, and local conventions. Keep the existing standard and build system unless the task requires a change.
2. State the relevant invariants: inputs, outputs, ownership, lifetime, bounds, concurrency, ABI, and error behavior. Classify risk; parsers, raw buffers, allocators, serialization, pointer arithmetic, and concurrency need stronger checks.
3. Open the specific [reference](references/) and [workflow](workflows/) for the risk. Change the smallest surface that preserves the contract.
4. For every buffer write, record allocation extent, maximum write in bytes/elements, terminator, size arithmetic and overflow, overlap, source lifetime, zero-length behavior, and behavior at capacity−1/capacity/capacity+1.
5. Trace ownership from acquisition through success, failure, partial initialization, and cleanup. Check nullability, borrowed pointers, transfer, truncation, short I/O, and `errno` where relevant.
6. Build with project settings and useful diagnostics; run relevant tests, analyzers, sanitizers, then boundary tests or fuzzing when inputs or memory logic warrant it. Do not force warnings-as-errors on third-party code or hide new warnings with casts/suppressions.
7. Inspect the final diff and report what ran, what failed or was skipped, and remaining uncertainty.

Evidence is contextual: use this practical order—(1) compiler/runtime results, (2) sanitizer and test results, (3) static analysis, (4) authoritative language/platform/library documentation, (5) repository invariants, (6) reasoning. A clean run only covers executed paths and configurations.

## Risk checklist

Consider only relevant items, but actively check ownership/lifetime, nullability, allocation and cleanup, bounds and terminators, integer overflow/conversion, pointer arithmetic/provenance, initialization, aliasing/effective type/alignment, object representation/endianness, UB versus implementation-defined or unspecified behavior, error propagation, partial I/O, ABI/layout, concurrency/data races/lock order, signal safety, `volatile` versus atomics, and platform/compiler assumptions.

Avoid broad rewrites, gratuitous API or dialect changes, assuming allocation or I/O succeeds, direct assignment of `realloc`, `sizeof(pointer)` as allocation length, arbitrary sleeps, treating `volatile` as synchronization, assertions for untrusted-input errors, silent truncation, weakening tests, or claiming correctness from compilation alone.

## Deterministic tooling

Run `scripts/verify.sh --doctor` to discover capabilities, `--quick` for the repository build/test path, and `--deep` to add available analysis and sanitizer-capable builds. `--json` emits a machine-readable capability summary for `--doctor`; verification commands preserve their normal output and exit status. Use `compile-check.sh`, `sanitize.sh`, `static-analysis.sh`, or `fuzz.sh` directly for focused checks. Read [tooling](references/build-systems.md), [testing](references/testing.md), [sanitizers](references/sanitizers.md), [static analysis](references/static-analysis.md), and [fuzzing](references/fuzzing.md) before interpreting skipped checks.

## Reference map

- C semantics and UB: [language-semantics](references/language-semantics.md), [undefined-behavior](references/undefined-behavior.md), [initialization](references/initialization.md)
- Memory and data representation: [memory-ownership](references/memory-ownership.md), [pointers-aliasing-alignment](references/pointers-aliasing-alignment.md), [integer-safety](references/integer-safety.md), [buffers-and-strings](references/buffers-and-strings.md)
- Contracts and cleanup: [error-handling](references/error-handling.md), [resource-management](references/resource-management.md), [api-design](references/api-design.md)
- Environments: [POSIX](references/posix.md), [concurrency](references/concurrency.md), [portability](references/portability.md), [ABI/FFI](references/abi-and-ffi.md), [embedded](references/embedded-c.md), [systems](references/systems-c.md), [constrained platforms](references/constrained-platforms.md)
- Evidence and performance: [build systems](references/build-systems.md), [testing](references/testing.md), [fuzzing](references/fuzzing.md), [debugging](references/debugging.md), [static analysis](references/static-analysis.md), [performance](references/performance.md)
- Task recipes: [implement](workflows/implement-feature.md), [fix](workflows/fix-bug.md), [review](workflows/review-patch.md), [debug](workflows/debug-crash.md), [memory corruption](workflows/investigate-memory-corruption.md), [refactor](workflows/refactor.md), [optimize](workflows/optimize.md), [concurrency](workflows/investigate-concurrency.md), [port](workflows/port-code.md), [audit](workflows/audit-existing-code.md)
- Choose an environment profile in [`../../profiles/`](../../profiles/).
