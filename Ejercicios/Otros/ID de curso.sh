#!/bin/bash
# Pedir ID de curso por parametro y no se que otra cosa por read
# Manuel González López
# Data: 2026-09-17

echo "$1 -> Codigo del Curso"

read -p "Escribe tu nombre: " nombre

if [ $1 = ]
then
    echo "Introduce un codigo de curso para continuar"
    exit 0
else
    if [ $1 = "ASO" ]
    then
        echo "Bienvenido a Administración de Sistemas Operativos, $nombre"
        exit 0
    else
        if [ $1 = "SER" ]
        then
            echo "Bienvenido a Servicios en Red, $nombre"
            exit 0
        else
            if [ $1 = "WEB" ]
            then
                echo "Bievenido a Implantación de Aplicaciones Web, $nombre"
                exit 0
            else 
            echo "Codigo desconocido"
            exit 1
            fi
        fi
    fi
fi