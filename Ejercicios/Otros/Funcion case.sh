#!/bin/bash
# Test de la función case
# Manuel González López
# Data: 2026-09-24

echo "Selecciona una opcion"
echo "1. Saludo"
echo "2. Despedida"

read -n1 -p "Introduce una opción: " var

case $var in
    1)
        echo -e "\n\nHola\n"
        ;;
    2)
        echo -e "\n\nAdios\n"
        ;;
    *)
        echo -e "\n\nError, desconocido\n"
        ;;
esac