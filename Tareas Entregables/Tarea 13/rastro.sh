#!/bin/bash
# Tarea 13
# El script espera un parametro con el tipo de modo, el resto deberia de hacerlo solo.
# Manuel González López
# Data: 16-11-2026

fecha=$(date -d now +%Y%m%d)
log="/var/$fecha"_rastreo_"$1".txt""

if [ $# = 2 ]; then
    echo
else
    clear
    echo "Error 1, Modo de uso del script: ./rastro.sh mdizalo 2"
    exit 1
fi

if [ $EUID = 0 ]; then
    echo
else
    clear
    echo "Error 2, Ejecuta con sudo"
    exit 2
fi
id $1 >/dev/null 2>&1
if [ $? = 0 ]; then
    echo
else
    echo "Error 4, el Usuario no existe"
    exit 4
fi

case $2 in
1)
    clear
    echo "Modo de busqueda basico"
    casauser=$(cat /etc/passwd | grep $1 | cut -d: -f6)
    ls -shRa $casauser >>$log
    ;;
2)
    ruta="/var"
    clear
    echo "Modo de busqueda completo"
    sudo cat /var/log/*.log | grep $1 >>$log
    find $ruta -user $1 >>$log
    ;;
*)
    echo "Error 3, Modo de busqueda desconocido"
    exit 3
    ;;
esac
