#!/bin/bash

CLI_IP=$1
CLI_USER=$2
CLI_PASSWORD=$3
SERVER_IP=$4

STR=""

# Comprobamos si ya se ha testeado la conexion
PREF_METHOD_FILE="/etc/proyecto/general/${CLI_IP}"
if ! [ -f "$PREF_METHOD_FILE" ]; then
    STR="$STR\n 1!@El archivo de conexion para el cliente no existe, se creara automaticamente usando http://proyecto.local/test.php "
    echo $STR
    exit 1
fi
PREF_METHOD=$(tail -n 1 /etc/proyecto/general/${CLI_IP} | cut -d ":" -f 2)
if [ "$PREF_METHOD" == "false" ]; then
    STR="$STR\n 1!@Debes habilitar alguna forma de comunicacion y ejecutar http://proyecto.local/test.php "
    echo $STR
    exit 1
fi

SISTEMA=$(cat /etc/proyecto/general/${CLI_IP} | grep sistema | cut -d ":" -f 2)
if [ "$SISTEMA" == "windows" ]; then
    if [ "$PREF_METHOD" == "ssh" ]; then
        COMMAND="Invoke-WebRequest -Uri https://packages.wazuh.com/4.x/windows/wazuh-agent-4.0.3-1.msi -OutFile wazuh-agent.msi; ./wazuh-agent.msi /qn WAZUH_MANAGER='$SERVER_IP' WAZUH_REGISTRATION_SERVER='$SERVER_IP'"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al instalar el agente: $RES"
            echo $STR
            exit 1
        fi
    fi
    if [ "$PREF_METHOD" == "winrm" ]; then
        RES=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/wazuh.py $CLI_IP $CLI_USER $CLI_PASSWORD $SERVER_IP)
        if ! [ $RES -eq 0 ]; then
            STR="$STR\n 0!@Fallo al ejecutar el script de instalacion: $RES"
            echo $STR
            exit 0
        fi
    fi
    STR="$STR\n 0!@Agente instalado."
    echo $STR
    exit 0
else
    if [ "$PREF_METHOD" == "ssh" ]; then
        COMMAND="curl -so wazuh-agent.deb https://packages.wazuh.com/4.x/apt/pool/main/w/wazuh-agent/wazuh-agent_4.0.3-1_amd64.deb && sudo WAZUH_MANAGER='$SERVER_IP' dpkg -i ./wazuh-agent.deb"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al instalar el agente: $RES"
            echo $STR
            exit 1
        fi

        COMMAND="sudo service wazuh-agent start"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al iniciar el servicio: $RES"
            echo $STR
            exit 1
        fi
        STR="$STR\n 0!@Agente instalado."
        echo $STR
        exit 0
    fi
    if [ "$PREF_METHOD" == "winrm" ]; then
        STR="$STR\n 1!@Solo se permite esta operacion desde SSH"
        echo $STR
        exit 1
    fi
fi
