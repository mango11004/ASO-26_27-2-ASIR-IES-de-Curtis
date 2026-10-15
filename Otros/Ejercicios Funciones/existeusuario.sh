#!/bin/bash
# Multiplicar 2 números
# Script con una función a la que se le pasa el nombre de usuario y devuelve 1 si existe y 0 si no existe (return).
# Manuel González López
# Data: 15-10-2026

comprobar_user() {
    id $nombreuser >/dev/null 2>&1
    if [ $? = 0 ]; then
        return 1
    else
        return 0
    fi
}

read -p "Dime el nombre de usuario a comprobar: " nombreuser

comprobar_user

case $? in
0)
    echo "El usuario ($nombreuser) no existe"
    ;;
1)
    echo "El usuario ($nombreuser) existe"
    ;;
esac
