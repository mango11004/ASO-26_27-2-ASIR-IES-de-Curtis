#!/bin/bash
# Ejecuta Comando Parametro
# Manuel González López
# Data: 2026-09-17

echo "El comando introducido es: $1"

echo "La ruta para la salida del comando es $2"

$1 >> $2

echo "El codigo de salida del comando fue $?"

exit