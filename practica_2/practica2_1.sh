#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B
read -p "Introduzca el nombre del fichero: " file
l=-
e=-
ex=-
if [ -f "$file" ]; then
	if [ -r "$file" ]; then
		l=r
	fi
	if [ -w "$file" ]; then
		e=w
	fi
	if [ -x "$file" ]; then
		ex=x
	fi
	echo "Los permisos del archivo $file son: $l$e$ex"
else
	echo "$file no existe"
fi
