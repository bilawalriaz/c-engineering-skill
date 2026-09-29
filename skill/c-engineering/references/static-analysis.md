# Static analysis

Use available analyzers as additional evidence: `clang --analyze`, `scan-build`, `clang-tidy` when a compilation database exists, and `cppcheck`. Preserve compilation flags, target, feature macros, include paths, and generated headers; analysis without them can produce noise or miss conditional code.

The scripts report missing tools as skipped. `static-analysis.sh file.c` can run Clang analysis on one standalone translation unit. It preserves the compiler default dialect unless `C_STANDARD` is explicitly set; project flags and local includes still require the native build or a compilation database. When `compile_commands.json` is available, prefer it because it carries the actual per-translation-unit command line.

`scan-build` is useful when it can wrap a real clean build, but forcing a clean/rebuild is project-specific and may be destructive or expensive, so the generic verifier does not invent that step.

Review each finding against source, contracts, and platform behavior. Fix valid issues and record justified suppressions narrowly with rationale. A clean analyzer run does not prove correctness, and third-party warnings should not be "fixed" by broad suppression or unrelated rewrites.
