#!/bin/bash
var1=$1 # Cogemos 2 parametros del comando
var2=$2
var3=$(date +%d/%m/%Y)
var4=0

function f1 { # Funcion que se ejecuta si no encuentra los 2 parametros, ademas de dar un ejemplo de como se deberia usar, sale con codigo 1
    echo "Uso: $0 <directorio> <informe>"
    echo "Ejemplo: $0 /usr/bin /tmp/informe.txt"
    exit 1
}

function f2 {
    local var10=$1
    find "$var1" -xdev -type f -perm "$var10" 2>/dev/null >>"$var2"
}

if [ $# -ne 2 ]; then # Ejecuta la funcion si no tenemos 2 parametros
    f1
fi

if [ ! -d "$var1" ]; then # Var1 es $1, si no existe el directorio sale con error 2
    echo "Error: $var1 no es un directorio"
    exit 2
fi

echo "Revision del $var3" >"$var2" # Añade la fecha al informe que pusimos en el 2º parametro

for var5 in -4000 -2000 -0002; do # Va definiendo los tipos de ficheros
    case $var5 in                 # Cada pasada del bucle revisa un tipo distinto de archivo
    -4000)
        var6="SUID"
        ;;
    -2000)
        var6="SGID"
        ;;
    -0002)
        var6="escritura para otros"
        ;;
    esac

    var7=$(wc -l <"$var2") # Cuenta las lineas antes de añadir los ficheros al informe

    f2 $var5 # Realia la busqueda de los archivos en el directorio especificado y lo mete en el informe

    var8=$(wc -l <"$var2") # Cuenta las lineas despues de añadir las lineas la funcion 2

    var9=$((var8 - var7)) # Quita la 1º linea, que es la de la fecha del script

    echo "Ficheros con $var6: $var9" # Var6 pone el tipo de busqueda y var9 da la cartidad

    var4=$((var4 + var9)) # Se suma a var4 a var9, var4 es 0, despues del 2º bucles es var9, despues del 3º bucles ver var9 + var9

done

if [ $var4 -eq 0 ]; then
    echo "No se ha encontrado nada raro" # Si es 0 var4 dice esto
else
    echo "Total a revisar: $var4" # Si var4 no es 0 dice esto otro y sale con 3

    echo "Detalle en $var2"

    exit 3

fi
