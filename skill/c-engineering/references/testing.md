# Testing

Test the changed contract at normal input, boundary, failure, and cleanup cases. For capacities, cover zero where legal, one below, exact, one above, and arithmetic overflow. Verify return values and output state; a test that only checks no crash is weak.

Run the project's tests under its normal configuration, then use diagnostics and sanitizers for relevant code. Sanitizer coverage only includes executed code; retain regression tests for each fixed defect. Test short I/O with an injectable wrapper or controlled pipe/socket, not assumptions about regular-file behavior.

Do not weaken expected results to accommodate an implementation. Keep deterministic tests independent of arbitrary sleeps and resource scheduling.
