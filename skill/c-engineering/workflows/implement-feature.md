# Implement a C feature

1. Inspect API, callers, build, dialect, tests, and ownership conventions.
2. Define input ranges, units, output state, ownership transfers, and errors.
3. Identify memory, integer, ABI, or concurrency risk and open the matching references.
4. Implement the smallest change; make cleanup correct for every partial state.
5. Add success, boundary, malformed-input, and failure tests. Run native verification, then applicable analyzer/sanitizers/fuzzing.
6. Review the diff and report executed evidence and skipped checks.
