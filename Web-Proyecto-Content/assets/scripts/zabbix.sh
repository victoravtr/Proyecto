#!/bin/bash

CLI_IP=$1
CLI_USER=$2
CLI_PASSWORD=$3

SERVER_IP=$4

LOCAL_SERVER_IP=$(hostname -I | sed 's/ *$//g')
URL_DESCARGA_EXE="https://www.zabbix.com/downloads/5.2.1/zabbix_agent-5.2.1-windows-amd64-openssl.msi"
URL_DESCARGA_CONFIG="https://${LOCAL_SERVER_IP}/uploads/zabbix_agentd.conf"

# Comprobamos si ya se ha testeado la conexion
PREF_METHOD_FILE="/etc/proyecto/general/${CLI_IP}"
if ! [ -f "$PREF_METHOD_FILE" ]; then
    echo "El archivo de conexion para el cliente no existe, se creara automaticamente usando http://proyecto.local/test.php "
    exit 1
fi
PREF_METHOD=$(tail -n 1 /etc/proyecto/general/${CLI_IP} | cut -d ":" -f 2)
if [ "$PREF_METHOD" == "false" ]; then
    echo "Debes habilitar alguna forma de comunicacion en el cliente y ejecutar http://proyecto.local/test.php "
    exit 1
fi

# Dependiendo de el PREF_METHOD ejecutamos una u otra
if [ $PREF_METHOD_CLI == "ssh" ]; then
    # Descargamos los archivos en el cliente
    COMMAND="curl -o C:\Users\\${CLI_USER}\\pass.txt $URL_DESCARGA_EXE"
    RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al descargar el archivo."
        exit 1
    fi

    # Copiamos el archivo zabbix_agentd.conf y cambiamos la IP de server
    cp /etc/proyecto/zabbix/zabbix_agentd.conf /var/www/html/uploads/zabbix_agentd.conf
    if ! [ $? -eq 0 ]; then
        echo "Fallo al copiar el archivo en /uploads."
        exit 1
    fi
    sed \'s/placeholder/$SERVER_IP/\' /var/www/html/uploads/zabbix_agentd.conf 
    if ! [ $? -eq 0 ]; then
        echo "Fallo al editar el archivo en zabbix_agentd.conf."
        exit 1
    fi
fi

echo $URL_DESCARGA_EXE
echo $URL_DESCARGA_CONFIG
