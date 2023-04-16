#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B

#Se comprueba que el número de parametros sea 2
if [ $# -eq 3 ]; then
	#Se comprueba que la opción sea -a (añadir usuarios) o -s (borrar usuarios)
	if [ $1 = "-a" -o $1 = "-s" ]; then
		#Se leen las direciones del fichero de direcciones ($2) con -r (para que las contrabarras no den problemas)
		while read -r direccion
		do
			#Se copian los ficheros necesarios para ejecutar el script (practica_3.sh y $2)
			scp practica_3.sh ./$2 as@${direccion}:~/ &> /dev/null
			#Se comprueba que se han podido copiar los ficheros a "direccion"
			if [ $? -eq 0 ]; then
				#Se ejecuta practica_3.sh $1 ./$2, se borran practica_3.sh y ./$2 y se sale de "direccion"
				ssh -n as@${direccion} "sudo ./practica_3.sh $1 ./$2 && rm practica_3.sh ./$2 && exit"
			#Sino se indica que "direccion" no es accesible
			else
				echo "${direccion} no es accesible"
			fi
		#Se redirige el fichero de direcciones al while ($3)
		done < $3
	#Si la opcion es distinta de -a o -s se muestra un mensaje de error por la salida de error
	else
		echo "Opcion invalida" 1>&2
	fi
#Sino se muestra un mensaje de error por la salida de error
else
    echo "Numero incorrecto de parametros"
fi
