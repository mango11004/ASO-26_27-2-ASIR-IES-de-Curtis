#!/bin/bash
# Comparar numeros
# Manuel González López
# Data: 2026-09-17

read -p "Dame un numero: " n1
read -p "Dame otro numbero: " n2

if [ $n1 = $n2 ]
then
    echo "Son el mismo numero"
    exit 0
else
    echo "Son distintos"
    read -p "¿La version extendida? S/N: " q
    if [ q = N ]
    then
        echo ":("
    else
        if [ $n1 -gt $n2 ]
        then
            echo "El 1º número es mayor que el 2º"
        else
            if [ $n1 -lt $n2 ]
            then
                echo "El 2º número es mayor que el 1º"
            else
                echo "Error desconocido"
            fi
        fi
    fi
fi

