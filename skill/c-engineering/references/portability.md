# Portability

Record target OS, architecture, ABI, libc, compiler/version, C dialect, feature macros, and required extensions. Separate portable C from POSIX, OS, compiler, and hardware code behind narrow interfaces.

Use fixed-width integer types for external formats only with availability and range checks. Do not assume endianness, `char` signedness, pointer width, integer widths, struct packing, path limits, or filesystem behavior. Probe build features at configure time rather than guessing from compiler names. Test the supported compiler/platform matrix and include cross-compilation constraints.

Treat compiler diagnostics and extension docs as implementation evidence; they do not make an extension portable. Preserve user-specified standard and target flags.
