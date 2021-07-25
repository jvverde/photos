#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink

sdir="$(readlink -e "$(dirname $0)")"

dir="${1:-.}"
shift

echo  find "$dir" -type f ${@+$@} -printf "%i %n %s %p\n"
