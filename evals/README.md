# C defect evaluations

These are small teaching and regression specimens, not a benchmark claiming to measure model quality. `cases/defect-matrix.md` maps each requested defect to a bad specimen, a correction, and the evidence likely to find it. Detection depends on compiler, target, executed path, and analyzer configuration.

Run `./run-evals.sh` from the repository root. The suite verifies that fixed examples compile with GCC/Clang when present, runs the fixed byte-span parser on boundary inputs, and confirms a deliberately overflowing program is diagnosed by an available ASan/UBSan runtime when the runtime works on the host. If the host cannot run sanitizers, it reports that part as skipped. Intentionally buggy sources are never included in ordinary builds.
