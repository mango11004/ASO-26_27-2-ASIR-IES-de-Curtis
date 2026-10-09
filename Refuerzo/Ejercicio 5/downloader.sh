#!/bin/bash
# Ejercicio Refuerzo 5
# Manuel González López
# Data: 09-10-2026

registro() {
    fecha=$(date -d now +%d/%m/%Y)
    hora=$(date -d now +%T)
    if [ $1 = "I" ]; then
        echo "INFO ($fecha $hora): $2" >$archivo
    else
        if [ $1 = "E" ]; then
            echo "ERROR ($fecha $hora): $2" >$archivo
        else
            echo "ERROR ($fecha $hora) desconocido" >$archivo
        fi
    fi
}

archivo="log_downloader.txt"

directorio=$(pwd)

if [ ! -f "$archivo"]; then
    touch $archivo
fi

wget --version >/dev/null
if [ $? = 0 ]; then
    registro I "wget ya esta instalado"
else
    echo "Necesitamos instalar wget, vas a necesitar sudo"
    registro I "Necesitamos instalar wget"
    sleep 1
    read -p "¿Lo instalamos? (S/N): " opcionapt
    if [ "$opcionapt" = "N" -o "$opcionapt" = "n" ]; then
        echo "Operación cancelada por el usuario, error 1"
        registro I "Operación cancelada por el usuario, error 1"
        sleep 1
        exit 1
    else
        sudo apt update && sudo apt install wget
        wget --version >/dev/null
        if [ $? = 0 ]; then
            echo "Instalado correctamente"
            sleep 2
        else
            echo "Error en la instalación, intentalo de nuevo, error 2"
            registro E "Error en la instalación, intentalo de nuevo, error 2"
            sleep 1
            exit 2
        fi
    fi
fi

clear

echo "Los archivos descargados se almacenan en $directorio/downloader/descargas"
sleep 1
ls downloader/descargas
if [ $? = 0 ]; then
    mkdir -p $directorio/downloader/descargas
    cd $directorio/downloader/descargas
else
    cd $directorio/downloader/descargas
fi

if [ $1 = ""]; then
    echo "Es necesario poner una URL en el 1º parametro, error 3"
    registro E "Es necesario poner una URL en el 1º parametro, error 3"
    exit 3
fi

echo "Comprobando si la URL ($1) es valida"

registro I "Se va a descargar la URL $1"

wget --spider $1
if [ $? = 0]; then
    registro I "La URL ($1) es valida"
    echo "La URL es valida"
else
    registro E "La URL ($2) no es valida, error 4"
    echo "La URL no es valida"
    exit 4
fi

wget -q -p $directorio/downloader/descargas $1

case $? in
0)
    registro I "Todo correcto"
    registro I "Fin de ejecución"
    return 0
    ;;
1)
    registro E "Error generico"
    registro I "Fin de ejecución"
    return 1
    ;;
2)
    registro E "Error al interpretar las opciones de la línea de órdenes"
    registro I "Fin de ejecución"
    return 2
    ;;
3)
    registro E "Error de entrada/salida de fichero (por ejemplo, no se puede escribir en el disco)"
    registro I "Fin de ejecución"
    return 3
    ;;
4)
    registro E "Fallo de red (por ejemplo, el dominio no existe o no hay conexión)"
    registro I "Fin de ejecución"
    return 4
    ;;
5)
    registro E "Fallo en la verificación SSL/TLS (certificado)"
    registro I "Fin de ejecución"
    return 5
    ;;
6)
    registro E "Fallo de autenticación (usuario o contraseña)"
    registro I "Fin de ejecución"
    return 6
    ;;
7)
    registro E "Error de protocolo"
    registro I "Fin de ejecución"
    return 7
    ;;
8)
    registro E "El servidor ha respondido con un error (por ejemplo, 404, página no encontrada)"
    registro I "Fin de ejecución"
    return 8
    ;;
esac
