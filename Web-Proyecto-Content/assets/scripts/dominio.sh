#!/bin/bash

CLI_IP=$1
CLI_USER=$2
CLI_PASSWORD=$3

DOM_IP=$4
DOM_USER=$5
DOM_PASSWORD=$6
DOM_NAME=$7

# Comprobamos si ya se ha testeado la conexion
PREF_METHOD_FILE="/etc/proyecto/general/${CLI_IP}"
if ! [ -f "$PREF_METHOD_FILE" ]; then
    echo "El archivo de conexion para el cliente no existe, se creara automaticamente usando http://proyecto.local/test.php "
    exit
fi
PREF_METHOD_FILE="/etc/proyecto/general/${DOM_IP}"
if ! [ -f "$PREF_METHOD_FILE" ]; then
    echo "El archivo de conexion para el dominio no existe, se creara automaticamente usando http://proyecto.local/test.php "
    exit
fi
PREF_METHOD_CLI=$(tail -n 1 /etc/proyecto/general/${CLI_IP} | cut -d ":" -f 2)
if [ "$PREF_METHOD_CLI" == "false" ]; then
    echo "Debes habilitar alguna forma de comunicacion en el cliente y ejecutar http://proyecto.local/test.php "
    exit
fi
PREF_METHOD_DOM=$(tail -n 1 /etc/proyecto/general/${DOM_IP} | cut -d ":" -f 2)
if [ "$PREF_METHOD_DOM" == "false" ]; then
    echo "Debes habilitar alguna forma de comunicacion en el dominio y ejecutar http://proyecto.local/test.php "
    exit
fi

# Tenemos que comprobar tambien que ambos equipos son windows
SISTEMA_CLI=$(grep </etc/proyecto/general/${CLI_IP} sistema | cut -d ":" -f 2)
SISTEMA_DOM=$(grep </etc/proyecto/general/${DOM_IP} sistema | cut -d ":" -f 2)
if [ "$SISTEMA_CLI" != "windows" ]; then
    echo "Solo se permiten clientes Windows."
    exit
fi
if [ "$SISTEMA_DOM" != "windows" ]; then
    echo "Solo se permiten dominios Windows."
    exit
fi

# Copiamos el script de instalacion y lo descargamos en el equipo objetivo
cp /var/www/proyecto/assets/scripts/join_domain.ps1 /var/www/html/uploads
if ! [ $? -eq 0 ]; then
    echo "Fallo al copiar el archivo en /uploads."
    exit 1
fi

if [ "$PREF_METHOD_CLI" == "ssh" ]; then

    COMMAND="curl -o C:\Users\\${CLI_USER}\\join_domain.ps1 http://${SERVER_IP}/uploads/join_domainps1"
    RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al descargar el archivo."
        exit 1
    fi

    # Una vez descargado lo ejecutamos en el cliente
    COMMAND="C:\Users\\${CLI_USER}\\join_domain.ps1 $CLI_IP $DOM_IP $DOM_USER $DOM_PASSWORD $DOM_NAME"
    RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al descargar el archivo."
        exit 1
    fi
fi

if [ $PREF_METHOD == "winrm" ]; then
    RES=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/domain.py $CLI_IP $CLI_USER $CLI_PASSWORD $DOM_IP $DOM_USER $DOM_PASSWORD $DOM_NAME)
    if ! [ $RES -eq 0 ]; then
        echo "Fallo al ejecutar script."
        exit 1
    fi
fi