# Static analysis

Use available analyzers as additional evidence: `clang --analyze`, `scan-build`, `clang-tidy` when a compilation database exists, and `cppcheck`. Preserve compilation flags and macros; analysis without them can produce noise or miss conditional code. The scripts report missing tools as skipped. `static-analysis.sh file.c` can run Clang analysis on a standalone translation unit; project flags and local includes require the native build or a compilation database.

Review each finding against source, contracts, and platform behavior. Fix valid issues and record justified suppressions narrowly with rationale. A clean analyzer run does not prove correctness, and third-party warnings should not be “fixed” by broad suppression or unrelated rewrites.
