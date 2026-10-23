#!/bin/bash
# Tarea Entregable 7
# Manuel González López
# Data: 23-10-2026

comprobarusuario() {
    read -p "Dame el nombre de usuario: " usuario
    id $usuario >/dev/null 2>&1
    if [ $? = 0 ]; then
        echo "El usuario existe"
    else
        echo "El usuario no existe, error 1, volviendo al menu principal"
        sleep 3
        clear
        continue
    fi
}

menu1() {
    ps aux | less
    read -p "¿Desas salir? (S/N): " salida
    if [ "$salida" = "s" -o "$salida" = "S" ]; then
        exit 0
    else
        clear
        continue
    fi
}

menu2() {
    comprobarusuario
    ps -u $usuario | less
    read -p "¿Desas salir? (S/N): " salida
    if [ "$salida" = "s" -o "$salida" = "S" ]; then
        exit 0
    else
        clear
        continue
    fi
}

menu3() {
    comprobarusuario
    fecharchivo=$(date -d now +%Y%m%d%H%M)
    if [ ! -f "$HOME/informes" ]; then
        mkdir $HOME/informes
        if [ $? = 0]; then
            echo "Carpeta creada correctamente"
        else
            echo "Error al crear la carpeta de informes, error 4"
            exit 4
        fi
    else
        echo "La carpeta $HOME/informes ya existe"

    fi
    archivo="$HOME/informes""/$fecharchivo""_procesos_"$usuario".txt"
    echo "El usuario existe, creando informe"
    echo "Inicio: $fecha $hora
        Nombre del equipo: $HOSTNAME
        Usuario: $USER" >$archivo
    ps -u $usuario -o pid,user,%cpu,%mem,start,command >>$archivo
    echo "El informe se encuentra en $archivo"
    read -p "¿Desas salir? (S/N): " salida
    if [ "$salida" = "s" -o "$salida" = "S" ]; then
        exit 0
    else
        clear
        continue
    fi
}

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
        menu1
        ;;
    2)
        clear
        menu2
        ;;
    3)
        clear
        menu3
        ;;
    4)
        clear
        echo "Saliendo del script"
        exit 0
        ;;
    *)
        echo "Error 3, modo de operacion desconocido"
        sleep 3
        continue
        ;;
    esac
done
