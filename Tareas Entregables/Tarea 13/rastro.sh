#!/bin/bash
# Tarea 13
# El script espera un parametro con el tipo de modo, el resto deberia de hacerlo solo.
# Manuel González López
# Data: 16-11-2026

if [ $# = 2 ]; then
    echo ""
else
    echo "Modo de uso del script: ./rastro.sh mdizalo 2"
    exit 1
fi
