#!/bin/sh
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$script_dir/common.sh"
[ "$#" -ge 1 ] && [ "$#" -le 2 ] || ce_die "usage: $0 FUZZ_TARGET.c [CORPUS_DIR]"
target=$1
corpus=${2:-}
[ -f "$target" ] || ce_die "target not found: $target"
ce_have clang || ce_die 'libFuzzer mode requires clang'
ce_tmp=$(ce_tmpdir) || ce_die 'cannot create temporary directory'
binary=$ce_tmp/fuzzer
trap 'rm -rf "$ce_tmp"' EXIT HUP INT TERM
if ! printf 'int main(void) { return 0; }\n' | clang -x c -fsanitize=fuzzer,address,undefined -o "$ce_tmp/probe" - >/dev/null 2>&1; then
    ce_die 'installed clang does not provide libFuzzer with ASan+UBSan'
fi
clang -g -O1 -fno-omit-frame-pointer -fsanitize=fuzzer,address,undefined "$target" -o "$binary"
if [ -n "$corpus" ]; then [ -d "$corpus" ] || ce_die "corpus directory not found: $corpus"; fi
if [ -n "$corpus" ]; then "$binary" -max_total_time=10 "$corpus"
else "$binary" -max_total_time=10
fi
