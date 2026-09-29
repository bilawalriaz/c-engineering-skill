#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
scripts=$root/skill/c-engineering/scripts
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$scripts/common.sh"
compiler=$(ce_compiler) || ce_die 'no C compiler found'
tmp=$(mktemp -d "${TMPDIR:-/tmp}/c-script-test.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

for script in "$scripts"/*.sh "$root"/evals/*.sh "$root"/tests/*.sh; do sh -n "$script"; done

[ "$("$scripts/detect-project.sh" "$root/examples/sample-project")" = cmake ]

(cd "$root" && "$scripts/verify.sh" --doctor --json) | python3 -c 'import json,sys; d=json.load(sys.stdin); assert d["project"] == "unknown"; assert "tools" in d; assert "ninja" in d["tools"]; assert "ctest" in d["tools"]'

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
"$scripts/compile-check.sh" "$tmp/standard.c" "$compiler"
env C_STANDARD=c99 "$scripts/compile-check.sh" "$tmp/standard.c" "$compiler"
if env C_STANDARD=not-a-real-c-standard "$scripts/compile-check.sh" "$tmp/standard.c" "$compiler" >/dev/null 2>&1; then
    printf 'expected unsupported explicit C standard to fail\n' >&2
    exit 1
fi

"$compiler" -std=c11 -Wall -Wextra -Wpedantic "$root/tests/test-parser.c" -o "$tmp/test-parser"
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

if [ -n "$compiler" ] && printf 'int main(void){return 0;}\n' | "$compiler" -x c -fsanitize=address,undefined -o "$tmp/probe" - >/dev/null 2>&1 && "$tmp/probe" >/dev/null 2>&1; then
    if CC="$compiler" "$scripts/sanitize.sh" "$root/examples/buggy/heap_overflow.c" address,undefined >"$tmp/san.out" 2>&1; then
        printf 'sanitizer failed to detect known heap overflow\n' >&2
        exit 1
    fi
    grep -E 'AddressSanitizer|heap-buffer-overflow|runtime error:.*insufficient space' "$tmp/san.out" >/dev/null || {
        printf 'sanitizer command failed without expected finding\n' >&2
        cat "$tmp/san.out" >&2
        exit 1
    }
else
    printf 'SKIP sanitizer runtime unavailable\n'
fi

# UBSan must fail even when the test returns zero after the invalid operation.
cat > "$tmp/overflow.c" <<'C'
#include <limits.h>
int main(void) { volatile int n = INT_MAX; volatile int result = n + 1; (void)result; return 0; }
C
san_status=0
CC="$compiler" "$scripts/sanitize.sh" "$tmp/overflow.c" undefined >"$tmp/ub.log" 2>&1 || san_status=$?
case $san_status in
    0) ce_die 'UBSan finding returned success' ;;
    77) ce_note 'SKIP UBSan runtime unavailable' ;;
    *) grep 'runtime error:.*overflow' "$tmp/ub.log" >/dev/null || { cat "$tmp/ub.log" >&2; exit 1; } ;;
esac

# A missing explicit compiler must never fall back to another compiler.
if CC="$tmp/missing-compiler" "$scripts/sanitize.sh" "$tmp/overflow.c" >"$tmp/missing.log" 2>&1; then
    ce_die 'missing CC silently fell back'
fi
grep -E 'no C compiler found|compiler not found' "$tmp/missing.log" >/dev/null

# Simulate a compiler without sanitizer support; wrappers need a distinct skip.
cat > "$tmp/no-sanitizer" <<'SH'
#!/bin/sh
exit 1
SH
chmod +x "$tmp/no-sanitizer"
san_status=0
CC="$tmp/no-sanitizer" C_STANDARD='' "$scripts/sanitize.sh" "$tmp/overflow.c" >"$tmp/skip.log" 2>&1 || san_status=$?
[ "$san_status" -eq 77 ] || ce_die 'unavailable sanitizer must return 77'
grep 'skip:' "$tmp/skip.log" >/dev/null

if command -v clang >/dev/null 2>&1; then
    # Analyze from a temporary cwd and ensure no report files leak into it.
    if (cd "$tmp" && "$scripts/static-analysis.sh" "$root/examples/buggy/leak.c") >"$tmp/analyzer.log" 2>&1; then
        ce_die 'known analyzer finding returned success'
    fi
    grep -i 'leak' "$tmp/analyzer.log" >/dev/null
    (cd "$tmp" && "$scripts/static-analysis.sh" "$root/examples/fixed/leak.c")
    for report in "$tmp"/*.plist; do
        [ ! -e "$report" ] || ce_die 'analyzer left a report in the working directory'
    done
    if printf '#include <stddef.h>\nint LLVMFuzzerTestOneInput(const unsigned char *p, size_t n) { (void)p; (void)n; return 0; }\n' | clang -x c -fsanitize=fuzzer,address,undefined -o "$tmp/fuzz-probe" - >/dev/null 2>&1 && "$tmp/fuzz-probe" -runs=1 >/dev/null 2>&1; then
        "$scripts/fuzz.sh" "$root/examples/fixed/fuzz_bytes.c" >"$tmp/fuzz.log" 2>&1
    else
        ce_note 'SKIP libFuzzer runtime unavailable'
    fi
fi

printf 'script tests passed\n'
