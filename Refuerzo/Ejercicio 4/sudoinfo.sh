#!/bin/bash
# Ejercicio Refuerzo 4
# Manuel González López
# Data: 14-10-2026

echo "Script logs sudo"
sleep 1

if [ $EUID = 0 ]; then
    clear
else
    echo "Recuerda que debes ejecutar el script como sudo, error 1"
    exit 1
fi

if [ "$1" = "" ]; then
    echo "Recuerda que debes poner en el parametro 1 la ubicación del archivo con los logs, error 5"
    exit 5
else
    if [ ! -f "$1" ]; then
        echo "El fichero no existe, error 6"
        exit 6
    else
        cat $1 >/dev/null 2>&1
        if [ $? = 0 ]; then
            clear
        else
            echo "No se puede leer el fichero, error 7"
            exit 7
        fi
    fi
fi

while true; do

    read -p "---- SUDOINFO ----
    1. Resumen del fichero
    2. Usuarios que han usado sudo
    3. Tres comandos más usados
    4. Intentos fallidos
    5. Entradas de un usuario
    6. Últimas entradas
    7. Guardar un informe en infosudo.txt
    0. Salir
    
    Escribe la opción: " opcion

    case $opcion in
    1) ;;
    2) ;;
    3) ;;
    4) ;;
    5) ;;
    6) ;;
    7) ;;
    0)
        clear
        echo "Saliendo del script"
        sleep 1
        exit 0
        ;;
    *)
        clear
        echo "Opcion desconocida"
        sleep 2
        clear
        ;;
    esac
done
