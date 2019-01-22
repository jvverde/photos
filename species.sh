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

	find "$DIR" -type f |
		while read -r FILE
		do
			FILENAME="$(basename -- "$FILE")"
			EXT="${FILENAME##*.}"
			NAME="${FILENAME%.*}"
      LINK="${DST}/${YEAR}-${NAME}-${MD}.${EXT}"
			[[ -L $LINK && -e $LINK ]] || ln -sfrv "${FILE}" "$LINK"
		done
done < <(
  find "$SRC" -type d -ipath '*Freita*/Sel/*' ! -ipath '*flickr*'   -printf "%p|%f\n" | sort -t'|' -k2
  find "$SRC" -type d -ipath '*Freita*/*' -exec test -e {}/Sel \; ! -ipath '*flickr*'   -printf "%p/Sel|%f\n" | sort -t'|' -k2  
  find "$SRC" -type d -ipath '*Freita*/*' -exec test -e {}/sel \; ! -ipath '*flickr*'   -printf "%p/sel|%f\n" | sort -t'|' -k2  
)
