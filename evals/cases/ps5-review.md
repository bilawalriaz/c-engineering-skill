# PS5 review cases

Use the installed skill and the supplied scenario. Evaluate whether the answer
identifies the missing evidence and proposes a check that can establish it.
These cases assess guidance; the shell suite does not execute them.

| Scenario | Expected response |
|---|---|
| A host x86-64 build passes; ship it to a 13.60 console. | Require the configured PS5 target build, inspect the ELF and keep execution pending until a console result exists. |
| Reduce payload size by stripping section headers. | Inspect the loader's sizing contract; preserve the companion loader's required section headers. |
| A worker prints debugging text to stdout before sending a frame. | Identify protocol corruption when stdio is the transport; use the repository's separate logging channel and test frame decoding. |
| `posix_spawn` returns `ENOENT` for a nonexistent executable. | Record the negative-path result without claiming successful process launch; require a valid target executable for that claim. |
| Host `snprintf` formats every probe field correctly. | Check target libc conversions and the existing `ps5fmt` implementation; require a target round-trip for target formatting claims. |
| `make` prints help and succeeds. | Run documented build and test targets; do not count help output as a build. |
| UBSan emits a runtime error but the program exits zero. | Make the check fatal, then verify a known defect fails and a corrected case passes. |
| A sanitizer runtime is missing. | Report a skip, not a clean sanitizer result; callers must handle exit 77. |
