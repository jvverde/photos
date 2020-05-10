#!/usr/bin/env bash
die() {
  echo -e "$@"
  exit 1
}

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
  echo "Create hardlinks from DST/by-year/year/country to SRC/by-country/country-year"
  echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]] dst"
  echo -e "\nExample:\t$0 ../FOTOS/by-country/ ../FOTOS/by-year/"
  exit 1
}

declare -a src=("${@:1:$#-1}")
declare dst="${@: -1}"

[[ $dst =~ by-year/?$ ]] || die "dst must end with .../by-year/"

for s in "${src[@]}"
do
  [[ $s =~ by-country/?$ ]] || die "Each src must end with .../by-country/"
done

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
