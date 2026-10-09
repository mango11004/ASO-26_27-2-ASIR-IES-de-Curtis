#!/bin/bash
# Ejercicio Refuerzo 5
# Manuel González López
# Data: 09-10-2026

registro() {
    fecha=$(date -d now +%d/%m/%Y)
    hora=$(date -d now +%T)
    if [ $1 = "I" ]; then
        echo "INFO ($fecha $hora): $2" >$archivo
    else
        if [ $1 = "E" ]; then
            echo "ERROR ($fecha $hora): $2" >$archivo
        else
            echo "ERROR ($fecha $hora) desconocido" >$archivo
        fi
    fi
}

archivo="log_downloader.txt"

directorio=$(pwd)

if [ ! -f "$archivo"]; then
    touch $archivo
fi

wget --version >/dev/null
if [ $? = 0 ]; then
    registro I "wget ya esta instalado"
else
    echo "Necesitamos instalar wget, vas a necesitar sudo"
    registro I "Necesitamos instalar wget"
    sleep 1
    read -p "¿Lo instalamos? (S/N): " opcionapt
    if [ "$opcionapt" = "N" -o "$opcionapt" = "n" ]; then
        echo "Operación cancelada por el usuario, error 1"
        registro I "Operación cancelada por el usuario, error 1"
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
            registro E "Error en la instalación, intentalo de nuevo, error 2"
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
