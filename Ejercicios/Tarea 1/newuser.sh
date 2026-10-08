#!/bin/bash
# Tarea 01 (Facilitar la creación de usuarios en Linux)
# Manuel González López
# Data: 21-09-2026

#Comprobar si se ejecuta como root
if [ $EUID = 0 ]
then
    echo "Script para creación de Usuarios"
else
    echo "Debes ejecutar el script como sudo, error 3"
    exit 3
fi

#Pedir los datos
read -p "Escribe el nombre completo del usuario: " nombre
read -p "Escribe el nombre de usuario para iniciar sesión: " usuario
read -p "Escribe la ruta del directorio de trabajo: " trabajo
read -p "Escribe la contraseña: " pass

#Comprobación de que el usuario es nuevo y no existia previamente
check=$(grep -c $usuario /etc/passwd)

if [ $check = "1" ]
then
    echo "Ya existe el usuario, error 5"
    exit 5
else
    echo ""
fi

#Confirmar que los datos son correctos
read -p "Confirma que los datos son correctos:
Nombre Completo -> $nombre
Usuario -> $usuario
Directorio de trabajo -> $trabajo
(S/N): " con

#Una vez confirmados los datos, procedemos
if [ $con = "s" -o $con = "S" ]
then
    echo "Procedemos con la creación"
else
    echo "Cancelado por el usuario, error 1"
    exit 1
fi

#Comprobamos si existe el directorio de trabajo
cd $trabajo 2> /dev/null

#Si el comando funciona bien, entonces vemos que el directorio existe, si no, le pedimos al usuario crearlo
if [ $? = 0 ]
then
    echo "El directorio de trabajo existe, creando usuario"
    useradd -c "$nombre" -d $trabajo $usuario #Creamos el usuario
    echo "$usuario:$pass" | chpasswd #Cambiamos la contraseña
else
    read -p "El directorio de trabajo no existe. ¿Quieres crearlo? (S/N): " con1
    if [ $con1 = "S" -o $con1 = "s" ]
    then
    mkdir -p $trabajo
    useradd -c "$nombre" -d $trabajo $usuario #Creamos el usuario
    echo "$usuario:$pass" | chpasswd #Cambiamos la contraseña
    else
    echo "Vuelve a ejecutar el script cambiando el directorio de trabajo, error 2"
    exit 2
    fi
fi

contador=$(grep -c $usuario /etc/passwd)

#Comprobación de que se creo correctamente
if [ $contador = "1" ]
then
    echo "Todo correcto"
else
    echo "La comprobación a fallado, error 4"
    exit 4
fi

#Borrar el Usuario para las pruebas

#read -p "Quieres borrar el usuario (S/N): " borrar
#if [ $borrar = "S" -o $borrar = "s" ]
#then
#    userdel $usuario
#    rm -rf $trabajo
#    exit 0
#else
#    echo "Todo listo"
#    exit 0
#fi


#Fin del script 