#!/usr/bin/env bash
#Move selected photos (=photos on Sel directory) to 'original' folder

sdir="$(readlink -e "$(dirname $0)")"

SRC="${1:-.}"

#shopt -s extglob
#shopt -s nocaseglob
 
while read selected
do
  dir="${selected%/*.???}"          #use ??? instead of NEF because it could be nef
  dxo="$dir/DxO"
  [[ -d $dxo ]] || mkdir -pv "$dxo"
  filename="${selected##*/}" 
  file="${filename%.???}" #remove extension
  find "$dir/../DxO" -maxdepth 1 -iname "*$file*" -exec mv -vb "{}" "$dxo"/ ';'
done < <(find "$SRC" -ipath '*/original/*.NEF')
