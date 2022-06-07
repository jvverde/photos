#!/usr/bin/env bash
#Move selected photos (=photos on Sel directory) to 'original' folder

sdir="$(readlink -e "$(dirname $0)")"

SRC="${1:-.}"

#shopt -s extglob
#shopt -s nocaseglob
 
while read selected
do
  dir="${selected%/*/*.???}"          #use ??? instead of jpg because it could be JPG
  original="$dir/original"
  [[ -d $original ]] || mkdir -pv "$original"
  filename="${selected##*/}" 
  file="${filename%.???}" #remove extension
  file="${file%%-NEF*}" #remove any -NEF siffix (from DxO Pure Raw)
  #file="${file%[a-zA-Z]}"
  #find "$dir" -maxdepth 1 -name "*$file.*" -exec mv -vf "{}" "$original"/ ';' #don't use this because the bug "same file"
  #echo "filename=$filename (file=$file)"
  find "$dir" -maxdepth 1 -name "*$file.*" -exec mv -v "{}" "$original"/ ';'
done < <(find "$SRC" -ipath '*/sel/*.jpg')
