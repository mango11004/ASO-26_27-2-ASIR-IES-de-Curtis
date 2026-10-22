#!/bin/bash
# Test de red
# Manuel González López
# Data: 19-10-2026

ping 8.8.8.8 >/dev/null 2>&1

if [ $? = 0 ]; then
    echo "CORRECTO"
else
    echo "INCORRECTO"
fi

