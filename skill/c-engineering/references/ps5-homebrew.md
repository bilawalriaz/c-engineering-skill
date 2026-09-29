# PS5 homebrew in C

Use the consuming repository's firmware, SDK, loader and test records. Keep the
exploit, loader, SDK, kernel patches and HEN versions separate. A header or offset
table establishes source support; execution needs a result from that console.

## Establish the target

Identify whether the artifact is an ELF payload, a plugin or a native title.
They can have different startup, imports, packaging and process lifetimes. Read
the pinned SDK headers, compiler wrapper, linker rules and a working example
before calling an unfamiliar API. Preserve target flags, sysroot, startup objects,
TLS configuration and library order. A host x86-64 build does not establish PS5
ABI compatibility, and Linux interfaces need an explicit port.

For the [ps5-homebrew-dev companion repository](https://github.com/bilawalriaz/ps5-homebrew-dev),
start with its `AGENTS.md`, `docs/STATUS.md`, `deps.lock`,
`payloads/common/payload.mk` and `vendor/VENDORED.md`. Use its documented commands:

```sh
make build          # cross-build payloads with the pinned SDK
make test           # host tests, including the mock worker
make c-verify       # host checks on portable C
make context-check
make check-secrets
```

The generic `verify.sh --quick` invokes the default Make target, which may only
print help. Generic CMake/Meson builds do not infer toolchain files, presets or
cross files; use the project's configured build for those targets. Run host
sanitizers and fuzzers on portable code with a host compiler. Target-aware static
analysis can inspect SDK code when supplied with the actual target flags and
headers, but cannot establish runtime behavior.

## Review the console boundary

- Preserve the loader's ELF contract, including section headers when the loader
  uses them to size a transfer. Inspect the final artifact after packaging; a
  successful link is insufficient. Do not strip payloads in the companion repo.
- Inspect SDK declarations and symbol resolution separately. In the companion
  build, naming a kernel library changes the wrapper's default link set; retain
  its explicit `-lkernel_sys -lkernel_web` choices.
- Check the target libc's formatting behavior with a small target test. Keep the
  companion's `ps5fmt` helpers where its libc cannot handle required conversions.
  Match variadic argument types even if the host formatter accepts the output.
- Establish whether stdio carries a framed protocol. Keep diagnostics out of that
  stream, bound frame lengths before allocation, and handle short reads/writes,
  interruption, EOF, deadlines and peer disconnects. Test split headers, truncated
  bodies, oversized lengths and shutdown during a transfer on the host.
- Query or verify page size and mapping alignment from the SDK/runtime. Check
  `MAP_FAILED`, offset and size arithmetic, protection flags and cleanup. A mapping
  that succeeds without touching its pages does not establish usable capacity.
- Check CPU features and OS register-state support before enabling SIMD paths.
  Measure performance on the target; an instruction-set match or reported clock
  speed does not establish throughput.
- Make probes distinguish expected errors from unsupported behavior. For example,
  `posix_spawn` returning `ENOENT` for a missing file tests an error path; it does
  not prove a valid executable can start. Test success and negative controls.

These checks reflect defects and constraints recorded in the companion's
[hardware log](https://github.com/bilawalriaz/ps5-homebrew-dev/blob/910de38e0cdb3801755ae25aedb94008e4a32e42/docs/HARDWARE_TEST_LOG.md),
[loader notes](https://github.com/bilawalriaz/ps5-homebrew-dev/blob/910de38e0cdb3801755ae25aedb94008e4a32e42/docs/EXPLOIT_AND_LOADER.md)
and [build rules](https://github.com/bilawalriaz/ps5-homebrew-dev/blob/910de38e0cdb3801755ae25aedb94008e4a32e42/payloads/common/payload.mk),
reviewed on 2026-09-29. Recheck the consuming repo's current records before using
a result for another firmware or launch context.

## Report what was established

Keep host tests, cross-builds and console runs separate. For a console run record
firmware, console model, component revisions, artifact hash, command, expected and
observed results, log excerpt and recovery steps. A completed upload alone proves
transport, not execution. Mark hardware validation pending when it did not run.
