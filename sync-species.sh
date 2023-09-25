#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink
#NAO ESTA OPERACIONAL
usage() {
	local name=$(basename -s .sh "$0")
	echo Sync files in by-species folders
	echo -e "Usage:\n\t $name wheretofindby-speciesdirectories srctosync"
	exit 1
}

sdir="$(readlink -e "$(dirname $0)")"

dir="$1"
src="${2%/}"

[[ -z $dir || -z $src ]] && usage

find "$dir" ! -path "$src" -type d -iname 'by-*species' -prune|
	while read dir;
	do 
		find "$dir" -mindepth 1 -maxdepth 1 -type d|
			while read spdir; 
			do 
				species="$(basename -- "$spdir")"; 
				#echo $species; 
				from="$src/$species"
				[[ -e "$from" ]] && {
					find "$from" -type f -links 1 -printf "%s %p\n" |
						while read size file
						do
							name="$(basename -- "$file")"
							dst="$spdir/$name"
							found="$(find "$spdir" -size ${size}b -print)"
							[[ -n "$found" ]] && echo "${file} has same size as ${found}" && continue
							[[ -e "$dst" ]] || echo ln -vT "$file" "$dst"
						done
				}
			done
	done	