#!/usr/bin/env bash
XXX=$(readlink -e "$(dirname $0)")


find Isidro/ -type d -iname species -prune -print0|
	xargs -r0I{} find "{}" -maxdepth 1 -mindepth 1 -type d | 
	while read -r DIR; 
	do 
		SPECIES=$(basename -- "$DIR"); 
		TARGET="./by-species/$SPECIES"; 
		mkdir -pv "$TARGET"; 
		find "$DIR" -type f -printf "%P\n" |
			while read -r FILE
			do
				DST=$(dirname -- "$TARGET/$FILE")
				mkdir -pv "$DST"
				cp -alTv "$DIR/$FILE" "$TARGET/$FILE";
			done
	done

