#!/bin/bash
# Pag 70 Ej 3 For
# Manuel González López
# Data: 30-09-2026

IFS=$'\n'
for usuario in $(cut -d: -f1 /etc/passwd)
do 
    directorio=$(grep "^$usuario" /etc/passwd | cut -d: -f6)
    #directorio=$(cut -d: -f6 /etc/passwd | grep -w "^$usuario")
    echo "Usuario: $usuario - Directorio: $directorio"
    sleep 1
done