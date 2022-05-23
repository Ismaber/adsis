#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B

#Se comprueba que el usuario que ejecuta el script tiene privilegios de administracion
#Sino muestra un mensaje de error por la salida estandar y el script termina con status de salida 1
if [ $EUID -ne 0 ]; then
	echo "Este script necesita privilegios de administracion"
	exit 1
fi
#Se comprueba que el número de parametros sea 1
if [ $# -eq 1 ]; then 
    #Se realiza la conexión ssh listando los discos duros disponibles y sus tamaños en bloques (sfdisk -s),
    #las particiones y sus tamaños (sfdisk -l), y la información de montaje de sistemas de ficheros (df -hT)
    #salvo tmpfs (grep -vE 'udev|tmpfs' (-v invierte la manera de seleccionar y -E indica que es una expresión regular))
    ssh as@"$1" "sudo sfdisk -s && sudo sfdisk -l && sudo df -hT | grep -vE 'udev|tmpfs'"
#Sino muestra un mensaje de error por la salida estandar y el script termina con status de salida 1
else
    echo "Numero incorrecto de parametros"
    exit 1
fi