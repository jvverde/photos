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
        filename="${day}_$(echo $name| perl -lape 's/^[0-9]{10}_//')"
        dstfile="$dst/$filename"
        srcfile="$dir/$file"
        [[ -e $dstfile && $dstfile -ef $srcfile ]] && continue    # if they are the same file forget about it
				ln -vfT "$srcfile" "$dstfile"
			done
	done

  