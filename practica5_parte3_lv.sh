#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B

#Se comprueba que el usuario que ejecuta el script tiene privilegios de administracion
#Sino muestra un mensaje de error por la salida estandar y el script termina con status de salida es 1
if [ $EUID -ne 0 ]; then
	echo "Este script necesita privilegios de administracion"
	exit 1
fi
#Se lee una linea del fichero (con -r para que la contrabarra no de problemas) y se guarda en "usuario"
while read -r volumen 
do
	#Se cambia el IFS a coma porque los campos del fichero estan separados por comas
    IFS=,
	#Se leen los campos contenidos en "volumen" con -r (explicado antes) y con -a (para asignar los campos a un array) y se guardan en el array "campos"
	read -ra campos <<< "$volumen"
	#Se extrae el nombre del volumen lógico (si ya existe) mediante lvdisplay (con -C para mostrarlo por columnas)
	#y solo nos quedamos con la línea que contenga "${campos[0]}/${campos[1]}" con grep
	#tr -d '[[:space:]]' elimina (-d) los espacios
    VL=$(lvdisplay "${campos[0]}/${campos[1]}" -Co "lv_path" | grep "${campos[0]}/${campos[1]}" | tr -d '[[:space:]]') &> /dev/null
	#Se comprueba si no existe "VL"
    if [ -z "$VL" ]; then
		#Se crea el volumen lógico con tamaño "campos[2]", nombre "campos[1]" y grupo volumen "campos[2]"
        lvcreate -L${campos[2]} -n ${campos[1]} ${campos[0]}
		#Se comprueba que se ha creado correctamente el volumen lógico
        if [ $? -eq 0 ]; then
			#Se crea el directorio de montaje "campos[4]"
            mkdir -p "${campos[4]}"
			#Se extrae el nombre del volumen lógico (si ya existe) mediante lvdisplay (con -C para mostrarlo por columnas)
			#y solo nos quedamos con la línea que contenga "${campos[0]}/${campos[1]}" con grep
			#tr -d '[[:space:]]' elimina (-d) los espacios
			VL=$(lvdisplay "${campos[0]}/${campos[1]}" -Co "lv_path" | grep "${campos[0]}/${campos[1]}" | tr -d '[[:space:]]') &> /dev/null
            echo -e "$VL\t${campos[4]}\t${campos[3]}\tdefaults\t0\t0" >> /etc/fstab
			#Se le da formato al volumen lógico "VL" y si se le ha podido dar formato correctamente se monta
            mkfs -t ${campos[3]} $VL && mount $VL ${campos[4]} && echo "$VL creado y montado correctamente"
        fi
    #Sino se extiende "VL"
	else
		#Se extiende el volumen "VL" con el tamaño "campos[2]"
        lvextend -L${campos[2]} $VL && resize2fs $VL && echo "$VL extendido correctamente"
    fi
done