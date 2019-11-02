#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink

sdir="$(readlink -e "$(dirname $0)")"

dir="${1:-.}"

declare -i oldsize=0
declare oldfile=""

while read inum hlinks size file
do
  #echo "size=$size,lh=$hlinks,imum=$inum,file=$file"

  (( oldsize == size )) && cmp -s "$oldfile" "$file" && ln -vfT "$oldfile" "$file"

  oldsize=$size
  oldfile="$file"
done < <(find "$dir" -type f -printf "%i %n %s %p\n" | sort -u -k3nr,3 -k2nr,2 -k1n,1)
