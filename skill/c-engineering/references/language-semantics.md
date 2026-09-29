# C language semantics

C source is interpreted under a selected language edition, implementation, and set of extensions. Know whether the project targets C89/C90, C99, C11, C17, or C23; do not assume the newest edition. First inspect `-std`, compiler, target, feature macros, and project headers; C90, C99, C11, C17, and C23 differ. Do not change dialect to make a local implementation easier unless the contract calls for it.

Distinguish three categories:

- **Undefined behavior (UB):** the C standard imposes no requirements; do not predict a crash or a particular result. Examples include signed overflow and many out-of-bounds accesses.
- **Implementation-defined behavior:** the implementation documents its choice, such as whether plain `char` is signed.
- **Unspecified behavior:** one of multiple permitted outcomes occurs, and the implementation need not document which one.

A compiler extension is a separate contract. Document and isolate it when required. Inspect preprocessor output or compiler docs when conditional compilation changes behavior. `volatile` affects observable accesses as defined by the implementation/language; it does not make operations atomic or establish inter-thread happens-before.

For standards-facing claims consult the selected C edition. WG14 N1570 is a public C11 committee draft, not a substitute for the adopted standard or compiler documentation.
