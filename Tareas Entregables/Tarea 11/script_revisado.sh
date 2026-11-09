#!/bin/bash

directorio=$1 # Cogemos 2 parametros del comando
informe=$2
fecha=$(date +%d/%m/%Y)
total=0

function mostrar_uso { # Funcion que se ejecuta si no encuentra los 2 parametros, ademas de dar un ejemplo de como se deberia usar, sale con codigo 1
    echo "Uso: $0 <directorio> <informe>"
    echo "Ejemplo: $0 /usr/bin /tmp/informe.txt"
    exit 1
}

function revisar {
    local permiso=$1
    find "$directorio" -xdev -type f -perm "$permiso" 2>/dev/null >>"$informe"
}

if [ $# -ne 2 ]; then # Ejecuta la funcion si no tenemos 2 parametros
    mostrar_uso
fi

if [ ! -d "$directorio" ]; then # Var1 es $1, si no existe el directorio sale con error 2
    echo "Error: $directorio no es un directorio"
    exit 2
fi

echo "Revision del $fecha" >"$informe"

for permiso in -4000 -2000 -0002; do
    case $permiso in
    -4000)
        tipo="SUID"
        ;;
    -2000)
        tipo="SGID"
        ;;
    -0002)
        tipo="escritura para otros"
        ;;
    esac

    antes=$(wc -l <"$informe")
    revisar $permiso
    despues=$(wc -l <"$informe")
    cantidad=$((despues - antes))

    echo "Ficheros con $tipo: $cantidad"
    total=$((total + cantidad))
done

if [ $total -eq 0 ]; then
    echo "No se ha encontrado nada raro"
else
    echo "Total a revisar: $total"
    echo "Detalle en $informe"
    exit 3
fi
