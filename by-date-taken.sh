#!/usr/bin/env bash
declare -r sdir=$(readlink -e "$(dirname $0)")

exists() {
	type "$1" >/dev/null 2>&1;
}

declare OS="$(uname -o |tr '[:upper:]' '[:lower:]')"

[[ $1 =~ ^-h || -z $1 || -z $2 ]] && {
	echo "Create hardlinks organized by data taken"
	echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]] dst"
	exit 1
}

declare -a src=("${@:1:$#-1}")
declare -r dst="${@: -1}"

while IFS= read file
do
	declare fullname="$file"
	[[ $OS == cygwin ]] && exists cygpath && fullname="$(cygpath -w "$file")"
	while IFS=$'\t' read -r DT MD
	do
		[[ $DT == - ]] && continue
		MD="${MD//$'\r'}" #Sometimes we need this
		declare name="$(basename -- "$file")"
		declare parent="$(dirname -- "$file")"
		from="$parent/$name"
		ymd=${DT% *}
		hms=${DT#* }
		h=${hms%%-*}
		prefix="$hms"
		#to="$dst/$ymd/$h/$prefix.$name"
    base=${name//????-??-??T??-??-??_/}
		to="$dst/$ymd/$prefix.$base"
		mkdir -pv "$(dirname -- "$to")"
		[[ $from -ef $to ]] && continue
		[[ -e $to ]] && to="$dst/$ymd/$prefix.${MD//\//-}.$base"
		ln -vbfT "$from" "$to"
	done < <(exiftool -d "%Y/%m/%d %H-%M-%S" -T -DateTimeOriginal -FileModifyDate -sort "$fullname")
done < <(find "${src[@]}" -type f -printf "%i %p\0" | grep -zZvFf <(find "$dst" -type f -printf "%i\n") |cut -zd' ' -f2-|xargs -r0I{} file -i -- "{}" | sed -n 's!: image/[^:]*$!!p')

#find //cygdrive/p/* ! -ipath '*$RECYCLE.BIN/*' -type f -printf "%i %p\n" |grep -iFf <(echo -ne ".jpg\n.nef") | grep -vFf <(find /cygdrive/e/.by-date/ -type f -printf "%i\n") |cut -d' ' -f2-|xargs -rI{} /cygdrive/e/Tools/by-date-taken.sh '{}' //cygdrive/p/.by-date/
