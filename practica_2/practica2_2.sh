#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, A
#819684, Helali Amoura, Zineb, T, 1, A
for file in "$@"
do
	if [ -f "$file" ]; then
		more "$file"
	else
		echo "$file no es un fichero"
	fi
done
