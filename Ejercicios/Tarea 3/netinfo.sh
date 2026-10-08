#!/bin/bash
# Información y pruebas de la red
# Manuel González López
# Data: 21-09-2026

until [ "$opcion" = "S" -o "$opcion" = "s" ] 
do

    clear #Limpiar el terminal para que salga el menu solo

    echo "--------------------- INFONET --------------------
    [ 1 ] Nombre del equipo
    [ 2 ] Dirección IP
    [ 3 ] Puerta de enlace
    [ 4 ] Servidor DNS
    [ 5 ] Probar acceso a una página web
    [ 6 ] Prueba de velocidad
    [ S ] Salir
    -----------------------------------------------------" #Menu

    read -n1 -p "Selecciona una opción (1-6): " opcion #Escoger opcion del menu
    echo ""

    case $opcion in #Opciones del menu
        1)
            hostname=$(hostname)
            if [ $? = 0 ]
            then
                echo "Nombre del equipo: $hostname" #Hostname para conseguir el nombre del equipo
            else
                echo "Error desconocido"
            fi            
        ;;
        2)
            ip=$(ip -4 addr show enp0s3 | grep inet | cut -d ' ' -f 6 | cut -d / -f 1) #Sacar la IP del equipo
            if [ $? = 0 ]
            then
                echo "La IP del equipo es $ip"
            else
                echo "Error desconocido"
            fi
        ;;
        3)
            puertaenlace=$(ip route | grep defaul | cut -d ' ' -f 3) #Puerta de enlace
            if [ $? = 0 ]
            then
                echo "La puerta de enlace del equipo es $puertaenlace"
            else
                echo "Error desconocido"
            fi
        ;;
        4)
            dnsserver=$(cat /etc/resolv.conf | grep nameserver | cut -d r -f 3) #Servidores DNS
            if [ $? = 0 ]
            then
                echo "Los servidores dns del equipo son$dnsserver"
            else
                echo "Error desconocido"
            fi
        ;;
        5)
            read -t 60 -p "Dime la web con la que quieres probar la conexión: " direccion #Ping para probar la conexión
            ping -c 3 -W 2 $direccion > /dev/null 2>&1
            if [ $? = 0 ]
            then
                echo "La conexión funciona"
            else
                echo -e "\nLa conexión falla, error 1"
            fi
        ;;
        6)
            speedtest-cli --version > /dev/null 2>&1 #Comprobar si esta instalado 
            if [ $? = 0 ]
            then
                echo "Realizando test de velocidad (ten paciencia)" #Hacer test de velocidad
                speedtest-cli --simple
            else
                echo "Tenemos que instalar la utilidad speedtest-cli" #Instalar el test de velocidad y despues hacerlo
                read -p "¿Quieres instalarlo? (S/N)" instalar
                if [ "$instalar" = "S" -o "$instalar" = "s" ]
                then
                    sudo apt install speedtest-cli > /dev/null 2>&1
                    echo "Listo, instalado"
                    echo "Realizando test de velocidad (ten paciencia)"
                    speedtest-cli --simple
                else
                    echo "No se puede realizar la instalación, error 3"
                fi
            fi
        ;;
        S)
            echo "Saliendo del script"
            exit 0
        ;;
        s)
            echo "Saliendo del script"
            exit 0
        ;;
        *)
        echo "Opcion no valida, error 2"
        ;;
    esac

    read -p "Presiona Enter para continuar" enter

done