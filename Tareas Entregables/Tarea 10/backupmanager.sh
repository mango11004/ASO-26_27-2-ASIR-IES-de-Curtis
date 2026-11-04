#!/bin/bash
# Tarea 10
# El script espera un parametro con el tipo de modo, el resto deberia de hacerlo solo.
# Manuel González López
# Data: 04-11-2026

directoriobackup="/var/backup"
directoriodatos="/home/aso/datos"
fecharchivo=$(date -d now +%Y%m%d%H%M)

if [ "$EUID" = "0" ]; then # Comprobar ejecución con sudo
    clear
else
    echo "No se ejecuto como sudo, error 2"
    exit 2
fi

if [ -d "$directoriobackup"]; then # Comprobar si existe el directorio de backup y crearlo
    clear
else
    mkdir -p $directoriobackup >/dev/null 2>&1
    if [ $? = 0 ]; then
        clear
    else
        echo "Error 3, no se pudo crear la carpeta de las backups"
        exit 3
    fi
fi

if [ -d "$directoriodatos"]; then # Comprobar si existe el directorio de datos y crearlo
    clear
else
    mkdir -p $directoriodatos >/dev/null 2>&1
fi

case $1 in # Case para el tipo de la copia que hay que hacer
C)
    archivo=$fecharchivo"_copia_completa"
    echo "Modo seleccionado: Copia Completa"
    ;;
D)
    archivo=$fecharchivo"_copia_diferencial"
    echo "Modo seleccionado: Copia Diferencial"
    ;;
I)
    archivo=$fecharchivo"_copia_incremental"
    echo "Modo seleccionado: Copia Incremental"
    ;;
*)
    echo "Modo de operación no reconocido, error 1"
    exit 1
    ;;
esac
