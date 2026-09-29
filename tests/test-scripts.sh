#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
scripts=$root/skill/c-engineering/scripts
tmp=$(mktemp -d "${TMPDIR:-/tmp}/c-script-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
for script in "$scripts"/*.sh "$root"/evals/*.sh "$root"/tests/*.sh; do sh -n "$script"; done
[ "$("$scripts/detect-project.sh" "$root/examples/sample-project")" = cmake ]
"$scripts/verify.sh" --doctor --json | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["project"] == "unknown"; assert "tools" in d'
"$scripts/compile-check.sh" "$root/examples/fixed/bounds.c" gcc
gcc -std=c11 -Wall -Wextra -Wpedantic "$root/tests/test-parser.c" -o "$tmp/test-parser"
"$tmp/test-parser"
rm -f "$tmp/test-parser"
if command -v clang >/dev/null 2>&1; then "$scripts/compile-check.sh" "$root/examples/fixed/bounds.c" clang; fi
(cd "$root/examples/sample-project" && "$scripts/verify.sh" --quick)
# A Makefile project is detected and its build/test targets are run.
cat > "$tmp/Makefile" <<'MAKE'
.PHONY: all test
all:
	@true
test:
	@true
MAKE
(cd "$tmp" && "$scripts/verify.sh" --quick)
# Build failures remain failures.
cat > "$tmp/Makefile" <<'MAKE'
all:
	@false
MAKE
if (cd "$tmp" && "$scripts/verify.sh" --quick >/dev/null 2>&1); then
    printf 'expected failing build to fail verification\n' >&2
    exit 1
fi
# A real sanitizer finding must remain a failure; unavailable runtimes are a skip.
compiler=$(command -v clang || command -v gcc || true)
if [ -n "$compiler" ] && printf 'int main(void){return 0;}\n' | "$compiler" -x c -fsanitize=address -o "$tmp/probe" - >/dev/null 2>&1; then
    if "$scripts/sanitize.sh" "$root/examples/buggy/heap_overflow.c" address,undefined >"$tmp/san.out" 2>&1; then
        printf 'sanitizer failed to detect known heap overflow\n' >&2
        exit 1
    fi
    grep -E 'AddressSanitizer|heap-buffer-overflow|ERROR: AddressSanitizer' "$tmp/san.out" >/dev/null || {
        printf 'sanitizer command failed without expected finding\n' >&2
        cat "$tmp/san.out" >&2
        exit 1
    }
else
    printf 'SKIP sanitizer runtime unavailable\n'
fi
printf 'script tests passed\n'
