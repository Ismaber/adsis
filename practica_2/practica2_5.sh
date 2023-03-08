#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, A
#819684, Helali Amoura, Zineb, T, 1, A
read -p "Introduzca el nombre de un directorio: " dir
if [ -d "$dir" ]; then
	dirs=$(ls -l "$dir" | grep ^d | wc -l)
	files=$(ls -p "$dir" | grep -v \/$ | wc -l)
	echo "El numero de ficheros y directorios en $dir es de $files y $dirs, respectivamente"
else
	echo "$dir no es un directorio"
fi
