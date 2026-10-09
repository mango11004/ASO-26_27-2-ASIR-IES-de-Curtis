#!/bin/bash
# Ejercicio Refuerzo 5
# Manuel González López
# Data: 09-10-2026

wget --version >/dev/null
if [ $? = 0 ]; then
    echo "wget ya esta instalado"
else
    echo "Necesitamos instalar wget, vas a necesitar sudo"
    sleep 1
    read -p "¿Lo instalamos? (S/N): " opcionapt
    if [ "$opcionapt" = "N" -o "$opcionapt" = "n" ]; then
        echo "Operación cancelada por el usuario, error 1"
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
            sleep 1
            exit 2
        fi
    fi
fi

clear

directorio=$(pwd)

echo "Los archivos descargados se almacenan en $directorio/downloader/descargas"
sleep 1
mkdir -r ~/downloader/descargas
