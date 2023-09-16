#!/usr/bin/env bash
#Move selected photos (=photos on Sel directory) to 'original' folder

sdir="$(readlink -e "$(dirname $0)")"

SRC="${1:-.}"

#shopt -s extglob
#shopt -s nocaseglob
 
while read original
do
  dir="$original/dxo+on1"
  mkdir -pv "$dir"
  find "$original" \( -ipath "$original/DxO/*" -or -ipath "$original/ON1/*" \) -type f |
    while read file;
    do
      name=${file##*/};
      dst="$dir/$name";
      [[ $file -ef $dst ]] || ln -vfT "$file" "$dst";
    done
done < <(find "$SRC" -type d -iname 'original' -prune -exec test -d "{}/DxO" \; -exec test -d "{}/ON1" \; -print)
