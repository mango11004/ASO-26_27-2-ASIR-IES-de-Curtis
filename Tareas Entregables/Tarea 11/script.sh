#!/bin/bash
var1=$1 # Cogemos 2 parametros del comando
var2=$2
var3=$(date +%d/%m/%Y)
var4=0

function f1 {
    echo "Uso: $0 <directorio> <informe>"
    echo "Ejemplo: $0 /usr/bin /tmp/informe.txt"
    exit 1
}

function f2 {
    local var10=$1
    find "$var1" -xdev -type f -perm "$var10" 2>/dev/null >>"$var2"
}

if [ $# -ne 2 ]; then
    f1
fi

if [ ! -d "$var1" ]; then
    echo "Error: $var1 no es un directorio"
    exit 2
fi

echo "Revision del $var3" >"$var2"

for var5 in -4000 -2000 -0002; do
    case $var5 in
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

    var7=$(wc -l <"$var2")

    f2 $var5

    var8=$(wc -l <"$var2")

    var9=$((var8 - var7))

    echo "Ficheros con $var6: $var9"

    var4=$((var4 + var9))

done

if [ $var4 -eq 0 ]; then
    echo "No se ha encontrado nada raro"
else
    echo "Total a revisar: $var4"

    echo "Detalle en $var2"

    exit 3

fi
