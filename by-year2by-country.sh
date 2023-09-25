#!/usr/bin/env bash
die() {
  echo -e "$@"
  exit 1
}

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
  echo "Create hardlinks from DST/by-country/country-year to SRC/by-year/year/country"
  echo -e "Usage:\n\t$0 [-n] src1 [src2[...[srcN]]] dst"
  echo -e "\nExample:\t$0 SRC/by-year/ DST/by-country/"
  exit 1
}
shopt -s expand_aliases

if [[ $1 =~ -n ]]
then
  shift
  alias mkdir='echo mkdir'
  alias ln='echo ln'
fi

declare -a src=("${@:1:$#-1}")
declare dst="${@: -1}"

[[ $dst =~ by-country/?$ ]] || die "dst must end with .../by-country/"

for s in "${src[@]}"
do
  [[ $s =~ by-year/?$ ]] || die "Each src must end with .../by-year/"
done

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
done < <(find "$src" -ipath '*/by-year/[1-2][0-9][0-9][0-9]/*' -prune ! -iname '*by-*' -print)
