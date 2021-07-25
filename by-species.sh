#!/usr/bin/env bash
die() {
  echo -e "$@"
  exit 1
}

[[ $1 =~ -h || -z $1 || -z $2 ]] && {
  echo "Create hardlinks from DST/by-species to SRC/.../by-species"
  echo -e "Usage:\n\t$0 src1 [src2[...[srcN]]] dst"
  echo -e "\nExample:\t$0 ../FOTOS/by-year/ ../FOTOS/by-species/"
  exit 1
}

declare -a src=("${@:1:$#-1}")
declare dst="${@: -1}"

[[ $dst =~ by-species/?$ ]] || die "dst must end with .../by-species/"

while IFS= read -r srcdir
do 
	species="$(basename -- "$(dirname -- "$srcdir")")"
	dstdir="$dst/$species"
	[[ $srcdir == $dstdir ]] && continue
	while read -r file
	do
		[[ $file =~ by-species ]] && continue #avoid by-species inside by-species
		from="$srcdir/$file"
		name="$(basename -- "$file")"
		relpath="$(dirname -- "$file")"
		day="$(stat -c %y "$from" |perl -lape 's/\d\d(\d\d)-(\d\d)-(\d\d) (\d\d):(\d\d).+/$1$2$3$4$5/')"
		to="$dstdir/$relpath/${day}_$(echo $name| perl -lape 's/^[0-9]{10}_//')"
		mkdir -pv "$(dirname -- "$to")"
		[[ $from -ef $to ]] && continue    # if they are the same file forget about it
		ln -vbfT "$from" "$to"
	done < <( find "$srcdir" -type f -printf "%P\n")
done < <(find "${src[@]}" -type d -ipath '*/by-species/**/sel' -prune -print)
