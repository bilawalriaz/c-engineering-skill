# Memory ownership and lifetime

For each dynamically lived object, identify: allocation site, unique owner (or shared ownership rule), borrowers, transfer point, valid lifetime, nullability, cleanup site, and cleanup after every partial failure. Naming is not an ownership contract.

Borrowed pointers must not outlive the owner or be retained unless the API says so. A successful ownership transfer ends the sender's obligation; define whether the receiver may fail and who cleans up then. Initialize handles to a safe sentinel and make cleanup safe for each initialization state.

Unsafe realloc assignment loses the only reference if growth fails:

```c
p = realloc(p, bytes); /* failure returns NULL; original block remains allocated */
```

Use a temporary and leave the original pointer untouched on failure:

```c
void *next = realloc(p, bytes);
if (next == NULL) return -1;
p = next;
```

The meaning of `realloc(p, 0)` has varied across C editions and implementations (C23 makes this case undefined). Avoid it. If zero means release, call `free(p)` explicitly and set `p = NULL`; otherwise ensure the requested nonzero size is valid. Check multiplication before `malloc(count * size)` (for example `count != 0 && size > SIZE_MAX / count`).

Prefer a single cleanup section with state initialized to safe sentinels when multiple resources need ordered release. `goto cleanup` is often clearer than duplicated cleanup, but cleanup must match successfully acquired resources and preserve the original error.
