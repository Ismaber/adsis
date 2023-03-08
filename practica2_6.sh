#!/bin/bash
#796902, Berdusan Muñoz, Ismael, T, 1, B
#819015, de Hoyos Cobo, Javier, T, 1, B

DirActual=$(pwd)
cd
DirRaiz=$(pwd)
cd $DirActual

bin=$(ls -dltr $DirRaiz/bin[[:alnum:]][[:alnum:]][[:alnum:]] 2> /dev/null | head -n 1 | tail -c $((${#DirRaiz} + 8)))

if [ "$bin" == "" ]; then
	bin=$DirRaiz/binXXX
	bin=$(mktemp -d "$bin")
	echo "Se ha creado el directorio $bin"
fi
echo "Directorio destino de copia: $bin"

copias=0
for file in $(ls)
do
	if [ -x $file -a ! -d $file ]; then
		cp $file $bin
		copias=$(($copias+1))
		echo "./$file ha sido copiado a $bin"
	fi
done

if [ $copias -eq 0 ]; then
	echo "No se ha copiado ningun archivo"
else
	echo "Se han copiado $copias archivos"
fi
