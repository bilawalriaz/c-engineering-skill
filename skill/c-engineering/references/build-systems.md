# Build systems and diagnostics

Read the project's build files and existing commands first. Preserve target, dialect, sysroot, feature macros, generated headers, and compile/link separation. `verify.sh --quick` recognizes Make, CMake, Meson, standalone Ninja, and Autotools; it may execute project-defined build/test commands. CMake/Meson build in temporary directories. Plain source trees are not guessed into arbitrary compiler link commands.

A practical warning set for a supported compiler is `-Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wstrict-prototypes -Wmissing-prototypes`; consider `-Wconversion -Wsign-conversion -Wundef -Wcast-align -Wdouble-promotion -Wnull-dereference -Wimplicit-fallthrough -Wwrite-strings` where supported and useful. Flags vary by compiler/version; probe before adding them to a maintained build. Avoid global `-Werror`, especially for dependencies.

`compile-check.sh file.c [compiler]` probes warning support and compiles one translation unit with `-fsyntax-only`. It intentionally does not force C11 or another dialect. If repository inspection established a standard, pass it explicitly for focused tools, for example `C_STANDARD=c99 compile-check.sh file.c`. An unsupported explicit standard is an error rather than a silent fallback. Translation units requiring project-specific include paths, generated headers, or feature macros need those flags from the native build; use `compile_commands.json` when available for analyzers.

A generated `build.ninja` is treated as an executable build plan, not as evidence of which higher-level generator produced it. Prefer the original CMake/Meson/etc. source directory when known, because that retains configuration semantics and enables safer instrumented rebuilds.
