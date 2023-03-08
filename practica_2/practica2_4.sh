#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B
read -p "Introduzca una tecla: " tecla
tecla=${tecla:0:1}

if [[ $tecla == [A-Za-z] ]]; then
	echo "$tecla es una letra"
else
	if [[ $tecla == [0-9] ]]; then
		echo "$tecla es un numero"
	else
		echo "$tecla es un caracter especial"
	fi
fi
