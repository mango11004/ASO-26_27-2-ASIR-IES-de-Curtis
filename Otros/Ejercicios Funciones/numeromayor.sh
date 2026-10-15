#!/bin/bash
# Multiplicar 2 números
# Se le piden dos números al usuario en tiempo de ejecución. Los números se pasan a una función que devuelve el más alto (echo).
# Manuel González López
# Data: 15-10-2026

comparar() {
    if [ "$numero1" = "$numero2" ]; then
        return 0
    else
        if [ "$numero1" -gt "$numero2" ]; then
            return 1
        else
            return 2
        fi
    fi

}

read -p "Dime el 1º número: " numero1
read -p "Dime el 2º número: " numero2

comparar

case $? in
0)
    echo "Son iguales"
    ;;
1)
    echo "$numero1 es mas grande que $numero2"
    ;;
2)
    echo "$numero2 es mas grande que $numero1"
    ;;
esac
