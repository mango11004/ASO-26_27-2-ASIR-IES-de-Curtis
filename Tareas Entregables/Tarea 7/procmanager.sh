#!/bin/bash
# Tarea Entregable 7
# Manuel González López
# Data: 23-10-2026

salir() {
    clear
    read -p "¿Desas salir? (S/N): " salida
    if [ "$salida" = "s" -o "$salida" = "S" ]; then
        exit 0
    else
        clear
        continue
    fi
}

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
    salir
}

menu2() {
    comprobarusuario
    ps -u $usuario | less
    salir
}

menu3() {
    comprobarusuario
    fecharchivo=$(date -d now +%Y%m%d%H%M)
    if [ ! -d "$HOME/informes" ]; then
        mkdir "$HOME/informes"
        if [ $? = 0 ]; then
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
    salir
}

menu4() {
    ps x --sort=-pcpu -o pid,user,%cpu --no-headers | head | less
    salir
}

menu5() {
    read -p "Dime el nombre del proceso a buscar: " procesonombre
    ps x -o pid,user,command | grep $procesonombre | less
    #ps x -o pid,user,command -C $procesonombre | less      # Otra forma de hacerlo
    salir
}

menu6() {
    read -p "Dime el PID del proceso a matar: " matarproceso
    ps -p $matarproceso >/dev/null 2>&1
    if [ ! $? = 0 ]; then
        echo "El Proceso especificado no existe"
        sleep 1
        salir
    else
        kill $matarproceso >/dev/null 2>&1
        if [ $? = 0 ]; then
            echo "El proceso se cerro correctamente"
            sleep 1
            salir
        else
            echo "Error cerrando el proceso"
            sleep 1
            salir
        fi
    fi
}

menu7() {
    read -p "Cambiar la prioridad de un proceso que ya existe (1) o iniciar uno nuevo con la prioridad que quieras (2): " niceorreniceopcion
    case $niceorreniceopcion in
    1)
        clear
        read -p "¿A que proceso le cambiamos la prioridad?
        
        Escribe aqui: " procesoprio
        ps -p $procesoprio >/dev/null 2>&1
        if [ ! $? = 0 ]; then
            clear
            echo "El Proceso especificado no existe"
            sleep 1
            salir
        else
            echo "Actualmente ese proceso tiene prioridad$(ps -p $procesoprio -o nice --no-headers)"
            read -p "¿A cuanto le ponemos la prioridad?
        
        Escribe aqui: " prioridadpro
            renice $prioridadpro -p $procesoprio >/dev/null 2>&1
            if [ $? = 0 ]; then
                echo "Prioridad cambiada correctamente"
                sleep 3
                salir
            else
                read -p "No se pudo cambiar la prioridad.

                ¿Quieres volver a intentarlo con sudo? (S/N): " sudopri
                if [ "$sudopri" = "s" -o "$sudopri" = "S" ]; then
                    sudo renice $prioridadpro -p $procesoprio >/dev/null 2>&1
                    if [ $? = 0 ]; then
                        echo "Prioridad cambiada correctamente"
                        sleep 3
                        salir
                    else
                        echo "Error al cambiar la prioridad"
                        salir
                    fi
                else
                    echo "No se reintenta con sudo"
                    salir
                fi
            fi
        fi
        ;;
    2)
        read -p "¿Que proceso iniciamos?
        
        Escribe aqui: " procesoprio
        read -p "¿A cuanto le ponemos la prioridad?
        
        Escribe aqui: " prioridadpro
        nice -n $prioridadpro $procesoprio
        if [ $? = 0]; then
            echo "Creado correctamente el proceso"
        else
            echo "No se pudo crear el proceso, no se encuentra el proceso a inciar o no tienes permisos"
        fi
        ;;
    esac
}
while true; do
    clear
    read -p "[1] Ver todos los procesos del sistema.
[2] Ver procesos de un usuario.
[3] Generar informe de procesos en ejecución.
[4] Mostrar los 10 procesos que más CPU consumen.
[5] Buscar información de un proceso por nombre.
[6] Terminar un proceso.
[7] Cambiar la prioridad de un proceso.
[8] Salir

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
        menu4
        ;;
    5)
        clear
        menu5
        ;;
    6)
        clear
        menu6
        ;;
    7)
        clear
        menu7
        ;;
    8)
        clear
        echo "Saliendo del script"
        exit 0
        ;;
    *)
        echo "Error 3, modo de operacion desconocido"
        sleep 1
        continue
        ;;
    esac
done
