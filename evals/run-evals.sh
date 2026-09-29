#!/bin/sh
set -eu
root=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
scripts=$root/skill/c-engineering/scripts
passed=0
skipped=0

for compiler in gcc clang; do
    if command -v "$compiler" >/dev/null 2>&1; then
        for source in "$root"/examples/fixed/*.c; do
            case $source in *fuzz_bytes.c) continue ;; esac
            "$scripts/compile-check.sh" "$source" "$compiler"
            passed=$((passed + 1))
        done
    else
        printf 'SKIP %s unavailable\n' "$compiler"
        skipped=$((skipped + 1))
    fi
done

tmp=$(mktemp -d "${TMPDIR:-/tmp}/c-evals.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM
compiler=$(command -v "${CC:-}" 2>/dev/null || command -v clang || command -v gcc || true)

if [ -n "$compiler" ] && printf 'int main(void){return 0;}\n' | "$compiler" -x c -fsanitize=address,undefined -o "$tmp/probe" - >/dev/null 2>&1; then
    if CC="$compiler" "$scripts/sanitize.sh" "$root/examples/buggy/heap_overflow.c" address,undefined >"$tmp/sanitizer.log" 2>&1; then
        printf 'FAIL sanitizer did not detect heap overflow\n' >&2
        exit 1
    fi
    if grep -E 'AddressSanitizer|heap-buffer-overflow|ERROR: AddressSanitizer' "$tmp/sanitizer.log" >/dev/null; then
        passed=$((passed + 1))
    else
        printf 'FAIL sanitizer execution produced no expected diagnostic\n' >&2
        cat "$tmp/sanitizer.log" >&2
        exit 1
    fi
else
    printf 'SKIP ASan+UBSan runtime unavailable\n'
    skipped=$((skipped + 1))
fi

if command -v clang >/dev/null 2>&1 && printf 'int main(void){return 0;}\n' | clang -x c -fsanitize=fuzzer,address,undefined -o "$tmp/fuzz-probe" - >/dev/null 2>&1; then
    clang -g -O1 -fsanitize=fuzzer,address,undefined "$root/examples/fixed/fuzz_bytes.c" -o "$tmp/fuzzer"
    "$tmp/fuzzer" -runs=100 "$root/evals/cases" >/dev/null 2>&1
    passed=$((passed + 1))
else
    printf 'SKIP libFuzzer runtime unavaile\n'
    skipped=$((skipped + 1))
fi

printf 'Eval checks passed: %s; skipped: %s\n' "$passed" "$skipped"
