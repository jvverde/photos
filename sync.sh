#!/usr/bin/env bash
XXX=$(readlink -e "$(dirname $0)")

TARGET="${1:-$(stat -c%m "$0")}"

find $TARGET -type d -name '.*' -prune -o -type d -name 'by-country' -prune -o -type d -name 'by-year' -prune -o -type d -print|
perl -lane 'print if -d "$_/by-country" and -d "$_/by-year"'|
xargs -rI{} find "{}/by-country" -mindepth 1 -maxdepth 1 -type d -print0 |
while IFS= read -r -d '' DST
do
	NAME=${DST##*/by-country/}
	YEAR="${NAME##*-}"
	COUNTRY="${NAME%-*}"
	DIR="${DST%%/by-country/*}"
	SRC="${DIR}/by-year/${YEAR}/${COUNTRY}"
	[[ -d $SRC ]] || { 
		echo "directory '$SRC' does not exit"
		continue
	}
	while read -r FILE
	do
		DIR="$(dirname "$DST/$FILE")"
		[[ -d $DIR ]] || mkdir -pv "$DIR"
		cp -alTvu --backup=numbered "$SRC/$FILE" "$DST/$FILE"
		cp -alTvu --backup=numbered "$DST/$FILE" "$SRC/$FILE"
	done < <(find "$SRC" -type f -printf "%P\n")
done