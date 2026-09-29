# Performance

Establish a representative workload and baseline before optimizing. Measure release-like builds on the target and record compiler, flags, CPU, inputs, and variance. Profile before changing data structures or adding caches.

Optimization can expose UB-dependent behavior or invalidate timing assumptions. Re-run correctness tests and sanitizers after changes. Check integer widths, alignment, cache behavior, allocation, I/O, and lock contention with target-specific evidence. Do not trade public API clarity or error handling for an unmeasured gain.
