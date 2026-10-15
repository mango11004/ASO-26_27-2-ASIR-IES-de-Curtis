#!/bin/bash
# Ejecuta Comando Variable
# Manuel González López
# Data: 2026-09-17

read -p "Dame el comando: " comando

read -p "Dame la ruta para la salida: " ruta

echo "Voy a poner la salida del comando $comando en el archivo $ruta"

$comando >> $ruta

if [ $? = 0 ]
then
    echo "Todo correcto (0)"
    exit 0
else
    echo "Error $?"
    exit $?
fi