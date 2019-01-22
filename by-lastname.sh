#!/usr/bin/env bash
XXX=$(readlink -e "$(dirname $0)")


SRC="$(readlink -ne -- "${1:-by-species}")"
DST="$(readlink -nf -- "$SRC/../by-lastname")"

mkdir -pv "$DST"

find "$SRC" -mindepth 1 -maxdepth 1 -type d -printf "%f\n"|
while read -r F L
do
	[[ -n "$L" ]] && LINK="$DST/$L,$F" || LINK="$DST/$F"
	[[ -n "$L" ]] && TARG="$SRC/$F $L" || TARG="$SRC/$F"
	[[ -e "$LINK" ]] || ln -rsvfT "$TARG" "$LINK"
done