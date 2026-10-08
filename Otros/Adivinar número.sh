#!/bin/bash
# Advinar número
# Manuel González López
# Data: 2026-09-17

read -p "Escoge un número: " n2

n1=5

if [ $n1 -eq $n2 ]
then
    echo "Acertaste felicidades"
    exit 0
else
    echo "Fallaste, vuelve a intentarlo"
    exit 0
fi