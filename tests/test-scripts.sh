#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
scripts=$root/skill/c-engineering/scripts
tmp=$(mktemp -d "${TMPDIR:-/tmp}/c-script-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

for script in "$scripts"/*.sh "$root"/evals/*.sh "$root"/tests/*.sh; do sh -n "$script"; done

[ "$("$scripts/detect-project.sh" "$root/examples/sample-project")" = cmake ]

"$scripts/verify.sh" --doctor --json | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["project"] == "unknown"; assert "tools" in d; assert "ninja" in d["tools"]; assert "ctest" in d["tools"]'

if "$scripts/verify.sh" --quick --json >/dev/null 2>&1; then
    printf 'expected --json outside --doctor to fail\n' >&2
    exit 1
fi

cat > "$tmp/standard.c" <<'C'
int answer(void)
{
    return 42;
}
C
"$scripts/compile-check.sh" "$tmp/standard.c" "${CC:-gcc}"
env C_STANDARD=c99 "$scripts/compile-check.sh" "$tmp/standard.c" "${CC:-gcc}"
if env C_STANDARD=not-a-real-c-standard "$scripts/compile-check.sh" "$tmp/standard.c" "${CC:-gcc}" >/dev/null 2>&1; then
    printf 'expected unsupported explicit C standard to fail\n' >&2
    exit 1
fi

gcc -std=c11 -Wall -Wextra -Wpedantic "$root/tests/test-parser.c" -o "$tmp/test-parser"
"$tmp/test-parser"
rm -f "$tmp/test-parser"

if command -v clang >/dev/null 2>&1; then "$scripts/compile-check.sh" "$root/examples/fixed/bounds.c" clang; fi
if command -v gcc >/dev/null 2>&1; then "$scripts/compile-check.sh" "$root/examples/fixed/bounds.c" gcc; fi

(cd "$root/examples/sample-project" && "$scripts/verify.sh" --quick)

mkdir "$tmp/make-project"
cat > "$tmp/make-project/Makefile" <<'MAKE'
.PHONY: all test
all:
	@true
test:
	@true
MAKE
[ "$("$scripts/detect-project.sh" "$tmp/make-project")" = make ]
(cd "$tmp/make-project" && "$scripts/verify.sh" --quick)

cat > "$tmp/make-project/Makefile" <<'MAKE'
all:
	@false
MAKE
if (cd "$tmp/make-project" && "$scripts/verify.sh" --quick >/dev/null 2>&1); then
    printf 'expected failing build to fail verification\n' >&2
    exit 1
fi

if command -v ninja >/dev/null 2>&1; then
    mkdir "$tmp/ninja-project"
    cat > "$tmp/ninja-project/main.c" <<'C'
int main(void)
{
    return 0;
}
C
    cat > "$tmp/ninja-project/build.ninja" <<'NINJA'
rule cc
  command = cc -c $in -o $out
build main.o: cc main.c
default main.o
NINJA
    [ "$("$scripts/detect-project.sh" "$tmp/ninja-project")" = ninja ]
    (cd "$tmp/ninja-project" && "$scripts/verify.sh" --quick)
fi

compiler=$(command -v "${CC:-}" 2>/dev/null || command -v clang || command -v gcc || true)
if [ -n "$compiler" ] && printf 'int main(void){return 0;}\n' | "$compiler" -x c -fsanitize=address -o "$tmp/probe" - >/dev/null 2>&1; then
    if CC="$compiler" "$scripts/sanitize.sh" "$root/examples/buggy/heap_overflow.c" address,undefined >"$tmp/san.out" 2>&1; then
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
