#!/bin/sh
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$script_dir/common.sh"
[ "$#" -ge 1 ] && [ "$#" -le 2 ] || ce_die "usage: $0 FILE.c [compiler]"
source_file=$1
compiler=${2:-${CC:-}}
[ -f "$source_file" ] || ce_die "source file not found: $source_file"
if [ -z "$compiler" ]; then compiler=$(ce_compiler) || ce_die 'no C compiler found'; fi
ce_have "$compiler" || ce_die "compiler not found: $compiler"
set --
for flag in -Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wstrict-prototypes -Wmissing-prototypes -Wconversion -Wsign-conversion -Wundef -Wcast-align -Wdouble-promotion -Wnull-dereference -Wimplicit-fallthrough -Wwrite-strings; do
    if printf 'int main(void) { return 0; }\n' | "$compiler" -x c -fsyntax-only "$flag" - >/dev/null 2>&1; then
        set -- "$@" "$flag"
    else
        ce_note "skip unsupported flag: $flag"
    fi
done
ce_note "compile check: $compiler $source_file"
"$compiler" "-std=${C_STANDARD:-c11}" -fsyntax-only -fno-common "$@" "$source_file"
