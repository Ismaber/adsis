#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B
for file in "$@"
do
	if [ -f "$file" ]; then
		more "$file"
	else
		echo "$file no es un fichero"
	fi
done
