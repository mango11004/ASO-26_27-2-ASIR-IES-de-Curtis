#!/bin/bash
# Ejercicio 3 2º
# Manuel González López
# Data: 2026-09-17

read -p "Escribe algo: " cadena1
read -p "Escibre otra cosa: " cadena2

if [ "$cadena1" = "" -o "$cadena2" = "" ]
then
    echo "Escribe algo en los 2 campos, error 1"
    exit 1
else
    if [ "$cadena1" = "$cadena2" ]
    then
        echo "Son iguales"
        exit 0
    else
        if [ "$cadena1" \< "$cadena2" ]
        then
            echo "$cadena1 y $cadena2"
            exit 0
        else
            echo "$cadena2 y $cadena1"
            exit 0
        fi
    fi
fi