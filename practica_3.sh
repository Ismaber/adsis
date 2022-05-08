#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#817567, de Hoyos Cobo, Javier, T, 1, B

#Se comprueba que el usuario que ejecuta el script tiene privilegios de administracion
#Sino muestra un mensaje de error por la salida estandar y el script termina con status de salida es 1
if [ $EUID -ne 0 ]; then
	echo "Este script necesita privilegios de administracion"
	exit 1
fi
#Se comprueba que el número de parametros sea 2
if [ $# -eq 2 ]; then
	#Se comprueba que la opcion es -a (añadir usuarios)
	if [ $1 = "-a" ]; then
		#Se lee una linea del fichero (con -r para que la contrabarra no de problemas) y se guarda en "usuario"
		while read -r usuario
		do
			#Se cambia el IFS a coma porque los campos del fichero estan separados por comas
			IFS=,
			#Se leen los campos contenidos en "usuario con" -r (explicado antes) y con -a (para asignar los campos a un array) y se guardan en el array "campos"
			read -ra campos <<< "$usuario"
			#Si "campos" no contiene 3 componentes el script termina con status de salida 1
			if [ ${#campos[@]} -ne 3 ]; then
				exit 1;
			fi
			#Se comprueba que ninguno de los componentes de "campos" tiene logitud 0
			for i in "${campos[@]}"
			do
				#Si el componente de "campos" (i) tiene longitud 0 el script termina con status de salida 1
				if [ -z i ]; then
					echo "Campo invalido"
					exit 1;
				fi
			done
			#Se añade el usuario con nombre "campos[0]", nombre completo "campos[2]", se crea su directorio home (-m)
			#y se inicializa con los ficheros de /etc/skel (-k /etc/skel), se crea un grupo con el mismo nombre que el usuario (-U)
			#y se crea con un UID minimo de 1815 (-K UID_MIN=1815)
			useradd -m -k /etc/skel -U -K UID_MIN=1815 -c "${campos[2]}" "${campos[0]}" &>/dev/null
			#Se comprueba si la creacion del usuario ha sido exitosa (useradd devuelve 0)
			if [ $? -eq 0 ]; then
				#Se añade el usuario al grupo con su mismo nombre
				usermod -aG 'sudo' ${campos[0]}
				#Se indica que la caducidad de la nueva contraseña sera de 30 dias
				passwd -x 30 ${campos[0]} &>/dev/null
				#Se cambia la contraseña
				echo "${campos[0]}:${campos[1]}" | chpasswd
				#Se muestra por pantalla que el usuario ha sido creado
				echo "${campos[2]} ha sido creado"
			#Sino se muestra por pantalla que el usuario "campos[0]" ya existe
			else
				echo "El usuario ${campos[0]} ya existe".
			fi
		#Se redirige el contenido del fichero ($2) al bucle while
		done < $2
	#Se comprueba que la opcion es -s (borrar usuarios)
	elif [ $1 = "-s" ]; then
		#Se comprueba si exsiste el directorio /extra
		if [ ! -d /extra ]; then
			#Se crea el directorio /extra/backup con sus padres (-p)
			mkdir -p /extra/backup
		#Se comprueba si existe el directorio /extra/backup
		elif [ ! -d /extra/backup ]; then
			#Se crea el directorio /extra/backup
			mkdir /extra/backup
		fi
		#Se lee una linea del fichero (con -r para que la contrabarra no de problemas) y se guarda en "usuario"
		while read -r usuario
		do
			#Se cambia el IFS a coma porque los campos del fichero estan separados por comas
			IFS=,
			#Se leen los campos contenidos en "usuario con" -r (explicado antes) y con -a (para asignar los campos a un array) y se guardan en el array "campos"
			read -ra campos <<< "$usuario"
			#Si "campos" no contiene 1 o 3 componentes el script termina con status de salida 1
			if [ ${#campos[@]} -ne 1 -a ${#campos[@]} -ne 3 ]; then
				exit 1
			fi
			#Se comprueba que ninguno de los componentes de "campos" tiene logitud 0
			for i in "${campos[@]}"
			do
				#Si el componente de "campos" (i) tiene longitud 0 el script termina con status de salida 1
				if [ -z i ]; then
					echo "Campo invalido"
					exit 1
				fi
			done
			#Se guarda el directorio home de "campos[0]" en "home_usuario" mediante getent passwd ${campos[0]}
			#que devuelve el contenido del fichero passwd de "campos[0]" y con cut -d: -f6 se obtiene el sexto campo (-f6) delimitado por ":" (-d:)
			#que es el directorio home
			home_usuario="$(getent passwd ${campos[0]} | cut -d: -f6)"
			#Se crea el tar de "campos[0]"
			tar cvf /extra/backup/${campos[0]}.tar $home_usuario &>/dev/null
			#Si tar ha devuelto 0 entonces se ha creado correctamente y se puede borrar el usuario
			if [ $? -eq 0 ]; then
				#Se fureza el borrado (-f) del usuario "campos[0]"
				userdel -f ${campos[0]} &>/dev/null
			fi
		#Se redirige el contenido del fichero ($2) al bucle while
		done < $2
	#Si la opcion es distinta de -a o -s se muestra un mensaje de error por la salida de error
	else
		echo "Opcion invalida" 1>&2
	fi
#Sino se muestra un mensaje de error por la salida de error
else
	echo "Numero incorrecto de parametros"
fi
