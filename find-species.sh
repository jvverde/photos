#!/usr/bin/env bash
SDIR=$(readlink -e "$(dirname $0)")
die() {
	local RET=$?
	echo -e "Line ${BASH_LINENO[0]}: $@">&2 
	exit $RET
}

#Read SRC from first parameter of try to find a directory with name 'by-year'
SRC="${1:-"$(find "$(stat -c%m "$SDIR")" -type d -name by-year -print -quit)"}"

[[ -d $SRC ]] || die "Can't find $SRC"
SRC="$(readlink -ne "$SRC")"

DST="$(readlink -fn -- "$SRC/../by-species")"

[[ -d $DST ]] || mkdir -pv "$DST"

find "$SRC" -type d -iname species -prune -print0|						#search for folders with name species
	xargs -r0I{} find "{}" -maxdepth 1 -mindepth 1 -type d | 		#and then find each sub-folder under it
	while read -r DIR 
	do 
		SPECIES=$(basename -- "$DIR")
		TARGET="$(find "$DST" -type d -name "$SPECIES" -print -quit)"		#try to find a correspondent directory (at any level) under destination 
		[[ -n $TARGET && -d $TARGET ]] || {															#create one if needed
			TARGET="$DST/$SPECIES"
			mkdir -pv "$TARGET"
		}
		LOCAL="${DIR%/species/$SPECIES}"																
		LOCAL="${LOCAL##*/}"
		LOCAL="${LOCAL##[0-9]*-}"

		find "$DIR" -type f -printf "%P\n" |
			while read -r FILE 													#FILE could be just a name or a relative path to DIR
			do
				IMG="$DIR/$FILE"
				DATA="$(exiftool -d "%Y-%m-%dT%H-%M-%S" -T -DateTimeOriginal "$IMG")"
				TO="$(dirname -- "${TARGET}/${FILE}")"
				[[ -d $TO ]] || mkdir -pv "$TO"
				HLINK="${TO}/${DATA}_${LOCAL}_$(basename -- "${FILE}")"
				cp -alTvu --backup=numbered "$IMG" "$HLINK"
			done
	done

