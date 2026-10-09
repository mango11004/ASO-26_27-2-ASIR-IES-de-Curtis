#!/bin/bash
# Ejercicio Refuerzo 5
# Manuel González López
# Data: 09-10-2026

archivo="log_downloader.txt"

directorio=$(pwd)

if [ ! -f "$archivo"]; then
    touch $archivo
fi

wget --version >/dev/null
if [ $? = 0 ]; then
    echo "INFO: wget ya esta instalado" >$archivo
else
    echo "Necesitamos instalar wget, vas a necesitar sudo"
    echo "INFO: Necesitamos instalar wget" >$archivo
    sleep 1
    read -p "¿Lo instalamos? (S/N): " opcionapt
    if [ "$opcionapt" = "N" -o "$opcionapt" = "n" ]; then
        echo "Operación cancelada por el usuario, error 1"
        echo "INFO: Operación cancelada por el usuario, error 1" >$archivo
        sleep 1
        exit 1
    else
        sudo apt update && sudo apt install wget
        wget --version >/dev/null
        if [ $? = 0 ]; then
            echo "Instalado correctamente"
            sleep 2
        else
            echo "Error en la instalación, intentalo de nuevo, error 2"
            echo "ERROR: Error en la instalación, intentalo de nuevo, error 2" >$archivo
            sleep 1
            exit 2
        fi
    fi
fi

clear

echo "Los archivos descargados se almacenan en $directorio/downloader/descargas"
sleep 1
mkdir -r ~/downloader/descargas
cd downloader/descargas

if [ $1 = ""]; then
    echo "Es necesario poner una URL en el 1º parametro, error 3"
    echo "ERROR: Es necesario poner una URL en el 1º parametro, error 3" >$archivo
    exit 3
fi

registro() {
    if [ $1 = "I" ]; then
        echo "INFO: $2"
    else
        if [ $1 = "E" ]; then
            echo "ERROR: $2"
        else
            echo "ERROR desconocido"
        fi
    fi
}
