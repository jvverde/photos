#!/usr/bin/env bash
die() {
	echo -e "Line ${BASH_LINENO[0]}: $@">&2 
}
declare SRC="${1:-.}"
[[ -d $SRC ]] || die "Can't find diretory '$SRC'"
SRC="$(readlink -ne "$SRC")"

find "$SRC" -mindepth 1 -type d -prune -exec test -e "{}/no flickr" \; -printf "%f\n" |
	cat -n |
	perl -lape '/(?<=\t).+/;
		$name = $tag = $&;
		$tag =~ s/[\s-]//g;
		s#\t(.+)# -\> <a href="https://www.flickr.com/photos/jvverde/tags/$tag" target="_blank">$name</a>#;
	'


