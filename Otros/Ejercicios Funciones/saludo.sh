#!/bin/bash
# Multiplicar 2 números
# Define una función que pida al usuario el nombre en tiempo de ejecución. El nombre se le pasa a una función que saluda.
# Manuel González López
# Data: 15-10-2026

saludo() {
    echo "Hola, $nombre!"
}

read -p "Dime tu nombre y te saludo: " nombre

saludo
