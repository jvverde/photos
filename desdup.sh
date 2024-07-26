#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink

sdir="$(readlink -e "$(dirname $0)")"

#dir="${1:-.}"
#shift
declare -a foptions=()

while [[ ${1:-} =~ ^- ]]
do
  key="$1" && shift
  case "$key" in
    -- )
      while [[ ${1:-} =~ ^- ]]
      do
        foptions+=( "$1" )
        shift
      done
    ;;
  esac
done

declare -a src=("${@:-.}")

declare -i oldsize=0
declare -i oldinum=0
declare oldfile=""

while read inum ignore size file
do
  (( oldinum == inum )) && continue # file and oldfile are already hardlink of each other
  (( oldsize == size )) && cmp -s "$oldfile" "$file" && ln -vfT "$oldfile" "$file" && continue

  oldsize=$size
  oldfile="$file"
  oldinum=$inum
done < <(
#  find "$dir" -type f ${@+$@} -printf "%i %n %s %p\n" |
  find "${src[@]}" -type f ${foptions[@]+"${foptions[@]}"} -printf "%i %T@ %s %p\n" |
  sort -k3nr,3 -k2nr,2 -k1n,1 -k4
)
