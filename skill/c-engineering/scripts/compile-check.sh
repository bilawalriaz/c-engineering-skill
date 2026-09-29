#!/bin/sh
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$script_dir/common.sh"
if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
    ce_die "usage: $0 FILE.c [compiler]"
fi
source_file=$1
compiler=${2:-${CC:-}}
[ -f "$source_file" ] || ce_die "source file not found: $source_file"
if [ -z "$compiler" ]; then compiler=$(ce_compiler) || ce_die 'no C compiler found'; fi
ce_have "$compiler" || ce_die "compiler not found: $compiler"
set --
if [ -n "${C_STANDARD:-}" ]; then
    std_flag="-std=$C_STANDARD"
    if printf 'int main(void) { return 0; }\n' | "$compiler" -x c -fsyntax-only "$std_flag" - >/dev/null 2>&1; then
        set -- "$@" "$std_flag"
    else
        ce_die "compiler does not support requested C_STANDARD=$C_STANDARD"
    fi
fi
for flag in -fno-common -Wall -Wextra -Wpedantic -Wformat=2 -Wshadow -Wstrict-prototypes -Wmissing-prototypes -Wconversion -Wsign-conversion -Wundef -Wcast-align -Wdouble-promotion -Wnull-dereference -Wimplicit-fallthrough -Wwrite-strings; do
    if printf 'int main(void) { return 0; }\n' | "$compiler" -x c -fsyntax-only "$flag" - >/dev/null 2>&1; then
        set -- "$@" "$flag"
    else
        ce_note "skip unsupported flag: $flag"
    fi
done
if [ -n "${C_STANDARD:-}" ]; then
    ce_note "compile check: $compiler (std=$C_STANDARD) $source_file"
else
    ce_note "compile check: $compiler (compiler default dialect) $source_file"
fi
"$compiler" "$@" -fsyntax-only "$source_file"
