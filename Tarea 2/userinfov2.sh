#!/bin/bash
# Tarea 2 (userinfo)
# Manuel González López
# Data: 2026-09-24

usuario="$1"

#Bucle, hasta que el usuario cancele poniendo N/n

    echo "Script para buscar info sobre usuario $usuario"
    

#Comprobamos que el usuario existe

    id $1 &> /dev/null

#Si existe procedemos

    if [ $? = 0 ]
    then
        fecha=$(date -d now +%Y%m%d) #Sacamos la fecha para el archivo
        nombre=$(grep -w $usuario /etc/passwd | cut -d : -f 5) #Sacamos el nombre completo
        directorio=$(grep -w $usuario /etc/passwd | cut -d : -f 6) #Sacamos el directorio
        idusuario=$(grep -w $usuario /etc/passwd | cut -d : -f 3) #Sacamos el id del usuario
        grupo=$(grep -w $usuario /etc/passwd | cut -d : -f 4) #Sacamos el grupo principal
        grupo2=$(groups $usuario | cut -d : -f 2) #Sacamos los grupos secundarios
        comandos=$(grep -w $usuario /etc/passwd | cut -d : -f 7) #Sacamos el interprete de comandos

#Sacamos la información por pantalla

        echo -e "\nInformación del usuario: $user
        ---------------------------------------------------------------
        Usuario: $user
        Nombre: $nombre
        Directorio de trabajo: $directorio
        Id. Usuario: $idusuario
        Grupo principal: $grupo
        Grupo secundario:$grupo2
        Interprete de comandos: $comandos"

#Sacamos la info por el archivo con la fecha

        echo "Información del usuario: $user
        ---------------------------------------------------------------
        Usuario: $user
        Nombre: $nombre
        Directorio de trabajo: $directorio
        Id. Usuario: $idusuario
        Grupo principal: $grupo
        Grupo secundario:$grupo2
        Interprete de comandos: $comandos" > $fecha"_userinfo_"$user.txt

    else
        echo "El usuario no existe, error 1"
        exit 1
    fi