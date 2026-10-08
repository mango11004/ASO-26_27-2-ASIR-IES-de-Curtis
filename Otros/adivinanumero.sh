#!/bin/bash
# Adivina numero sh
# Manuel González López
# Data: 2026-09-23

echo "Juego, adivina el número del 1 al 100"

numero=98

read -p "Dame un número: " user

until [ "$numero" = "$user" ]
do
    echo "Fallaste"
    read -p "Dame un número: " user
done

echo "Acertaste!!!"
exit 0