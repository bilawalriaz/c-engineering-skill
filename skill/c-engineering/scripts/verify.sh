#!/bin/sh
set -eu
script_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
# shellcheck source=skill/c-engineering/scripts/common.sh
. "$script_dir/common.sh"
mode=quick
json=0
while [ "$#" -gt 0 ]; do
    case $1 in
        --quick) mode=quick ;;
        --deep) mode=deep ;;
        --doctor) mode=doctor ;;
        --json) json=1 ;;
        -h|--help) printf 'usage: %s [--quick|--deep|--doctor] [--json]\n' "$0"; exit 0 ;;
        *) ce_die "unknown option: $1" ;;
    esac
    shift
done
if [ "$json" -eq 1 ] && [ "$mode" != doctor ]; then
    ce_die '--json is currently supported only with --doctor'
fi
if [ "$mode" = doctor ]; then
    project=$("$script_dir/detect-project.sh" .)
    cc=$(ce_compiler || true)
    if [ "$json" -eq 1 ]; then
        printf '{"project":"%s","compiler":"%s","tools":{"make":%s,"cmake":%s,"ctest":%s,"meson":%s,"ninja":%s,"autotools":%s,"cppcheck":%s,"clang_tidy":%s,"scan_build":%s,"shellcheck":%s}}\n' \
            "$project" "${cc:-unavailable}" \
            "$(ce_have make && printf true || printf false)" "$(ce_have cmake && printf true || printf false)" \
            "$(ce_have ctest && printf true || printf false)" "$(ce_have meson && printf true || printf false)" \
            "$(ce_have ninja && printf true || printf false)" "$(ce_have autoreconf && printf true || printf false)" \
            "$(ce_have cppcheck && printf true || printf false)" "$(ce_have clang-tidy && printf true || printf false)" \
            "$(ce_have scan-build && printf true || printf false)" "$(ce_have shellcheck && printf true || printf false)"
    else
        printf 'Project: %s\nCompiler: %s\n' "$project" "${cc:-unavailable}"
        for tool in make cmake ctest meson ninja autoreconf cppcheck clang-tidy scan-build shellcheck; do
            if ce_have "$tool"; then printf '  %-12s available (%s)\n' "$tool" "$(command -v "$tool")"
            else printf '  %-12s skipped (not installed)\n' "$tool"; fi
        done
    fi
    exit 0
