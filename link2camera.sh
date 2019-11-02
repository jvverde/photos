#!/usr/bin/env bash
#Find photos on camera folders (i.e. Per Day folders) and link by-species files to it

sdir="$(readlink -e "$(dirname $0)")"

[[ ${1:-} =~ ^-links ]] && links="${2}" && shift && shift

#shopt -s extglob
#shopt -s nocaseglob
SRC="${1:-.}"
dir=$SRC
#while read dir
#do
  echo Processing $dir
  while read file
  do
    echo $file
    size="$(stat -c%s "$file")"
    filename="$(basename -- "$file")"

    #echo file=$file
    #dir="${selected%/*/*.???}"          #use ??? instead of jpg because it could be JPG
    #link="$(find "$dir/by-species" ! -samefile "$file" -name "$filename" -size "$size"c -exec cmp -s "$file" "{}" ';' -prune -print -quit)"
    #[[ -n $link ]] && cp -lvTf "$file" "$link"
    while read link
    do
      [[ -n $link ]] && ln -vTf "$file" "$link"
    done < <(find "$dir" ! -samefile "$file" -name "$filename" -size "$size"c -exec cmp -s "$file" "{}" ';' -prune -print)
  done < <(find "$dir" -type f ${links:+-links $links})
