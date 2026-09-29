# API contracts

Make ownership, lifetime, nullability, units, capacities, and error behavior visible in declarations and docs. Prefer `(pointer, length)` pairs for byte spans and distinguish input from output. Document whether callbacks may retain pointers or reenter the API.

Avoid ambiguous integer sentinels when a status return plus output parameter is clearer. Define output state on failure and whether operations are atomic or may partially modify data. Keep ABI-sensitive public structures extensible where possible; opaque handles reduce layout commitments.

Do not change a public contract casually. If compatibility matters, inspect symbol visibility, versioning, calling convention, struct layout, and downstream users before changing signatures.
