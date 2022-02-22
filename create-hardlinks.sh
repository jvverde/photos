#!/usr/bin/env bash
shopt -s expand_aliases

exists() {
	type "$1" >/dev/null 2>&1;
}

alias mkdir='echo mkdir'
alias ln='echo ln'

if [[ $1 =~ --dry-run ]]
then
	shift
else
	unalias mkdir
	unalias ln
fi

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
  echo "Create hardlinks from SRC to DST"
  echo -e "Usage:\n\t$0 src dst"
  exit 1
}

src="$1"
dst="$2"

echo rsync --dry-run -aiH --ignore-existing "$src/" "$dst/" | grep '>f++++' | cut -d' ' -f2- |
while read filename
do
	dir="$(dirname -- "$filename")"
	mkdir -pv "$dst/$dir"
	ln -Tv "$src/$filename" "$dst/$filename"
done