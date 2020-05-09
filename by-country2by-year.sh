#!/usr/bin/env bash
#Sync files

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
  echo "Create hardlinks from DST/by-year/year/country to SRC/by-country/country-year"
  echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]] dst"
  exit 1
}

declare -a src=("${@:1:$#-1}")
declare dst="${@: -1}"
[[ $dst =~ by-year/?$ ]] || dst="$dst/by-year"

[[ -d $dst ]] || mkdir -pv "$dst"

while read dir 
do
  name="$(basename -- "$dir")"
  [[ $name =~ .+-[0-9]{4}$ ]] || continue
  year="${name##*-}"
  country="${name%-*}"
  target="$dst/$year/$country"
  while read -r file
  do
    from="$dir/$file"
    to="$target/$file"
    [[ $from -ef $to ]] && continue
    mkdir -pv "$(dirname -- "$to")"
    echo ln -vbfT "$from" "$to"
  done < <(find "$dir" -type f ! -path '*/.*' -printf "%P\n")
done < <(find "$src" -ipath '*/by-country/*-[0-9][0-9][0-9][0-9]' -print)
