#!/bin/bash
#796902, Berdusan Muñox, Ismael, T, 1, A
#819684, Helali Amoura, Zineb, T, 1, A
if [ $# -eq 1 ]; then
	if [ -f "$1" ]; then
		chmod u+x "$1"
		chmod g+x "$1"
		stat -c "%A" "$1"
	else
		echo "$1 no existe"
	fi
else
	echo "Sintaxis: practica2_3.sh <nombre_archivo>"
fi
