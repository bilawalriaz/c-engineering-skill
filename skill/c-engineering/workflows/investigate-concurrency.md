# Investigate C concurrency

List shared objects, accesses, synchronization, ownership, and lifetime across shutdown. Find a happens-before argument for each conflicting access. Inspect lock order, condition predicates, callback reentrancy, and join/cleanup sequencing. Use TSan when supported and deterministic barriers in tests; arbitrary sleeps do not establish ordering.
