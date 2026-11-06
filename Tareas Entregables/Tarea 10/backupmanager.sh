#!/bin/bash
# Tarea 10
# El script espera un parametro con el tipo de modo, el resto deberia de hacerlo solo.
# Manuel González López
# Data: 04-11-2026

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

if [ -d "$directoriodatos" ]; then # Comprobar si existe el directorio de datos y crearlo
    clear
else
    mkdir -p $directoriodatos >/dev/null 2>&1
    if [ $? = 0 ]; then
        clear
    else
        echo "No se pudo crear el directorio, error 8"
        exit 8
    fi
fi

if [ -f $log ]; then
    clear
else
    touch $log
fi

if [ -f "$directoriobackup/estado.snar" ]; then
    echo "INFO: La última copia de seguridad completa fue realizada el "$(stat -c %w $directoriobackup/estado.snar | cut -d. -f1)
    sleep 3
else
    echo "INFO: No existe ninguna copia de seguridad completa"
    sleep 3
fi

case $1 in # Case para el tipo de la copia que hay que hacer
C)
    archivo=$fecharchivo"_copia_completa.tar.gz"
    echo "Modo seleccionado: Copia Completa"
    sleep 2
    echo "Para hacer la copia debemos de borrar todos los estado.snar" # Tenemos que borrar los archivos snar para evitar conflictos y que las otras copias se realicen partiendo de la última completa
    sleep 2
    rm -rf $directoriobackup/estado.snar
    rm -rf $directoriobackup/estado_dif.snar
    rm -rf $directoriobackup/estado_inc.snar
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos" >/dev/null 2>&1 # Hacemos la copia
    errortar=$?                                                                                                                   # Controlamos el error del tar
    if [ $errortar = 0 ]; then
        tamanofile=$(ls -sh $directoriobackup/$archivo | tail -n1 | cut -d" " -f1)
        echo "Copia Completa finalizada el "$(date)", con el nombre $archivo y con tamaño $tamanofile" >$log
        echo "Copia Completa finalizada, archivo con nombre $directoriobackup/$archivo"
        scp -i /root/.ssh/id_ed25519 $directoriobackup/$archivo root@10.0.9.1:/home/aso/backup/ >/dev/null 2>&1
        exit 0
    else
        echo "Fallo la copia de seguridad con error $errortar" # Damos el error del tar
        echo "Error 4 del script"
        exit 4
    fi
    ;;

D)
    echo "Modo seleccionado: Copia Diferencial"
    sleep 2
    if [ -f "$directoriobackup/estado.snar" ]; then
        cp "$directoriobackup/estado.snar" "$directoriobackup/estado_dif.snar" # Comprobamos si existe estado.snar y copiamos a dif
    else
        echo "Voy a realizar una copia completa"
        sleep 2
        archivo=$fecharchivo"_copia_completa.tar.gz"
        tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos" >/dev/null 2>&1 # Realizamos una copia completa si no existia una previamente
        errortar=$?
        if [ $errortar = 0 ]; then
            tamanofile=$(ls -sh $directoriobackup/$archivo | tail -n1 | cut -d" " -f1)
            echo "Copia Completa finalizada el "$(date)", con el nombre $archivo y con tamaño $tamanofile" >$log # Linea para el log
            echo "Copia Completa finalizada, archivo con nombre $directoriobackup/$archivo"
            scp -i /root/.ssh/id_ed25519 $directoriobackup/$archivo root@10.0.9.1:/home/aso/backup/ >/dev/null 2>&1
        else
            echo "Fallo la copia de seguridad con error $errortar"
            echo "Error 4 del script"
            exit 4
        fi
        sleep 2
        cp "$directoriobackup/estado.snar" "$directoriobackup/estado_dif.snar" # Copiamos el nuevo estado.snar para que se pueda hacer la copia
    fi
    archivo=$fecharchivo"_copia_diferencial.tar.gz"
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_dif.snar" "$directoriodatos" >/dev/null 2>&1 # Hacemos copia diferencial
    errortar=$?
    if [ $errortar = 0 ]; then
        tamanofile=$(ls -sh $directoriobackup/$archivo | tail -n1 | cut -d" " -f1)
        echo "Copia Diferencial finalizada el "$(date)", con el nombre $archivo y con tamaño $tamanofile" >$log # Linea para el log
        echo "Copia Diferencial finalizada, archivo con nombre $directoriobackup/$archivo"
        scp -i /root/.ssh/id_ed25519 $directoriobackup/$archivo root@10.0.9.1:/home/aso/backup/ >/dev/null 2>&1
        exit 0
    else
        echo "Fallo la copia de seguridad con error $errortar"
        echo "Error 4 del script"
        exit 4
    fi
    ;;

I)
    echo "Modo seleccionado: Copia Incremental"
    sleep 2
    if [ -f "$directoriobackup/estado_inc.snar" ]; then # Comprobamos si existe estado_inc
        echo
    else
        if [ -f "$directoriobackup/estado.snar" ]; then # Si no existe, pero exite estado.snar se copia
            cp "$directoriobackup/estado.snar" "$directoriobackup/estado_inc.snar"
        else
            echo "Voy a realizar una copia completa" # Si no existe estado.snar tampoco, entonces hacemos una copia completa
            sleep 2
            archivo=$fecharchivo"_copia_completa.tar.gz"
            tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado.snar" "$directoriodatos" >/dev/null 2>&1 # Realizamos una copia completa si no existia una previamente
            errortar=$?
            if [ $errortar = 0 ]; then
                tamanofile=$(ls -sh $directoriobackup/$archivo | tail -n1 | cut -d" " -f1)
                echo "Copia Completa finalizada el "$(date)", con el nombre $archivo y con tamaño $tamanofile" >$log
                echo "Copia Completa finalizada, archivo con nombre $directoriobackup/$archivo"
                scp -i /root/.ssh/id_ed25519 $directoriobackup/$archivo root@10.0.9.1:/home/aso/backup/ >/dev/null 2>&1
            else
                echo "Fallo la copia de seguridad con error $errortar"
                echo "Error 4 del script"
                exit 4
            fi
            sleep 2
            cp "$directoriobackup/estado.snar" "$directoriobackup/estado_inc.snar" # Copiamos el nuevo estado.snar para que se pueda hacer la copia
        fi
    fi
    archivo=$fecharchivo"_copia_incremental.tar.gz"
    tar -czf "$directoriobackup/$archivo" --listed-incremental="$directoriobackup/estado_inc.snar" "$directoriodatos" >/dev/null 2>&1 # Realizamos la copia incremental
    errortar=$?
    if [ $errortar = 0 ]; then
        tamanofile=$(ls -sh $directoriobackup/$archivo | tail -n1 | cut -d" " -f1)
        echo "Copia Incremental finalizada el "$(date)", con el nombre $archivo y con tamaño $tamanofile" >$log
        echo "Copia Incremental finalizada, archivo con nombre $directoriobackup/$archivo"
        scp -i /root/.ssh/id_ed25519 $directoriobackup/$archivo root@10.0.9.1:/home/aso/backup/ >/dev/null 2>&1
        exit 0
    else
        echo "Fallo la copia de seguridad con error $errortar"
        echo "Error 4 del script"
        exit 4
    fi
    ;;

*)
    echo "Modo de operación no reconocido, error 1" # Controlamos el modo de operacion
    exit 1
    ;;

esac

echo "Ejecución finalizada, saliendo del script" # Fin del script
exit 0
