# ABI and FFI

An ABI includes calling convention, symbol naming/visibility, data layout, alignment, register use, and unwind/runtime conventions. It is platform/toolchain specific. Do not infer it from C syntax alone.

For FFI, define fixed-width values, ownership, lifetime, nullability, string encoding/termination, error translation, and callback/threading rules. Avoid passing C bit-fields, flexible arrays, packed structs, or compiler-dependent enums as stable wire/FFI layouts unless both sides share a documented ABI. Version public layouts or use opaque handles and accessor functions.

Verify with authoritative compiler/platform docs and a small cross-language round-trip test. `sizeof`/`offsetof` assertions can detect layout drift but only validate the configured target.
