#!/usr/bin/env bash
#Sync files

XXX=$(readlink -e "$(dirname $0)")

target="${1:-$(stat -c%m "$0")}"

find $target -type d -name '.*' -prune -o -type d -name 'by-country' -prune -o -type d -name 'by-year' -prune -o -type d -print|
perl -lane 'print if -d "$_/by-country" and -d "$_/by-year"'|
xargs -rI{} find "{}/by-country" -mindepth 1 -maxdepth 1 -type d -print0 |
while IFS= read -r -d '' dst
do
	name=${dst##*/by-country/}
	year="${name##*-}"
	country="${name%-*}"
	dir="${dst%%/by-country/*}"
	src="${dir}/by-year/${year}/${country}"
	[[ -d $src ]] || { 
		echo "directory '$src' does not exit"
		continue
	}
	while read -r file
	do
    from="$src/$file"
    to="$dst/$file"
		dir="$(dirname "$to")"
		[[ -d $dir ]] || mkdir -pv "$dir"
		cp -alTvu --backup=numbered "$src/$file" "$dst/$file"
		cp -alTvu --backup=numbered "$dst/$file" "$src/$file"
	done < <(find "$src" -type f -printf "%P\n")
done