#!/bin/bash
# Test de "For"
# Manuel González López
# Data: 30-09-2026

for fruta in manzana pera uva
do
echo "Me gusta la $fruta"
done


for i in $(seq 10 -1 0)
do
echo "$i"
sleep 1
done
echo "¡BOOM!"


for i in {10..0}
do
echo "$i"
done


for ((i=0; i<5; i++))
do
echo "$i"
done

for usuario in $(cut -d: -f1 /etc/passwd)
do
echo "$usuario"
done

servidores=(google.es mango11004.es 1.1.1.1)
for s in "${servidores[@]}"
do
echo
ping -c1 "$s"
done

for arg in "$@"
do
echo "Argumento: $arg"
done