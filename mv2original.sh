#!/usr/bin/env bash
#Move selected photos (=photos on Sel directory) to 'original' folder

sdir="$(readlink -e "$(dirname $0)")"

SRC="${1:-.}"

#shopt -s extglob
#shopt -s nocaseglob
 
while read selected
do
  dir="${selected%/*/*.jpg}"
  original="$dir/original"
  [[ -d $original ]] || mkdir -pv "$original"
  filename="${selected##*/}" 
  file="${filename%.jpg}"
  find "$dir" -maxdepth 1 -name "*$file.*" -exec echo mv -vf "{}" "$original"/ ';'
done < <(find "$SRC" -ipath '*/sel/*.jpg')
