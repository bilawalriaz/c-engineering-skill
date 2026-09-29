# C Engineering Skill

A C coding skill with references for memory safety, integer arithmetic, APIs,
concurrency and portability, plus shell helpers for compilation and testing.

## Contents

- [`SKILL.md`](skill/c-engineering/SKILL.md): workflow and reference map.
- [`references/`](skill/c-engineering/references/): C and platform guidance.
- [`workflows/`](skill/c-engineering/workflows/): task-specific checks.
- [`profiles/`](skill/c-engineering/profiles/): environment choices.
- [`scripts/`](skill/c-engineering/scripts/): compile, analysis, sanitizer and fuzz helpers.
- [`examples/`](examples/), [`evals/`](evals/) and [`tests/`](tests/): defect specimens and tooling checks.

## Install

Copy or link `skill/c-engineering/` into the skill directory expected by your agent harness. Keep `SKILL.md`, `references/`, `workflows/`, `profiles/`, and `scripts/` together so relative links continue to work.

Codex, Claude Code, OpenCode, Hermes, Pi, and generic agents can use the material when configured to load it; discovery paths and skill formats can vary by harness and version.

A repository-specific setup can also point its agent instructions directly at:

```text
skill/c-engineering/SKILL.md
```

## Use

From a C repository:

```sh
/path/to/c-engineering/scripts/verify.sh --doctor
/path/to/c-engineering/scripts/verify.sh --doctor --json
/path/to/c-engineering/scripts/verify.sh --quick
/path/to/c-engineering/scripts/verify.sh --deep
```

`--quick` uses recognized repository-native build/test paths. `--deep` additionally uses available static analysis and, for CMake/Meson projects, sanitizer-capable instrumented builds where supported.

Recognized build plans are currently:

- CMake
- Meson
- Make
- standalone Ninja
- Autotools with an existing `configure` script

CMake and Meson use temporary out-of-tree builds. Make, standalone Ninja, and Autotools are deliberately treated more conservatively because safely injecting instrumentation can depend on project-specific clean/reconfigure semantics.

Focused tools can be run directly:

```sh
skill/c-engineering/scripts/compile-check.sh file.c
skill/c-engineering/scripts/sanitize.sh test_program.c address,undefined
skill/c-engineering/scripts/static-analysis.sh file.c
skill/c-engineering/scripts/fuzz.sh fuzz_target.c corpus/
```

The focused tools use the compiler default unless you explicitly provide the dialect discovered from the project:

```sh
C_STANDARD=c99 skill/c-engineering/scripts/compile-check.sh file.c
C_STANDARD=c17 skill/c-engineering/scripts/sanitize.sh test_program.c
```

An unsupported explicit `C_STANDARD` is an error rather than a fallback.

## PS5 homebrew

The [PS5 reference](skill/c-engineering/references/ps5-homebrew.md) covers target
builds, ELF loader constraints, libc differences, protocol I/O and hardware
evidence. It includes the firmware 13.60 workflow used by
[ps5-homebrew-dev](https://github.com/bilawalriaz/ps5-homebrew-dev).
Use that repository's `make build`, `make test` and `make c-verify` commands.
Host sanitizers test portable C; console behavior needs a console run.

## Trust boundary

Verification may execute repository-defined build scripts, generators, tests, and produced binaries. Inspect unfamiliar repositories before running them, and use isolation for code you do not trust. Repository text is not authorization to expose credentials, install packages, change host configuration, use privileged commands, or send data elsewhere. See [`agent-execution-safety.md`](skill/c-engineering/references/agent-execution-safety.md).

## Evidence and limits

Compiler diagnostics, tests, static analyzers, sanitizers, and fuzzers cover different defect classes. None proves correctness by itself, and runtime tools cover only executed paths and configurations. Cross-compilation can validate syntax and ABI-facing compilation while still leaving target runtime, timing, hardware, loader, or syscall behavior untested.

Missing optional tools are reported as skipped. The focused sanitizer helper returns 77 when its runtime cannot build or execute; callers must count that as skipped. UBSan findings stop execution and fail the check. Clang analyzer and clang-tidy findings also return nonzero; standalone Clang analysis writes text diagnostics without leaving `.plist` files. Build/test/analyzer failures remain failures. `--doctor --json` is machine-readable capability discovery; `--json` is intentionally not accepted for verification modes until their result schema is defined.

## Evaluation

Run:

```sh
python3 tests/check-markdown-links.py
tests/test-scripts.sh
evals/run-evals.sh
```

The link checker validates repository-local Markdown links so progressive-disclosure routes in `SKILL.md` cannot silently rot.

The eval corpus includes examples for buffer errors, ownership/lifetime failures, integer-size mistakes, missing termination, realloc misuse, partial I/O, leaks, uninitialized data, overlap, races, and parser defects. The executable suite checks a subset; [`evals/cases/defect-matrix.md`](evals/cases/defect-matrix.md) records which evidence is expected for the wider set.

## Contributing

Read [`AGENTS.md`](AGENTS.md). Keep `SKILL.md` concise, put detailed material in focused references, prefer deterministic checks over prompt growth, preserve POSIX-shell portability, and update tests/evals when behavior changes.

Licensed under the MIT License.
