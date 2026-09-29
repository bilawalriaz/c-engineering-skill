# Fuzzing

Fuzz when input space is large and malformed input is expected: parsers, protocol/state machines, decoders, archive readers, serialization, and size arithmetic. Fuzz a narrow deterministic function; bound input size, work, memory, and time. Targets must tolerate empty and malformed input and must not call `exit`; reset state and join spawned threads per input.

A minimal libFuzzer target is in `examples/fixed/fuzz_bytes.c`; build with a matching Clang using `clang -g -O1 -fsanitize=fuzzer,address,undefined target.c parser.c`. Seed a corpus with valid and near-valid inputs, preserve crashing inputs as regression tests, and minimize before fixing. AFL++ uses compiler wrappers or LLVM instrumentation and a separate executable/input protocol; follow its current docs. Do not run unbounded fuzzing as a routine quick check.
