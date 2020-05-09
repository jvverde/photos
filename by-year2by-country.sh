#!/usr/bin/env bash
#Sync files

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
  echo "Create hardlinks from DST/by-country/country-year to SRC/by-year/year/country"
  echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]] dst"
  exit 1
}

declare -a src=("${@:1:$#-1}")
declare dst="${@: -1}"
[[ $dst =~ by-country/?$ ]] || dst="$dst/by-country"

[[ -d $dst ]] || mkdir -pv "$dst"

while read dir 
do
  year="$(basename -- "$(dirname -- "$dir")")"
  country="$(basename -- "$dir")"
  [[ $year =~ ^[0-9]{4}$ ]] || continue
  [[ $country =~ [0-9] || $country =~ by-.* ]] && continue
  target="$dst/$country-$year"
  while read -r file
  do
    from="$dir/$file"
    to="$target/$file"
    [[ $from -ef $to ]] && continue
    mkdir -pv "$(dirname -- "$to")"
    ln -vbfT "$from" "$to"
  done < <(find "$dir" -type f ! -path '*/.*' -printf "%P\n")
done < <(find "$src" -ipath '*/by-year/[0-9][0-9][0-9][0-9]/*' -prune -print)
