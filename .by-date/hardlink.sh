#!/usr/bin/env bash
SDIR=$(readlink -e "$(dirname $0)")

TARGET="${1:-$(readlink -e "$SDIR/../by-year")}"
DST="${2:-$(readlink -e "$SDIR/../.by-date")}"

find $TARGET -type f -print0|
	xargs -r0I{} exiftool -d "%Y/%m/%d %H-%M-%S" -T -DateTimeOriginal -FileModifyDate -FileName -Directory -sort "{}" |
	while IFS=$'\t' read -r DT DIR MD NAME
	do
		[[ $DT == - ]] && continue
		DATE=${DT% *}
		TIME=${DT#* }
		mkdir -pv "$DATE"
		PREFIX="$TIME"
		[[ $DT == $MD ]] || PREFIX="$TIME($(echo "$MD" | tr ' /' 'T-'))"
		cp -lTuvb --no-dereference --preserve=all --backup=numbered "$DIR/$NAME" "$DST/$DATE/$PREFIX.$NAME"
	done
