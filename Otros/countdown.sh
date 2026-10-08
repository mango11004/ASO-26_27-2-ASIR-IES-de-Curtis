#!/bin/bash
# Pag 70 Ej 2 For
# Manuel González López
# Data: 30-09-2026

for numero in $(seq $1 -1 0)
do
    sleep 1
    echo -en "\rQuedan $numero segundos \b"
done
echo -e "\nListo"
sleep 1
clear
