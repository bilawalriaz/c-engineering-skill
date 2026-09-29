# Resource management

Treat heap blocks, file descriptors, `FILE *`, sockets, mappings, locks, threads, and platform handles as owned resources with an acquisition and release point. Document whether each close operation consumes the handle on failure; platform APIs differ.

Use a cleanup path when it reduces duplicated release logic. Initialize resources to documented invalid sentinels, acquire in order, release in reverse order, and clear a handle after successful release if later cleanup can revisit it. A cleanup label must not obscure which acquisitions succeeded.

For descriptors, account for `close` errors when durability matters, `FD_CLOEXEC` at creation where available, and fork/exec inheritance. Avoid retrying `close` blindly after an error: descriptor state and portability semantics vary. Prefer atomic creation flags such as `O_CLOEXEC` when supported, with a deliberate fallback only when needed.
