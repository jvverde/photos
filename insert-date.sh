#!/usr/bin/env bash
shopt -s expand_aliases

exists() {
	type "$1" >/dev/null 2>&1;
}

alias mv='echo mv'

if [[ $1 =~ --dry-run ]]
then
	shift
else
	unalias mv
fi

[[ $1 =~ -h || -z $1 ]] && {
  echo "Rename all DSC_*.* file on by-species directory by include date taken"
  echo -e "Usage:\n\t$0 [--dry-run] src/by-species/"
  exit 1
}

src="$@"

[[ $src =~ by-species/?$ ]] || die "src must end with .../by-species/"

find "$src" -type f -iname 'DSC*.*'|
	while read file
	do
		fullname="$(cygpath -w "$file")"
		day="$(exiftool -d "%Y-%m-%dT%H-%M-%S" -T -DateTimeOriginal -sort "$fullname" | sed 's/\r//')"
		[[ $day =~ [0-9]{4}-[0-9]{2}-[0-9]{2}T ]] || continue
		dir="$(dirname -- "$file")"
		name="$(basename -- "$file")"
		dst="${dir}/${day}_${name}"
		mv -v "$file" "$dst"
	done