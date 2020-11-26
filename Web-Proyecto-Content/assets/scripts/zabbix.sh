#!/bin/bash

CLI_IP=$1
CLI_HOST=$2
CLI_USER=$3
CLI_PASSWORD=$4
CLI_ARCH=$5

SERVER_IP=$6

LOCAL_SERVER_IP=$(hostname -I | sed 's/ *$//g')
URL_DESCARGA_CONFIG="http://${LOCAL_SERVER_IP}/uploads/zabbix_agentd.conf"

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

# Copiamos el archivo zabbix_agentd.conf y cambiamos la IP de server
cp /etc/proyecto/zabbix/zabbix_agentd.conf /var/www/html/uploads/zabbix_agentd.conf
if ! [ $? -eq 0 ]; then
    echo "Fallo al copiar el archivo en /uploads."
    exit 1
fi
sed -i "s/placeholder_server/${SERVER_IP}/" /var/www/html/uploads/zabbix_agentd.conf
if ! [ $? -eq 0 ]; then
    echo "Fallo al editar el archivo en zabbix_agentd.conf."
    exit 1
fi
sed -i "s/placeholder_hostname/${CLI_HOST}/" /var/www/html/uploads/zabbix_agentd.conf
if ! [ $? -eq 0 ]; then
    echo "Fallo al editar el archivo en zabbix_agentd.conf."
    exit 1
fi

SISTEMA=$(cat /etc/proyecto/general/${CLI_IP} | grep sistema | cut -d ":" -f 2)
if [ $SISTEMA == "windows" ]; then
    # Comprobamos si es de 64 o 32 bits
    if [ $CLI_ARCH == "64" ]; then
        cp /etc/proyecto/zabbix/zabbix_agentd64.exe /var/www/html/uploads/zabbix_agentd.exe
        if ! [ $? -eq 0 ]; then
            echo "Fallo al copiar el archivo en /uploads."
            exit 1
        fi
    else
        cp /etc/proyecto/zabbix/zabbix_agentd32.exe /var/www/html/uploads/zabbix_agentd.exe
        if ! [ $? -eq 0 ]; then
            echo "Fallo al copiar el archivo en /uploads."
            exit 1
        fi
    fi
    URL_DESCARGA_EXE="http://${LOCAL_SERVER_IP}/uploads/zabbix_agentd.exe"

    # Dependiendo de el PREF_METHOD ejecutamos una u otra
    if [ "$PREF_METHOD" == "ssh" ]; then
        # Descargamos los archivos en el cliente
        COMMAND="curl -o C:\Users\\${CLI_USER}\\zabbix_agentd.conf $URL_DESCARGA_CONFIG"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al descargar el instalador."
            exit 1
        fi
        COMMAND="curl -o C:\Users\\${CLI_USER}\\zabbix_agentd.exe $URL_DESCARGA_EXE"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al descargar el archivo."
            exit 1
        fi

        # Si ya hay un servicio de zabbix el instalador fallara, lo borramos antes de ejecutar el instalador
        # sc delete "zabbix agent"
        COMMAND="sc.exe delete \"Zabbix agent\""
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        # Ejecutamos el instalador usando el archivo de configuracion
        # msiexec.exe /I zabbix_agent-5.2.1-windows-amd64-openssl.msi SERVER=192.168.10.12
        COMMAND="C:\Users\\${CLI_USER}\\zabbix_agentd.exe  --config zabbix_agentd.conf --install"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al ejecutar el archivo."
            exit 1
        fi

        # Editamos el servicio para que se inicie automaticamente
        COMMAND="Set-Service \"Zabbix Agent\" -startuptype automatic"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al editar el servicio."
            exit 1
        fi
    fi
    if [ $PREF_METHOD_CLI == "winrm" ]; then
        RES=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/domain.py $CLI_IP $CLI_USER $CLI_PASSWORD $DOM_IP $DOM_USER $DOM_PASSWORD $DOM_NAME)
        if ! [ $RES -eq 0 ]; then
            echo "Fallo al ejecutar script."
            exit
        fi
    fi
fi
