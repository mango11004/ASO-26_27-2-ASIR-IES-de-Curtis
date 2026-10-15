#!/bin/bash
# Multiplicar 2 números
# Crear funcion multiplicar que acepta 2 numeros y los multiplica
# Manuel González López
# Data: 15-10-2026

multiplicar() {
    if [ $# -eq 2 ]; then
        echo $(($1 * $2)) 2>/dev/null
        return 0
    else
        return 1
    fi
}

multiplicacion=$(multiplicar $1 $2)

if [ $? = 0 ]; then
    echo "Se va a multiplicar $1 * $2"
    echo "El resultado es: $multiplicacion"
else
    echo "Hacen falta 2 números para la mutliplicacion"
fi
