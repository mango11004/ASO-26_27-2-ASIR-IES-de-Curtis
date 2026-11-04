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
    archivo=$fecharchivo"_copia_completa.tar.gz"
    echo "Modo seleccionado: Copia Completa"
    sleep 3
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos"
    ;;
D)
    archivo=$fecharchivo"_copia_diferencial.tar.gz"
    echo "Modo seleccionado: Copia Diferencial"
    sleep 3
    if [ -f "$directoriobackup/estado.snar" ]; then
        cp "$directoriobackup/estado.snar" "$directoriobackup/estado_dif.snar"
        clear
    else
        echo "No hay copia completa de la que realizar diferencial, voy a realizar una copia completa"
        tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos"
        clear
    fi
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_dfi.snar" "$directoriodatos"
    errortar=$?
    if [ $errortar = 0 ]; then
        echo "Copia finalizada"
        exit 0
    else
        echo "Fallo la copia de seguridad con error $errortar"
    fi
    ;;
I)
    archivo=$fecharchivo"_copia_incremental.tar.gz"
    echo "Modo seleccionado: Copia Incremental"
    sleep 3
    if [ -f "$directoriobackup/estado_inc.snar" ]; then
        clear
    else
        if [ -f "$directoriobackup/estado.snar" ]; then
            cp "$directoriobackup/estado.snar" "$directoriobackup/estado_inc.snar"
            clear
        else
            echo "No hay copia completa de la que realizar incremental, voy a realizar una copia completa"
            tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos"
            clear
        fi
    fi
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_inc.snar" "$directoriodatos"
    errortar=$?
    if [ $errortar = 0 ]; then
        echo "Copia finalizada"
        exit 0
    else
        echo "Fallo la copia de seguridad con error $errortar"
    fi
    ;;
*)
    echo "Modo de operación no reconocido, error 1"
    exit 1
    ;;
esac

echo "Ejecución finalizada, saliendo del script"
exit 0
