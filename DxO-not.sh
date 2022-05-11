#!/usr/bin/env bash
#

sdir="$(readlink -e "$(dirname $0)")"

dir="${1:-.}"

find "$dir" -type d -iname 'dxo'|
	while read dirname;
	do
		a=$(find "$dirname" -type f ! -ipath '*/sel/*'|wc -l);
		b=$(find "$dirname/.." -maxdepth 1 -type f|wc -l);
		echo "$a|$b|$dirname"; 
	done |
	awk -F\| '$1 != $2 {print}'
