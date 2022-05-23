#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B

#Se comprueba que el usuario que ejecuta el script tiene privilegios de administracion
#Sino muestra un mensaje de error por la salida estandar y el script termina con status de salida 1
if [ $EUID -ne 0 ]; then
	echo "Este script necesita privilegios de administracion"
	exit 1
fi
#Se comprueba que haya más de un parámetro
if [ $# -gt 1 ]; then 
	#Se guarda el grupo volumen ($1)
	grupo_volumen=$1           
	#Se mueven los parámetros una posición a la izquierda perdiendo el primer parámetro       
	shift                    
	#Se extiende la capacidad de "grupo_volumen" con las particiones de $@
	vgextend $grupo_volumen $@
#Sino muestra un mensaje de error por la salida estandar y el script termina con status de salida 1
else
	echo "Número insuficiente de parámetros"
    exit 1
fi