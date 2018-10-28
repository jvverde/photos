#!/usr/bin/env bash
XXX=$(readlink -e "$(dirname $0)")


SRC="${1:-"$(stat -c%m "$0")"/FOTOS}"

TARGET="$SRC/Species/Freita"

[[ -d $TARGET ]] || mkdir -pv "$TARGET"

while IFS='|' read -r DIR SPECIES
do
	YEAR="$(echo $DIR |perl -ne 'm#/(\d{4})/# and print $1')"
	MD="$(echo $DIR | md5sum -| xargs -rI{} printf "%.4s" "{}")"
	DST="$TARGET/$SPECIES"

	[[ -d $DST ]] || mkdir -pv "$DST"

	find "$DIR/$SPECIES" -type f |
		while read -r FILE
		do
			FILENAME="$(basename -- "$FILE")"
			EXT="${FILENAME##*.}"
			NAME="${FILENAME%.*}"
			ln -srv "${FILE}" "${DST}/${YEAR}-${NAME}-${MD}.${EXT}"
		done
done < <(find "$SRC" -type d -ipath '*Freita*/Sel/*' ! -ipath '*flickr*'   -printf "%h|%f\n" | sort -t'|' -k2)
