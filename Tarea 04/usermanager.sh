#!/bin/bash
# Tarea 01
# El Script espera en el parametro 1 el fichero (formateado asi operacion:usuario:contrasena:"nombre completo":directorio home:grupo_principal)
# y en el parametro 2 el modo de operacion (A,C,D,U)
# Manuel González López
# Data: 01-10-2026

IFS=$'\n'

creargrupo() { #Funcion para comprobar si el grupo existe y crearlo en caso de que no exista
    clear
    echo -e "Comprobando grupo $grupo"
    sleep 1
    checkgrupo=$(grep "^$grupo" /etc/group)
    if [ "$checkgrupo" = "" ]; then
        groupadd $grupo
        echo "Creado el grupo $grupo para el usuario $nombreuser" >>$archivo
    else
        echo "Error al crear el grupo $grupo" >>$archivo
    fi
}

crearuser() { #Funcion para comprobar si existe el usuario y la crearlo en caso de que no exista
    creargrupo
    echo -e "\nCreando usuario $nombreuser"
    sleep 1
    id $nombreuser >/dev/null 2>&1
    if [ $? = 0 ]; then
        echo "Error al crear el usuario $nombreuser: el usuario ya existe" >>$archivo
    else
        useradd -d $casa -m -c "$nombrecompleto" -s /bin/bash -g $grupo $nombreuser 2>/dev/null
        if [ $? = 0 ]; then
            echo "$nombreuser:$contrasena" | chpasswd
            echo "Usuario creado correctamente: $nombreuser" >>$archivo
        else
            echo "Fallo la creacion del usuario $nombreuser" >>$archivo
        fi
    fi
    clear
}

borraruser() { #Funcion para borrar el usuario
    echo -e "\nBorrando usuario $nombreuser"
    sleep 1
    userid=$(grep $nombreuser /etc/passwd | cut -d: -f3)
    if [ "$userid" = "" ]; then
        echo "Error al borrar el usuario: el usuario $nombreuser no existe" >>$archivo
    else
        if [ "$userid" -lt 1000 ]; then
            echo "Error al borrar el usuario $nombreuser: No se pueden borrar usuarios con UID menor que 1000" >>$archivo
        else
            userdel -r $nombreuser
            echo "Usuario borrado correctamente: $nombreuser" >>$archivo
        fi
    fi
    clear
}

updateuser() { #Funcion para comprobar si el usuario existe y actualizarlo si procede
    creargrupo
    echo -e "\nActualizando usuario $nombreuser"
    sleep 1
    checkuser=$(grep $nombreuser /etc/passwd)
    if [ $checkuser = "" ]; then
        echo "El usuario $nombreuser no existe" >>$archivo
    else
        usermod -d $casa -m -c "$nombrecompleto" -s /bin/bash -g $grupo $nombreuser >/dev/null
        echo "$nombreuser:$contrasena" | chpasswd
        echo "Usuario actualizado correctamente: $nombreuser" >>$archivo
    fi
    clear
}

# ---------------------------------------------------------
# Empieza el script
# ---------------------------------------------------------

echo "Script para modificar usuarios"
sleep 1

if [ "$EUID" = "0" ]; then # Comprobar ejecución con sudo
    clear
else
    echo "No se ejecuto como sudo, error 3"
    exit 3
fi

if [ $# = 1 -o $# = 0 ]; then #Comprobar que los 2 parametros estan presentes
    echo "Faltan parametros, recuerda que hacen falta 2 (el archivo y el modo de operación), error 1"
    exit 1
else
    echo "El archivo seleccionado es $1"
    echo "El modo seleccionado es $2"
    sleep 1
fi

if [ ! -f "$1" ]; then #Comprobar que el archivo existe
    echo "El archivo indicado en el 1º parametro no existe , error 4"
    exit 4
fi

logpath="/var/log/usermanager"

# El if comprueba si existe la carpeta, si la carpeta no existe, la creamos

if [ -d "$logpath" ]; then
    echo "Los logs se guardan en /var/log/usermanager"
    sleep 5
else
    mkdir /var/log/usermanager >/dev/null 2>&1
    echo "Los logs se guardan en /var/log/usermanager"
    sleep 5
fi

# Creamos las variables para mas adelante

fecha=$(date -d now +%d/%m/%Y)
hora=$(date -d now +%T)
fecharchivo=$(date -d now +%Y%m%d%H%M)
archivo="/var/log/usermanager/""$fecharchivo""_usermanager_"$RANDOM".txt"

echo "Inicio: $fecha $hora" >$archivo

#Inicio del bucle

for variablefor in $(cat $1); do

    #Variables que cambian con cada bucle

    cutcomentario=$(echo "$variablefor" | cut -c1)
    modooperacion=$(echo "$variablefor" | cut -d: -f1)
    nombreuser=$(echo "$variablefor" | cut -d: -f2)
    contrasena=$(echo "$variablefor" | cut -d: -f3)
    nombrecompleto=$(echo "$variablefor" | cut -d: -f4)
    casa=$(echo "$variablefor" | cut -d: -f5)
    grupo=$(echo "$variablefor" | cut -d: -f6)

    #Case para el modo de operacion deseado, en cada caso se implementan las funciones listadas arriba

    case $2 in
    A)
        echo -e "\nModo de operación: Todo"
        if [ "$modooperacion" = "C" ]; then
            crearuser
            continue
        else
            if [ "$modooperacion" = "D" ]; then
                borraruser
                continue
            else
                if [ "$modooperacion" = "U" ]; then
                    updateuser
                    continue
                else
                    if [ "$cutcomentario" = "#" ]; then # Como condicion extra, si se detecta un comentario lo omite
                        echo "Saltando comentario" >>$archivo
                        continue
                    else
                        echo "Error en el usuario $nombreuser"
                        continue
                    fi
                fi
            fi
        fi
        ;;
    C)
        echo -e "\nModo de operación: Crear usuario"
        if [ $modooperacion = "C" ]; then
            crearuser
        else
            if [ "$cutcomentario" = "#" ]; then # Como condicion extra, si se detecta un comentario lo omite
                echo "Saltando comentario" >>$archivo
                continue
            else
                clear
                continue
            fi
        fi
        clear
        ;;
    D)
        echo -e "\nModo de operación: Borrar usuario"
        if [ $modooperacion = "D" ]; then
            borraruser
        else
            if [ "$cutcomentario" = "#" ]; then # Como condicion extra, si se detecta un comentario lo omite
                echo "Saltando comentario" >>$archivo
                continue
            else
                clear
                continue
            fi
        fi
        clear
        ;;
    U)
        echo -e "\nModo de operación: Actualizar usuario"

        if [ $modooperacion = "U" ]; then
            updateuser
        else
            if [ "$cutcomentario" = "#" ]; then # Como condicion extra, si se detecta un comentario lo omite
                echo "Saltando comentario" >>$archivo
                continue
            else
                clear
                continue
            fi
        fi
        clear
        ;;
    *)
        echo -e "\nError, el modo de operación no es válido, error 2"
        exit 2
        ;;
    esac

done

#Fin del bucle y del script, sacamos la hora y la fecha de nuevo para poner el momento en el que acaba el script

fecha=$(date -d now +%d/%m/%Y)
hora=$(date -d now +%T)
echo "Fin: $fecha $hora" >>$archivo
