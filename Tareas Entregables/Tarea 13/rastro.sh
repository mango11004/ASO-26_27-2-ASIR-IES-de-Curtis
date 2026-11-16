#!/bin/bash
# Tarea 13
# El script espera un parametro con el tipo de modo, el resto deberia de hacerlo solo.
# Manuel González López
# Data: 16-11-2026

$fecha=$(date -d now +%Y%m%d)
$log="/var/$fecha"_rastreo_"$1".txt""

if [ $# = 2 ]; then
    echo ""
else
    echo "Error 1, Modo de uso del script: ./rastro.sh mdizalo 2"
    exit 1
fi

case $2 in
1)
    echo "Modo de busqueda basico"
    casauser=$(cat /etc/passwd | grep $1 | cut -d: -f6)
    ls -shRa $casauser >$log
    ;;
2)
    echo "Modo de busqueda completo"
    ;;
*)
    echo "Modo de busqueda desconocido"
    ;;
esac
