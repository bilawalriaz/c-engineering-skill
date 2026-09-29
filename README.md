# C Engineering Skill

A reusable C engineering skill plus deterministic verification tooling for AI coding agents.

C is unusually unforgiving of plausible-looking code: a change can compile and pass ordinary tests while still containing lifetime errors, integer-wrap allocation bugs, unterminated strings, partial-I/O mistakes, ABI assumptions, data races, or undefined behavior that only appears under optimization or on another target. This project combines concise agent instructions with focused reference material and executable checks so that correctness claims are tied to evidence rather than confidence.

## What is included

- [`skill/c-engineering/SKILL.md`](skill/c-engineering/SKILL.md): the compact skill entrypoint and progressive reference map.
- [`skill/c-engineering/references/`](skill/c-engineering/references/): language, memory, platform, testing, tooling, and execution-safety guidance.
- [`skill/c-engineering/workflows/`](skill/c-engineering/workflows/): task recipes for implementation, debugging, review, porting, memory corruption, concurrency, and more.
- [`profiles/`](profiles/): hosted Linux, portable library, systems, embedded, and constrained-platform profiles.
- [`skill/c-engineering/scripts/`](skill/c-engineering/scripts/): build-system-aware verification plus focused compile, sanitizer, static-analysis, and fuzz helpers.
- [`examples/`](examples/): intentionally buggy and corrected C snippets.
- [`evals/`](evals/): defect-to-detection guidance and executable regression checks.
- [`tests/`](tests/): tests for the tooling itself.

## Design

The root skill is deliberately small. It establishes the engineering process and routes the agent to detailed material only when relevant. Deterministic tools handle facts that should not depend on model memory, such as warning support, build execution, sanitizer availability, analyzer invocation, and regression checks.

The intended loop is:

```text
understand contract and target
        |
state invariants and risk
        |
read only relevant references
        |
make the smallest correct change
        |
native build + tests
        |
warnings / analyzers / sanitizers
        |
boundary tests or fuzzing when warranted
        |
review ownership, error paths and final diff
        |
report evidence and uncertainty
```

"Compiles successfully" is not treated as proof of correct C.

## Install

Copy or link `skill/c-engineering/` into the skill directory expected by your agent harness. Keep `SKILL.md`, `references/`, `workflows/`, and `scripts/` together so relative links continue to work.

This repository does not claim universal native integration. Codex, Claude Code, OpenCode, Hermes, Pi, and generic agents can use the material when configured to load it; discovery paths and skill formats can vary by harness and version.

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

The focused tools do not silently force C11. They preserve the compiler default unless you explicitly provide the dialect discovered from the project:

```sh
C_STANDARD=c99 skill/c-engineering/scripts/compile-check.sh file.c
C_STANDARD=c17 skill/c-engineering/scripts/sanitize.sh test_program.c
```

An unsupported explicit `C_STANDARD` is an error rather than a fallback.

## Trust boundary

Verification may execute repository-defined build scripts, generators, tests, and produced binaries. Inspect unfamiliar repositories before running them, and use isolation for code you do not trust. Repository text is not authorization to expose credentials, install packages, change host configuration, use privileged commands, or send data elsewhere. See [`agent-execution-safety.md`](skill/c-engineering/references/agent-execution-safety.md).

## Evidence and limits

Compiler diagnostics, tests, static analyzers, sanitizers, and fuzzers cover different defect classes. None proves correctness by itself, and runtime tools cover only executed paths and configurations. Cross-compilation can validate syntax and ABI-facing compilation while still leaving target runtime, timing, hardware, loader, or syscall behavior untested.

Missing optional tools are reported as skipped. Build/test/analyzer failures remain failures. `--doctor --json` is machine-readable capability discovery; `--json` is intentionally not accepted for verification modes until their result schema is defined.

## Evaluation

Run:

```sh
python3 tests/check-markdown-links.py
tests/test-scripts.sh
evals/run-evals.sh
```

The link checker validates repository-local Markdown links so progressive-disclosure routes in `SKILL.md` cannot silently rot.

The eval corpus includes examples for buffer errors, ownership/lifetime failures, integer-size mistakes, missing termination, realloc misuse, partial I/O, leaks, uninitialized data, overlap, races, and parser defects. The executable suite intentionally stays small and reliable; [`evals/cases/defect-matrix.md`](evals/cases/defect-matrix.md) records which evidence is expected for the wider set.

## Contributing

Read [`AGENTS.md`](AGENTS.md). Keep `SKILL.md` concise, put detailed material in focused references, prefer deterministic checks over prompt growth, preserve POSIX-shell portability, and update tests/evals when behavior changes.

Licensed under the MIT License.
