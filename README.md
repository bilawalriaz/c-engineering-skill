# C Engineering Skill

A compact, reusable C engineering skill plus shell tooling that makes AI coding agents verify the assumptions C code depends on: object lifetime, bounds, integer arithmetic, error paths, ABI, concurrency, and platform behavior.

C gives code direct access to memory and platform interfaces. A generated change can compile while still overflowing a size calculation, mishandling a partial read, leaking a resource on an early return, or relying on an ABI accident. This project combines explicit reasoning prompts with reproducible checks; neither one substitutes for the other.

## Contents

- [`skill/c-engineering/SKILL.md`](skill/c-engineering/SKILL.md): concise workflow and progressive reference map.
- `references/`: focused language, memory, platform, testing, and tooling guidance.
- `workflows/`: short task recipes for implementation, debugging, review, porting, and more.
- [`profiles/`](profiles/): hosted Linux, portable library, systems, embedded, and constrained platform choices.
- [`examples/`](examples/): buggy and corrected C snippets.
- [`evals/`](evals/): defect-to-detection guide and a small executable regression suite.
- [`scripts/`](skill/c-engineering/scripts/): build-system-aware verification and focused checks.

## Install

Copy or link `skill/c-engineering/` into the skill directory expected by your agent harness. Keep the neighboring `references/`, `workflows/`, and `scripts/` directories with `SKILL.md` so its links work. For a repository-specific agent, point its instructions at `skill/c-engineering/SKILL.md` or copy the skill into that harness's documented skill location.

This is content and tooling, not a claim of built-in integration. Codex, Claude Code, OpenCode, Hermes, Pi, and generic agents can use it when configured to load the skill; exact discovery and installation paths depend on each harness and version.

## Use

From a C repository:

```sh
/path/to/c-engineering/scripts/verify.sh --doctor
/path/to/c-engineering/scripts/verify.sh --quick
/path/to/c-engineering/scripts/verify.sh --deep
```

Or run tools directly:

```sh
skill/c-engineering/scripts/compile-check.sh examples/fixed/bounds.c
skill/c-engineering/scripts/sanitize.sh examples/buggy/heap_overflow.c # expected nonzero finding
skill/c-engineering/scripts/static-analysis.sh .
```

`--quick` builds and tests recognized Make, CMake, Meson, or Autotools projects. CMake and Meson use a temporary out-of-tree build. `--deep` also runs available static analysis and, for CMake/Meson, an instrumented build/test where supported. For Make and Autotools, it does not inject flags or clean the working tree; use the focused sanitizer script on a test translation unit or the build system's documented sanitizer configuration. Unknown/plain compiler projects are reported rather than guessed into a potentially incorrect link command. Nonzero build/test/analyzer findings remain failures.

`--doctor --json` writes JSON to stdout. Optional tools are reported as available or skipped; missing tools do not masquerade as completed analysis. Verification may execute repository-defined build and test commands, so review those project files before running it on untrusted repositories.

## Evidence and limits

The workflow is intentionally scoped: compiler warnings, static analyzers, and sanitizers each cover different classes and only the code paths and configurations executed. ThreadSanitizer, AddressSanitizer, and UndefinedBehaviorSanitizer availability depends on compiler runtime and host. Static analyzers can report false positives or miss defects. Fuzzing needs a target and useful seed corpus; it is not a universal test. See [testing](skill/c-engineering/references/testing.md), [tooling references](skill/c-engineering/references/build-systems.md), and [evaluations](evals/README.md).

## Contribute

Read [`AGENTS.md`](AGENTS.md). Keep the root skill short, add precise detail to a focused reference, test shell changes with `tests/test-scripts.sh`, and update eval guidance when a major rule or script behavior changes. The project uses the MIT license.
