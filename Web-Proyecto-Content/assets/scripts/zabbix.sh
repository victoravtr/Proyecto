#!/bin/bash

CLI_IP=$1
CLI_HOST=$2
CLI_USER=$3
CLI_PASSWORD=$4
CLI_ARCH=$5

STR=""
SERVER_IP=$6

LOCAL_SERVER_IP=$(hostname -I | sed 's/ *$//g')

LOCAL_SERVER_IP=$(hostname -I | sed 's/ *$//g')
URL_DESCARGA_CONFIG="http://${LOCAL_SERVER_IP}/uploads/zabbix_agentd.conf"

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

# Copiamos el archivo zabbix_agentd.conf y cambiamos la IP de server
cp /etc/proyecto/zabbix/zabbix_agentd.conf /var/www/html/uploads/zabbix_agentd.conf
if ! [ $? -eq 0 ]; then
    STR="$STR\n 1!@Fallo al copiar el archivo de configuracion en /uploads "
    echo $STR
    exit 1
fi
sed -i "s/placeholder_server/${SERVER_IP}/" /var/www/html/uploads/zabbix_agentd.conf
if ! [ $? -eq 0 ]; then
    STR="$STR\n 1!@Fallo al editar el archivo de configuracion"
    echo $STR
    exit 1
fi
sed -i "s/placeholder_hostname/${CLI_HOST}/" /var/www/html/uploads/zabbix_agentd.conf
if ! [ $? -eq 0 ]; then
    STR="$STR\n 1!@Fallo al editar el archivo de configuracion"
    echo $STR
    exit 1
fi

SISTEMA=$(cat /etc/proyecto/general/${CLI_IP} | grep sistema | cut -d ":" -f 2)
if [ $SISTEMA == "windows" ]; then
    # Comprobamos si es de 64 o 32 bits
    if [ $CLI_ARCH == "64" ]; then
        cp /etc/proyecto/zabbix/zabbix_agentd64.exe /var/www/html/uploads/zabbix_agentd.exe
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al copiar el instalador en /uploads "
            echo $STR
            exit 1
        fi
    else
        cp /etc/proyecto/zabbix/zabbix_agentd32.exe /var/www/html/uploads/zabbix_agentd.exe
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al copiar el instalador en /uploads "
            echo $STR
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
            STR="$STR\n 1!@Fallo al descargar el archivo de configuracion en el cliente: $RES"
            echo $STR
            exit 1
        fi
        COMMAND="curl -o C:\Users\\${CLI_USER}\\zabbix_agentd.exe $URL_DESCARGA_EXE"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al descargar el instalador en el cliente: $RES"
            echo $STR
            exit 1
        fi
        STR="$STR\n 0!@Archivos descargados en el cliente."
        echo $STR
        exit 1
        # Si ya hay un servicio de zabbix el instalador fallara, lo borramos antes de ejecutar el instalador
        # sc delete "zabbix agent"
        COMMAND="sc.exe delete \"Zabbix agent\""
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        # Ejecutamos el instalador usando el archivo de configuracion
        # msiexec.exe /I zabbix_agent-5.2.1-windows-amd64-openssl.msi SERVER=192.168.10.12
        COMMAND="C:\Users\\${CLI_USER}\\zabbix_agentd.exe  --config C:\Users\\${CLI_USER}\\zabbix_agentd.conf --install"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al ejecutar el instalador: $RES"
            echo $STR
            exit 1
        fi
        STR="$STR\n 0!@Agente instalado."
        # Editamos el servicio para que se inicie automaticamente
        COMMAND="Set-Service \"Zabbix Agent\" -startuptype automatic"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@DFallo al editar el servicio: $RES"
            echo $STR
            exit 1
        fi
        STR="$STR\n 0!@Servicio editado"
        STR="$STR\n 0!@Agente instalado."
        echo $STR
        exit 0
    fi
    if [ $PREF_METHOD_CLI == "winrm" ]; then
        RES=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/zabbix.py $CLI_IP $CLI_USER $CLI_PASSWORD $DOM_IP $DOM_USER $DOM_PASSWORD $DOM_NAME)
        if ! [ $RES -eq 0 ]; then
            STR="$STR\n 0!@Fallo al ejecutar el script de instalacion: $RES"
            echo $STR
            exit 0
        fi
    fi
