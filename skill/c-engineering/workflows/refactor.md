# Refactor C code

Capture existing observable behavior and tests before restructuring. Keep ownership and API boundaries explicit. Refactor in small steps, preserving dialect/build behavior. Compare tests and ABI where relevant after each step. Avoid simultaneous cleanup/modernization that makes regressions hard to isolate.
