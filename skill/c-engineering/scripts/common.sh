#!/bin/sh
# Shared POSIX shell helpers. Callers may use these without changing the caller's cwd.
ce_have() { command -v "$1" >/dev/null 2>&1; }
ce_note() { printf '%s\n' "$*" >&2; }
ce_die() { ce_note "error: $*"; exit 2; }
ce_tmpdir() {
    mktemp -d "${TMPDIR:-/tmp}/c-engineering.XXXXXX"
}
ce_compiler() {
    if [ -n "${CC:-}" ] && ce_have "$CC"; then printf '%s\n' "$CC"
    elif ce_have clang; then printf '%s\n' clang
    elif ce_have gcc; then printf '%s\n' gcc
    elif ce_have cc; then printf '%s\n' cc
    else return 1; fi
}
