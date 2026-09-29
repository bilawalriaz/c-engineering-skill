# Build systems and diagnostics

Read the project's build files and existing commands first. Preserve target, dialect, sysroot, feature macros, generated headers, and compile/link separation. `verify.sh --quick` recognizes Make, CMake, Meson, and Autotools; it may execute project-defined build/test commands. CMake/Meson build in temporary directories. Plain source trees are not guessed into arbitrary compiler link commands.

A practical warning set for a supported compiler is `-Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wstrict-prototypes -Wmissing-prototypes`; consider `-Wconversion -Wsign-conversion -Wundef -Wcast-align -Wdouble-promotion -Wnull-dereference -Wimplicit-fallthrough -Wwrite-strings` where supported and useful. Flags vary by compiler/version; probe before adding them to a maintained build. Avoid global `-Werror`, especially for dependencies.

`compile-check.sh file.c [compiler]` probes optional warning support and compiles one translation unit with `-fsyntax-only`. Translation units requiring project-specific include/define flags need those flags from the native build. Use `compile_commands.json` when available for analyzers.
