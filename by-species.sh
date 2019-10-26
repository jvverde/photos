#!/usr/bin/env bash
XXX=$(readlink -e "$(dirname $0)")

src="$1" 

[[ -d $src ]] || {
	echo "Usage: $0 dirname"
	exit 1
}

find "$src" -mindepth 2 -type d -iname by-species -prune -print0|
	xargs -r0I{} find "{}" -maxdepth 1 -mindepth 1 -type d -print0| 
	while IFS= read -r -d $'\0' dir; 
	do 
		species=$(basename -- "$dir"); 
		target="$src/by-species/$species"; 
		mkdir -pv "$target"; 
		find "$dir" -type f -printf "%P\n" |
			while read -r file
			do
				dst=$(dirname -- "$target/$file")
        name=$(basename -- "$target/$file")
				mkdir -pv "$dst"
        day="$(stat -c %y "$dir/$file" |perl -lape 's/\d\d(\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d).+/$1$2$3$4$5/')"
				cp -aluTv --backup=t "$dir/$file" "$dst/${day}_$name";
			done
	done

