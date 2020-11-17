IP=$1
USER=$2
PASS=$3
FILE=$4
SERVER_IP=IP=$(hostname -I)

# Comprobar conexion con equipo
#   Leemos archivo, comprobando antes si existe, para ver si hay un metodo preferido.
PREF_METHOD_FILE="/etc/proyecto/general/${IP}"
if ! [ -f $PREF_METHOD_FILE ]; then
    echo "El archivo no existe, se creara automaticamente usando http://proyecto.local/test.php "
    exit
fi

PREF_METHOD = "tail -n 1 /etc/proyecto/general/${IP} | cut -d ":" -f 2"
if [ $PREF_METHOD == "false" ]; then
    echo "Debes habilitar alguna forma de comunicacion y ejecutar http://proyecto.local/test.php "
    exit
fi
# Si pref_method es ssh ejecutamos las ordenes aqui, si es winrm ejecutamos el script de python
if [ $PREF_METHOD == "ssh" ]; then
    # Comprobamos conexion
    RES=$(sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP exit)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al realizar la conexion. ${RES}"
        exit 1
    fi
    #Descargamos el archivo
    RES=$(sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP "exit")
    if ! [ $? -eq 0 ]; then
        echo "Fallo al realizar la conexion. ${RES}"
        exit 1
    fi

    echo $RES
fi
# Descargar el archivo en el equipo objetivo
# Ejecutarlo
# Borrar archivo en ambos equipos
# Devolver resultado
