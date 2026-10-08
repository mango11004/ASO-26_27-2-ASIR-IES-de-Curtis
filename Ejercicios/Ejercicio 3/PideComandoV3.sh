#!/bin/bash
# Ejercicio 3 1º
# Manuel González López
# Data: 2026-09-17

read -p "Dame un comando: " comando

if [ -z "$comando" ]
then
    echo "Error 1, no puede estar vacio"
    exit 1
else
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
            echo "Ejecución correcta al fin"
            exit 0
        else
            echo "Ejecución erronea. No te pido más comandos, error 2"
            exit 2
        fi
    fi
fi