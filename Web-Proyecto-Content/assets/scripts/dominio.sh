#!/bin/bash

CLI_IP=$1
CLI_USER=$2
CLI_PASSWORD=$3

DOM_IP=$4
DOM_USER=$5
DOM_PASSWORD=$6
DOM_NAME=$7

STR=""
SERVER_IP=$(hostname -I | sed 's/ *$//g')

# Comprobamos si ya se ha testeado la conexion
PREF_METHOD_FILE="/etc/proyecto/general/${CLI_IP}"
if ! [ -f "$PREF_METHOD_FILE" ]; then
    STR="$STR\n 1!@El archivo de conexion para el cliente no existe, se creara automaticamente usando http://proyecto.local/test.php "
    echo $STR
    exit 1
fi
PREF_METHOD_FILE="/etc/proyecto/general/${DOM_IP}"
if ! [ -f "$PREF_METHOD_FILE" ]; then
    STR="$STR\n 1!@El archivo de conexion para el dominio no existe, se creara automaticamente usando http://proyecto.local/test.php "
    echo $STR
    exit 1
fi
PREF_METHOD_CLI=$(tail -n 1 /etc/proyecto/general/${CLI_IP} | cut -d ":" -f 2)
if [ "$PREF_METHOD_CLI" == "false" ]; then
    STR="$STR\n 1!@Debes habilitar alguna forma de comunicacion en el cliente y ejecutar http://proyecto.local/test.php "
    echo $STR
    exit 1
fi
PREF_METHOD_DOM=$(tail -n 1 /etc/proyecto/general/${DOM_IP} | cut -d ":" -f 2)
if [ "$PREF_METHOD_DOM" == "false" ]; then
    STR="$STR\n 1!@Debes habilitar alguna forma de comunicacion en el dominio y ejecutar http://proyecto.local/test.php "
    echo $STR
    exit 1
fi

# Tenemos que comprobar tambien que ambos equipos son windows
SISTEMA_CLI=$(grep </etc/proyecto/general/${CLI_IP} sistema | cut -d ":" -f 2)
SISTEMA_DOM=$(grep </etc/proyecto/general/${DOM_IP} sistema | cut -d ":" -f 2)
if [ "$SISTEMA_CLI" != "windows" ]; then
    STR="$STR\n 1!@Solo se permiten clientes Windows."
    echo $STR
    exit 1
fi
if [ "$SISTEMA_DOM" != "windows" ]; then
    STR="$STR\n 1!@Solo se permiten dominios Windows."
    echo $STR
    exit 1
fi

if [ $PREF_METHOD_CLI == "ssh" ]; then
    # Copiamos el script de instalacion y lo descargamos en el equipo objetivo
    cp /etc/proyecto/general/join_domain.ps1 /var/www/proyecto/uploads/join_domain.ps1
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al copiar el archivo en /uploads."
        echo $STR
        exit 1
    fi

    # Generamos un archivo con la pass y lo descargamos en el cliente
    # Una vez descargado lo borramos del servidor
    echo $DOM_PASSWORD >/var/www/proyecto/uploads/pass.txt
    COMMAND="curl -o C:\Users\\${CLI_USER}\\pass.txt http://${SERVER_IP}/uploads/pass.txt"
    RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al descargar el archivo en el cliente.."
        echo $STR
        exit 1
    fi
    STR="$STR\n 0!@Se descarga el archivo pass en el cliente."

    rm /var/www/proyecto/uploads/pass.txt
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al borrar el archivo en /uploads."
        echo $STR
        exit 1
    fi

    COMMAND="curl -o C:\Users\\${CLI_USER}\\join_domain.ps1 http://${SERVER_IP}/uploads/join_domain.ps1"
    RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al descargar el script de powershell en el cliente."
        echo $STR
        exit 1
    fi
    STR="$STR\n 0!@Se descarga el script de powershell en el cliente."
    rm /var/www/proyecto/uploads/join_domain.ps1

    # Una vez descargado lo ejecutamos en el cliente
    COMMAND="powershell.exe C:\Users\\${CLI_USER}\\join_domain.ps1 $CLI_IP $DOM_IP $DOM_USER $DOM_PASSWORD $DOM_NAME"
    RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al ejecutar el script en el cliente: $RES"
        echo $STR
        exit 1
    fi
    STR="$STR\n 0!@El equipo se ha unido al dominio."
    echo $STR
    exit 0
fi

if [ $PREF_METHOD_CLI == "winrm" ]; then
    STR="$STR\n 1!@Esta operacion solo esta permitida mediante SSH."
    echo $STR
    exit 1
fi