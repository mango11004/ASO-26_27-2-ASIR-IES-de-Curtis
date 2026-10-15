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
    # 1) Resumen del fichero: Muestra cuántas entradas tiene el registro, su tamaño y la fecha de la primera y la última. Comandos: wc -l, wc -c, head, tail, cut
    1)
        clear
        echo "Resumen del fichero"
        echo "Entradas: $(cat $1 | wc -l)"
        echo "Tamaño: $(cat $1 | wc -c)"
        echo "Fecha de la primera $(head -n 1 $1 | cut -c 1-16)"
        echo "Fecha de la última $(tail -n 3 $1 | head -n 1 | cut -c 1-16)"
        read -p "¿Continuar? (S/N): " continuar
        if [ "$continuar" = "N" -o "$continuar" = "n" ]; then
            exit 0
        else
            continue
        fi
        ;;

    2) ;; # 2) Usuarios que han usado sudo: Muestra cuántas veces ha usado sudo cada usuario, de más a menos. Comandos: cut -d: -f4, tr, sort, uniq -c, sort -nr

    3) ;; # 3) Tres comandos más usados: Muestra los tres comandos más ejecutados con sudo, sin sus argumentos. Comandos: grep -o "COMMAND=.*", cut, sort, uniq -c, sort -nr, head

    4) ;; # 4) Intentos fallidos: Cuenta los fallos de cada tipo (contraseña incorrecta y usuario fuera de sudoers) y lista las líneas numeradas. Comandos: grep -c

    5) ;; # 5) Entradas de un usuario: Pide un usuario y muestra cuántas entradas tiene y cuáles son. Si no aparece, lo avisa. Comandos: read -p, grep -c -F, grep -F

    6) ;; # 6) Últimas entradas: Pide cuántas entradas se quieren ver y las muestra. Hay que comprobar que se ha escrito un número. Comandos: read -p, tail -n

    7) ;; # 7) Guardar un informe en infosudo.txt Guarda en el fichero un resumen con el resultado de varias opciones, reutilizando las funciones ya creadas. Comandos: { ... } > fichero, date

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