fi
project=$("$script_dir/detect-project.sh" .)
ce_note "verification mode: $mode; project: $project"
ce_note 'note: native build/test commands are repository-defined; inspect unfamiliar repositories before executing them'
case $project in
    make)
        ce_have make || ce_die 'Makefile found but make is unavailable'
        make
        targets=$(make -qp 2>/dev/null | awk -F: '/^(test|check):([^=]|$)/ {print $1; exit}') || true
        if [ -n "$targets" ]; then make "$targets"; else ce_note 'skip tests: no test/check target detected'; fi
        if [ "$mode" = deep ]; then ce_note 'skip instrumented build: Makefile flags/clean behavior are project-specific; use sanitize.sh or the documented sanitizer target'; fi
        ;;
    cmake)
        ce_have cmake || ce_die 'CMakeLists.txt found but cmake is unavailable'
        ce_tmp=$(ce_tmpdir) || ce_die 'cannot create temporary directory'
        verify_cleanup() { verify_status=$?; if [ -n "${ce_tmp:-}" ] && [ -d "$ce_tmp" ]; then if [ "$verify_status" -eq 0 ]; then rm -rf "$ce_tmp"; else ce_note "temporary build retained at $ce_tmp"; fi; fi; exit "$verify_status"; }
        trap verify_cleanup EXIT HUP INT TERM
        cmake -S . -B "$ce_tmp/build" -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
        cmake --build "$ce_tmp/build" --parallel
        if ce_have ctest; then ctest --test-dir "$ce_tmp/build" --output-on-failure
        else ce_note 'skip tests: ctest is unavailable'; fi
        if [ "$mode" = deep ]; then
            compiler=$(ce_compiler) || compiler=
            if [ -n "$compiler" ] && printf 'int main(void){return 0;}\n' | "$compiler" -x c -fsanitize=address,undefined -o "$ce_tmp/probe" - >/dev/null 2>&1 && "$ce_tmp/probe" >/dev/null 2>&1; then
                cmake -S . -B "$ce_tmp/san" -DCMAKE_C_COMPILER="$compiler" -DCMAKE_C_FLAGS='-g -O1 -fno-omit-frame-pointer -fsanitize=address,undefined -fno-sanitize-recover=all' -DCMAKE_EXE_LINKER_FLAGS='-fsanitize=address,undefined' -DCMAKE_SHARED_LINKER_FLAGS='-fsanitize=address,undefined'
                cmake --build "$ce_tmp/san" --parallel
                if ce_have ctest; then ctest --test-dir "$ce_tmp/san" --output-on-failure
                else ce_note 'skip sanitizer tests: ctest is unavailable'; fi
            else ce_note 'skip sanitizer build: ASan+UBSan compiler runtime unavailable'; fi
        fi
        ;;
    meson)
        ce_have meson || ce_die 'meson.build found but meson is unavailable'
        ce_tmp=$(ce_tmpdir) || ce_die 'cannot create temporary directory'
        verify_cleanup() { verify_status=$?; if [ -n "${ce_tmp:-}" ] && [ -d "$ce_tmp" ]; then if [ "$verify_status" -eq 0 ]; then rm -rf "$ce_tmp"; else ce_note "temporary build retained at $ce_tmp"; fi; fi; exit "$verify_status"; }
        trap verify_cleanup EXIT HUP INT TERM
        meson setup "$ce_tmp/build" .
        meson compile -C "$ce_tmp/build"
        meson test -C "$ce_tmp/build" --print-errorlogs
        if [ "$mode" = deep ]; then
            if meson configure "$ce_tmp/build" 2>/dev/null | grep -q 'b_sanitize'; then
                meson setup "$ce_tmp/san" . -Db_sanitize=address,undefined -Db_sanitize_recover=false
                meson compile -C "$ce_tmp/san"
                meson test -C "$ce_tmp/san" --print-errorlogs
            else ce_note 'skip sanitizer build: Meson sanitizer option unavailable'; fi
        fi
        ;;
    ninja)
        ce_have ninja || ce_die 'build.ninja found but ninja is unavailable'
        ninja
        if ninja -t targets 2>/dev/null | grep -q '^test:'; then ninja test
        else ce_note 'skip tests: no Ninja test target detected'; fi
        if [ "$mode" = deep ]; then ce_note 'skip instrumented build: standalone Ninja flags are generator/project-specific; use the generating build system or focused sanitizer tooling'; fi
        ;;
    autotools)
        ce_have make || ce_die 'Autotools project found but make is unavailable'
        [ -x ./configure ] || ce_die 'configure script is missing; run autoreconf according to project docs first'
        ce_tmp=$(ce_tmpdir) || ce_die 'cannot create temporary directory'
        source_root=$(pwd)
        verify_cleanup() { verify_status=$?; if [ -n "${ce_tmp:-}" ] && [ -d "$ce_tmp" ]; then if [ "$verify_status" -eq 0 ]; then rm -rf "$ce_tmp"; else ce_note "temporary build retained at $ce_tmp"; fi; fi; exit "$verify_status"; }
        trap verify_cleanup EXIT HUP INT TERM
        (cd "$ce_tmp" && "$source_root/configure")
        make -C "$ce_tmp"
        ce_note 'skip tests: Autotools test target not inferred; run make check if project documentation requires it'
        if [ "$mode" = deep ]; then ce_note 'skip instrumented build: Autotools compiler flags are project-specific; use documented sanitizer configuration'; fi
        ;;
    *)
        ce_note 'no recognized build system; no build/test command was guessed'
        ce_note 'use compile-check.sh on individual translation units or invoke the repository documented build command'
        ;;
esac
if [ "$mode" = deep ]; then
    if [ "$project" = cmake ]; then
        "$script_dir/static-analysis.sh" . "$ce_tmp/build"
    else
        "$script_dir/static-analysis.sh" .
    fi
    ce_note 'deep verification complete; checks cover only available tools, configured targets, and executed paths'
fi
