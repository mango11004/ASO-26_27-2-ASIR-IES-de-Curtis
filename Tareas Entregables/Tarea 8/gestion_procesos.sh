#!/bin/bash
# Variables globales

# opcion=0 Estas variables sobran
#pid=""

mostrar_procesos() {
    echo "Procesos en ejecución:"
    ps -o pid,ni,comm --sort=pid | less #Sobra una e y falta un less
}

consultar_proceso() {
    echo "Consultando el proceso con PID $pid"
    ps -p $pid -o pid,ni,stat,comm
    exit
}

cambiar_prioridad() {
    # Cambiado echo por -p de read
    read -p "Introduce el PID del proceso: " pid
    if [ $pid -gt 0 ]; then # Faltaba $ en pid
        # Cambiado echo por -p de read
        read -p "Introduce la nueva prioridad (-20 a 19): " prioridad
        renice -n $prioridad -p $pid
    fi # Falta fi para cerrar el if
}

while [ "$opcion" != "4" ]; do
    #echo ""
    #echo "===== GESTIÓN DE PROCESOS ====="
    #echo "1. Mostrar procesos"
    #echo "2. Consultar un proceso"
    #echo "3. Cambiar prioridad"
    #echo "4. Salir"
    clear
    #echo "Selecciona una opción:"
    #read $opcion
    read -p "
    ===== GESTIÓN DE PROCESOS =====
    1. Mostrar procesos
    2. Consultar un proceso
    3. Cambiar prioridad
    4. Salir
    
    Selecciona una opción: " opcion # Sobra un $

    case $opcion in
    1)
        mostrar_procesos
        ;;
    2)
        read -p "Introduce el PID: " pid # Cambiado el echo a -p de read
        consultar_proceso
        ;;
    3)
        cambiar_prioridad
        ;;
    4)
        echo "Saliendo del programa..."
        ;;
    *)
        echo "Opción no válida"
        ;;
    esac
done

echo "Programa finalizado."
exit 5
