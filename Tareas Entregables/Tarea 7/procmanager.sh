#!/bin/bash
# Tarea Entregable 7
# Manuel González López
# Data: 23-10-2026

killproceso() { # Función para poder matar procesos
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

salir() { # Función para preguntar si quieres salir del script
    clear
    read -p "¿Desas salir? (S/N): " salida
    if [ "$salida" = "s" -o "$salida" = "S" ]; then
        exit 0
    else
        clear
        continue
    fi
}

comprobarusuario() { # Función para comprobar si existe el usuario antes de hacer el informe
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

menu1() { #Opcion de menu 1, mostrar todos los procesos del sistema con less para que sea mas sencillo de leer
    ps aux | less
    salir
}

menu2() { # Comprobar si el usuario existe y sacar los procesos que abrio el mismo
    comprobarusuario
    ps -u $usuario | less
    salir
}

menu3() {
    comprobarusuario # Informe del usuario
    fecharchivo=$(date -d now +%Y%m%d%H%M)
    if [ ! -d "$HOME/informes" ]; then #Comprobamos que exista la carpeta
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
    archivo="$HOME/informes""/$fecharchivo""_procesos_"$usuario".txt" #Creamos informe
    echo "El usuario existe, creando informe"
    echo "Inicio: $fecha $hora
        Nombre del equipo: $HOSTNAME
        Usuario: $USER" >$archivo
    ps -u $usuario -o pid,user,%cpu,%mem,start,command >>$archivo
    echo "El informe se encuentra en $archivo"
    salir
}

menu4() { # Sacar los procesos de todo el sistema que mas CPU consumen
    ps x --sort=-pcpu -o pid,user,%cpu --no-headers | head | less
    salir
}

menu5() { # Buscar procesos por nombre
    read -p "Dime el nombre del proceso a buscar: " procesonombre
    ps x -o pid,user,command | grep $procesonombre | less
    #ps x -o pid,user,command -C $procesonombre | less      # Otra forma de hacerlo
    salir
}

menu6() { # Kill a los procesos
    read -p "Dime el PID del proceso a matar: " matarproceso
    killproceso
}

menu7() { # Cambiar prioridad con procesos o iniciar procesos nuevos con prioridad concreta
    read -p "Cambiar la prioridad de un proceso que ya existe (1) o iniciar uno nuevo con la prioridad que quieras (2): " niceorreniceopcion
    case $niceorreniceopcion in
    # Con esta se cambia prioridad a proceso existente
    1)
        clear
        read -p "¿A que proceso le cambiamos la prioridad?
        
        Escribe aqui: " procesoprio
        ps -p $procesoprio >/dev/null 2>&1 # Comprobamos que el proceso exista
        if [ ! $? = 0 ]; then
            clear
            echo "El Proceso especificado no existe"
            sleep 1
            salir
        else
            echo "Actualmente ese proceso tiene prioridad$(ps -p $procesoprio -o nice --no-headers)" # Informamos de la prioridad que tiene ahora y pedimos a cual quiere cambiar
            read -p "¿A cuanto le ponemos la prioridad?
        
        Escribe aqui: " prioridadpro
            renice $prioridadpro -p $procesoprio >/dev/null 2>&1
            if [ $? = 0 ]; then
                echo "Prioridad cambiada correctamente"
                sleep 3
                salir
            else
                read -p "Error, no se pudo cambiar la prioridad.

                ¿Quieres volver a intentarlo con sudo? (S/N): " sudopri # Si no funciona el cambio se da la opcion de probar usando sudo
                if [ "$sudopri" = "s" -o "$sudopri" = "S" ]; then
                    sudo renice $prioridadpro -p $procesoprio >/dev/null 2>&1
                    if [ $? = 0 ]; then
                        echo "Prioridad cambiada correctamente a$(ps -p $procesoprio -o nice --no-headers)"
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
    # Con esta se incian los procesos
    2)
        read -p "¿Que proceso iniciamos?
        
        Escribe aqui: " procesoprio
        which $procesoprio >/dev/null 2>&1 #Comprobamos si existe el proceso que se quiere iniciar
        if [ ! $? = 0 ]; then
            echo "Error, el proceso especificado no existe"
            sleep 3
            salir
        else # Preguntamos la prioridad
            read -p "¿A cuanto le ponemos la prioridad?
        
        Escribe aqui: " prioridadpro
            nice -n $prioridadpro $procesoprio >/dev/null 2>&1
            if [ $? = 0]; then
                echo "Creado correctamente el proceso"
                sleep 3
                salir
            else
                echo "Error, no se pudo crear el proceso, no se encuentra el proceso a inciar o no tienes permisos"
                sleep 3
                salir
            fi
        fi
        ;;
    esac
}
while true; do #Bucle para el script
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
    case $menu in # Case para las opciones del menu
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
