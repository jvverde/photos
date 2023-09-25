#!/usr/bin/env bash
declare -r sdir=$(readlink -e "$(dirname $0)")

[[ $1 =~ ^-h || -z $1 ]] && {
	echo "Show DataTimeOriginal|FileModifyDate|filename of files without hardliks"
	echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]]"
	exit 1
}

declare -a src=("$@")

while IFS= read file
do
	while IFS=$'\t' read -r DT MD
	do
		echo "$DT|$MT|$file"
 	done < <(exiftool -d "%Y/%m/%d %H-%M-%S" -T -DateTimeOriginal -FileModifyDate -sort "$file")
done < <(find "${src[@]}" -type f -links 1 -print)
