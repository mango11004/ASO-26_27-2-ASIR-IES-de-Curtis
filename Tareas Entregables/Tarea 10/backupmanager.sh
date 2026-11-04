#!/bin/bash
# Tarea 10
# El script espera un parametro con el tipo de modo, el resto deberia de hacerlo solo.
# Manuel González López
# Data: 04-11-2026

tamanofile=$(ls -lh $directoriobackup/$archivo)
directoriobackup="/var/backup"
directoriodatos="/home/aso/datos"
fecharchivo=$(date -d now +%Y%m%d%H%M)
log="/var/backup/log.txt"

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
    sleep 2
    echo "Para hacer la copia debemos de borrar todos los estado.snar"
    sleep 2
    read -p "¿Quieres continuar? (S/N)" decision
    if [ "$decision" = "S" -o "$decision" = "s" ]; then
        rm -rf $directoriobackup/estado.snar
        rm -rf $directoriobackup/estado_dif.snar
        rm -rf $directoriobackup/estado_inc.snar
        tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos"
        if [ $errortar = 0 ]; then
            echo "Copia Incremental completada el "$(date)" ,con el nombre $archivo y con tamaño "$($tamanofile | cut -d" " -f7) >$log
            echo "Copia finalizada"
            exit 0
        else
            echo "Fallo la copia de seguridad con error $errortar"
        fi
    else
        echo "Operación abortada"
    fi
    ;;
D)
    archivo=$fecharchivo"_copia_diferencial.tar.gz"
    echo "Modo seleccionado: Copia Diferencial"
    sleep 2
    if [ -f "$directoriobackup/estado.snar" ]; then
        cp "$directoriobackup/estado.snar" "$directoriobackup/estado_dif.snar"
        clear
    else
        echo "No hay copia completa de la que realizar diferencial, voy a realizar una copia completa"
        tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_dif.snar" "$directoriodatos"
        clear
    fi
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_dif.snar" "$directoriodatos"
    errortar=$?
    if [ $errortar = 0 ]; then
        echo "Copia Incremental completada el "$(date)" ,con el nombre $archivo y con tamaño "$($tamanofile | cut -d" " -f7) >$log
        echo "Copia finalizada"
        exit 0
    else
        echo "Fallo la copia de seguridad con error $errortar"
    fi
    ;;
I)
    archivo=$fecharchivo"_copia_incremental.tar.gz"
    echo "Modo seleccionado: Copia Incremental"
    sleep 2
    if [ -f "$directoriobackup/estado_inc.snar" ]; then
        clear
    else
        if [ -f "$directoriobackup/estado.snar" ]; then
            cp "$directoriobackup/estado.snar" "$directoriobackup/estado_inc.snar"
            clear
        else
            echo "No hay copia completa de la que realizar incremental, voy a realizar una copia completa"
            tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_inc.snar" "$directoriodatos"
            clear
        fi
    fi
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_inc.snar" "$directoriodatos"
    errortar=$?
    if [ $errortar = 0 ]; then
        echo "Copia Incremental completada el "$(date)" ,con el nombre $archivo y con tamaño "$($tamanofile | cut -d" " -f7) >$log
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
