#!/bin/bash
# Ejercicio 2
# Manuel González López
# Data: 2026-09-17

read -p "Dame un comando: " comando
$comando
if [ $? = 0 ]
then
    echo "Ejecución correcta"
    exit 0
else
    read -p "Ejecución erronea, vuelve a escribir el comando: " comando2
    $comando2
    if [ $? = 0 ]
    then
        echo "Ejecución correcta al 2º intento"
        exit 0
    else
        echo "Ejecución erronea. No te pido más comandos, error 1"
        exit 1
    fi
fi