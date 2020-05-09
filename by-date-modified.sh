#!/usr/bin/env bash
declare -r sdir=$(readlink -e "$(dirname $0)")

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
	echo "Create hardlinks organized by data modified"
	echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]] dst"
	exit 1
}

declare -a src=("${@:1:$#-1}")
declare -r dst="${@: -1}"

while IFS= read file
do
	while IFS=$'\t' read -r DT MD
	do
		[[ $DT == - ]] && continue
		declare name="$(basename -- "$file")"
		declare parent="$(dirname -- "$file")"
		from="$parent/$name"
		ymd=${MD% *}
		hms=${MD#* }
		h=${hms%%-*}
		prefix="$hms"
		to="$dst/$ymd/$h/$prefix.$name"
		mkdir -pv "$(dirname -- "$to")"
		[[ $from -ef $to ]] && continue
    [[ -e $to ]] && to="$dst/$ymd/$h/$prefix.${DT}.$name"
    ln -vbfT "$from" "$to"
	done < <(exiftool -d "%Y/%m/%d %H-%M-%S" -T -DateTimeOriginal -FileModifyDate -sort "$file")
done < <(find "${src[@]}" -type f -print)