fi

if [ $SISTEMA == "linux" ]; then
    if [ "$PREF_METHOD" == "ssh" ]; then
        # Comprobamos si es Debian o Ubuntu, los 2 sistemas soportados por el momento
        COMMAND="lsb_release -i -s | tr -dc '[:print:]'"
        SISTEMA_OPERATIVO=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al comprobar la arquitectura del sistema"
            echo $STR
            exit 1
        fi
        if [ "$SISTEMA_OPERATIVO" == "Ubuntu" ]; then
            COMMAND="lsb_release -sc | tr -dc '[:print:]'"
            VERSION=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al comprobar la arquitectura del sistema"
                echo $STR
                exit 1
            fi

            COMMAND="wget https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_5.0-1+${VERSION}_all.deb"
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al descargar el instalador: $RES"
                echo $STR
                exit 1
            fi

            # Tenemos que setear DEBIAN_FRONTEND=noninteractive antes de instalarlo para que no salga prompts
            # Despues de instalar el programa seteamos a "" la variable
            COMMAND="export DEBIAN_FRONTEND=noninteractive && dpkg -i zabbix-release_5.0-1+${VERSION}_all.deb && export DEBIAN_FRONTEND="
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al ejecutar el instalador: $RES"
                echo $STR
                exit 1
            fi
            COMMAND="apt update"
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al realizar update: $RES"
                echo $STR
                exit 1
            fi

            COMMAND="apt -y install zabbix-agent"
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar zabbix: $RES"
                echo $STR
                exit 1
            fi
        elif [ "$SISTEMA_OPERATIVO" == "Debian" ]; then
            COMMAND="lsb_release -sc | tr -dc '[:print:]'"
            VERSION=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al comprobar la arquitectura del sistema"
                echo $STR
                exit 1
            fi

            COMMAND="sudo wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+${VERSION}_all.deb"
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al descargar el instalador en el cliente: $RES"
                echo $STR
                exit 1
            fi

            COMMAND="export DEBIAN_FRONTEND=noninteractive && dpkg -i zabbix-release_5.0-1+${VERSION}_all.deb && export DEBIAN_FRONTEND="
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al ejecutar el instalador: $RES"
                echo $STR
                exit 1
            fi

            COMMAND="apt update"
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al realizar update: $RES"
                echo $STR
                exit 1
            fi

            COMMAND="apt -y install zabbix-agent"
            RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar zabbix: $RES"
                echo $STR
                exit 1
            fi
            STR="$STR\n 1!@Zabbix instalado"
            echo $STR
            exit 1
        else
            STR="$STR\n 1!@Sistema no soportado"
            echo $STR
            exit 1
        fi

        # Paramos el servicio
        COMMAND="systemctl stop zabbix-agent"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo parar el servicio: $RES"
            echo $STR
            exit 1
        fi

        # Editamos el archivo zabbix_agentd.conf
        COMMAND="sed -i \"s/Server=127.0.0.1/Server=${SERVER_IP}/\" /etc/zabbix/zabbix_agentd.conf"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al editar el archivo de configuracion: $RES"
            echo $STR
            exit 1
        fi
        COMMAND="sed -i \"s/Hostname=Zabbix server/Hostname=${CLI_HOST}/\" /etc/zabbix/zabbix_agentd.conf"
        echo $COMMAND
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al editar el archivo de configuracion: $RES"
            echo $STR
            exit 1
        fi

        # Volvemos a iniciar el servicio
        COMMAND="systemctl start zabbix-agent"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al iniciar el servicio: $RES"
            echo $STR
            exit 1
        fi

        # Un vez instalado y configurado borramos todos los archivos: el .deb y el archivo de configuracion en uploads.
        rm /var/www/html/uploads/zabbix_agentd.conf
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al borrar el archivo de configuracion en el servidor"
            echo $STR
            exit 1
        fi
        COMMAND="rm zabbix-release_5.0-1+${VERSION}_all.deb"
        RES=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al borrar el instalador en el servidor: $RES"
            echo $STR
            exit 1
        fi
        STR="$STR\n 0!@Zabbix se ha instalado correctamente."
        echo $STR
        exit 0
    else
        STR="$STR\n 1!@Solo se permite esta operacion desde SSH"
        echo $STR
        exit 1
    fi
fi
