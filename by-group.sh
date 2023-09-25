#!/usr/bin/env bash
XXX=$(readlink -e "$(dirname $0)")


SRC="$(readlink -ne -- "${1:-by-species}")"
DST="$(readlink -nf -- "$SRC/../by-group")"

[[ $(basename "$SRC") == by-species ]] || {
  echo "'$SRC' is not a by-species directory"
  exit 1 
} 

find "$SRC" -mindepth 1 -maxdepth 1 -type d -path '*/by-species/*' -printf "%f\n"|
  while read -r F L
  do
    name="$F${L:+ $L}"
  	TARG="$SRC/$name"
    dir="$DST/${L:-${F%%-*}}"
    LINK="$dir/$name"
    mkdir -pv "$dir"
  	ln -rsvfT "$TARG" "$LINK"
  done