# Fix a C bug

Reproduce and capture the exact failing input/configuration. Find the first invalid state, not just the final crash. State the violated invariant, add a regression test that fails before the fix, patch narrowly, then exercise adjacent boundaries and cleanup paths under relevant instrumentation. Preserve the API unless the contract itself is defective.
