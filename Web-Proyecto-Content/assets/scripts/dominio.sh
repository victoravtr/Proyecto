#!/bin/bash

CLI_IP=$1
CLI_USER=$2
CLI_PASSWORD=$3

DOM_IP=$4
DOM_USER=$5
DOM_PASSWORD=$6

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

# A partir de aqui pueden ocurrir varios casos:
#   - El cliente usa ssh y el servidor ssh
#   - El cliente usa winrm y el servidor winrm
#   - El cliente usa ssh y el servidor winrm
#   - El cliente usa winrm y el servidor ssh

# Dependiendo del metodo se ejecutara un script o otro aunque el funcionamiento
#   sera el mismo:
#       Descargar el script en el cliente/servidor
#       Ejecutar el script
#       Borrar el script

if [ "$PREF_METHOD_CLI" == "ssh" ]; then
    COMMAND=""
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al descargar el archivo."
        exit 1
    fi
fi
