#!/bin/sh
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$script_dir/common.sh"
target=${1:-.}
build_dir=${2:-$target}
[ -e "$target" ] || ce_die "path not found: $target"
ran=0
status=0
if ce_have cppcheck; then
    ran=1
    ce_note "static analysis: cppcheck $target"
    cppcheck --enable=warning,performance,portability --error-exitcode=1 --inline-suppr --language=c "$target" || status=$?
else
    ce_note 'skip: cppcheck is not installed'
fi
if [ -f "$build_dir/compile_commands.json" ] && ce_have run-clang-tidy; then
    ran=1
    ce_note "static analysis: run-clang-tidy using $build_dir/compile_commands.json"
    run-clang-tidy -p "$build_dir" || status=$?
elif [ -f "$build_dir/compile_commands.json" ] && ce_have clang-tidy && [ -f "$target" ]; then
    ran=1
    ce_note "static analysis: clang-tidy using $build_dir/compile_commands.json"
    clang-tidy -p "$build_dir" "$target" || status=$?
elif [ -f "$target" ] && ce_have clang; then
    case $target in
        *.c)
            ran=1
            ce_note "static analysis: clang --analyze $target (project build flags are not available)"
            if [ -n "${C_STANDARD:-}" ]; then
                std_flag="-std=$C_STANDARD"
                if printf 'int main(void) { return 0; }\n' | clang -x c -fsyntax-only "$std_flag" - >/dev/null 2>&1; then
                    clang --analyze "$std_flag" "$target" || status=$?
                else
                    ce_die "clang does not support requested C_STANDARD=$C_STANDARD"
                fi
            else
                clang --analyze "$target" || status=$?
            fi
            ;;
        *) ce_note 'skip: Clang analysis requires a C source file or compilation database' ;;
    esac
else
    ce_note 'skip: clang-tidy requires a compilation database; clang --analyze accepts one standalone .c file'
fi
if [ "$ran" -eq 0 ]; then ce_note 'no compatible static analyzer ran'; fi
exit "$status"
