#!/bin/bash
# Parametro (1 txt y 2 cadena a buscar)
# Manuel González López
# Data: 2026-09-17

if [ $# = 2 ]
then

echo "El archivo de texto es: $1"

echo "La cadena a buscar es: $2"

cat $1 | grep -c $2

exit 0

else
    echo "El comando requiere 2 parametros"
    exit 2
fi