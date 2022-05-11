#!/usr/bin/env bash
#Find files wit same content and desduplicate them by creating a hardlink

sdir="$(readlink -e "$(dirname $0)")"

dir="${1:-.}"

$ find "$dir" -type d -iname 'dxo'|
	while read dirname;
	do
		a=$(find "$dirname" -maxdepth 1 -type f|wc -l);
		b=$(find "$dir/.." -maxdepth 1 -type f|wc -l);
		echo "$a|$b|$dir"; 
	done |
	awk -F\| '$1 == $2 {print}'
