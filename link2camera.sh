#!/usr/bin/env bash
#Find photos on camera folder and link by-species files to it

sdir="$(readlink -e "$(dirname $0)")"

SRC="${1:-.}"

#shopt -s extglob
#shopt -s nocaseglob

while read dir
do
  echo read=$dir
  while read file
  do
    size=$(stat -c%s "$file")
    filename="$(basename -- "$file")"

    #echo file=$file
    #dir="${selected%/*/*.???}"          #use ??? instead of jpg because it could be JPG
    link="$(find "$dir/by-species" -name "$filename" -size "$size"c -exec cmp -s "$file" "{}" ';' -prune -print)"
    [[ -n $link ]] && cp -lvTf "$file" "$link"
  done < <(find "$dir" -type f ! -ipath '*/by-species/*' -ipath '*/dia[1-9]*/*' )
done < <(find "$SRC" -type d -exec test -d "{}/by-species" ';' -prune -print)
