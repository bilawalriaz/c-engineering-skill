#!/bin/sh
set -eu
root=${1:-.}
if [ -f "$root/CMakeLists.txt" ]; then printf 'cmake\n'
elif [ -f "$root/meson.build" ]; then printf 'meson\n'
elif [ -f "$root/Makefile" ] || [ -f "$root/makefile" ] || [ -f "$root/GNUmakefile" ]; then printf 'make\n'
elif [ -x "$root/configure" ] || [ -f "$root/configure.ac" ] || [ -f "$root/configure.in" ]; then printf 'autotools\n'
else printf 'unknown\n'; fi
