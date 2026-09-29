# C defect evaluations

`cases/defect-matrix.md` maps defect specimens to checks that can detect them.
These are regression examples; they do not measure model quality.

Run `evals/run-evals.sh` from the repository root. It compiles fixed examples with
available GCC/Clang commands, checks an ASan heap-overflow finding and runs a
bounded libFuzzer check when supported. Corpus mutations stay in a temporary
directory. `tests/test-scripts.sh` runs parser boundary tests and checks analyzer
failure status, fatal UBSan findings, sanitizer skips and the fuzz helper.

The [PS5 review cases](cases/ps5-review.md) are manual behavioral evaluations.
They require no console access and must not be reported as hardware tests.
