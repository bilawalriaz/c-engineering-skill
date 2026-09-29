#!/bin/sh
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$script_dir/common.sh"
[ "$#" -ge 1 ] && [ "$#" -le 2 ] || ce_die "usage: $0 FILE.c [address,undefined|thread|undefined]"
source_file=$1
sanitizers=${2:-address,undefined}
[ -f "$source_file" ] || ce_die "source file not found: $source_file"
compiler=$(ce_compiler) || ce_die 'no C compiler found'
ce_tmp=$(ce_tmpdir) || ce_die 'cannot create temporary directory'
binary=$ce_tmp/sanitized
cleanup() { rm -rf "$ce_tmp"; }
trap cleanup EXIT HUP INT TERM
if ! printf 'int main(void) { return 0; }\n' | "$compiler" -x c -fsanitize="$sanitizers" -g -o "$ce_tmp/probe" - >/dev/null 2>&1; then
    ce_note "skip: $compiler does not support -fsanitize=$sanitizers on this host"
    exit 0
fi
"$compiler" -std=c11 -g -O1 -fno-omit-frame-pointer -fsanitize="$sanitizers" "$source_file" -o "$binary"
"$binary"
