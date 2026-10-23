#!/bin/bash
# Tarea Entregable 7
# Manuel González López
# Data: 23-10-2026

while true; do
    clear
    read -p "[1] Ver todos los procesos del sistema.
[2] Ver procesos de un usuario.
[3] Generar informe de procesos en ejecución.
[4] Salir

Escoge una opción: " menu
    case $menu in
    1)
        clear
        ps au -u $USER | less
        read -p "¿Desas salir? (S/N): " salida
        if [ "$salida" = "s" -o "$salida" = "S" ]; then
            exit 0
        else
            clear
            continue
        fi
        ;;
    2)
        clear
        read -p "Dame el nombre de usuario: " usuario
        id $usuario >/dev/null 2>&1
        if [ $? = 0 ]; then
            echo "El usuario existe"
            ps -u $usuario | less
            read -p "¿Desas salir? (S/N): " salida
            if [ "$salida" = "s" -o "$salida" = "S" ]; then
                exit 0
            else
                clear
                continue
            fi
        else
            echo "El usuario no existe, volviendo al menu principal"
            sleep 3
            clear
            continue
        fi
        ;;
    3)
        
        clear
        ;;
    4)
        clear
        echo "Saliendo del script"
        exit 0
        ;;
    *)
        echo "Error, modo de operacion desconocido"
        sleep 3
        continue
        ;;
    esac
done
