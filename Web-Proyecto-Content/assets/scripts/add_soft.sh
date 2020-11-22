#!/bin/bash

IP=$1
USER=$2
PASS=$3
FILE=$4
SERVER_IP=$(hostname -I | sed 's/ *$//g')
# Comprobar conexion con equipo
#   Leemos archivo, comprobando antes si existe, para ver si hay un metodo preferido.
PREF_METHOD_FILE="/etc/proyecto/general/${IP}"
if ! [ -f $PREF_METHOD_FILE ]; then
    echo "El archivo no existe, se creara automaticamente usando http://proyecto.local/test.php "
    exit
fi

PREF_METHOD=$(tail -n 1 /etc/proyecto/general/${IP} | cut -d ":" -f 2)

if [ $PREF_METHOD == "false" ]; then
    echo "Debes habilitar alguna forma de comunicacion y ejecutar http://proyecto.local/test.php "
    exit
fi

SISTEMA=$(cat /etc/proyecto/general/${IP} | grep sistema | cut -d ":" -f 2)

# Si el sistema es Windows tenemos que comprobar el tipo de conexion
# SI el sistema es Linux solo se podra usar ssh
# Ademas dependiendo del sistema cambia el directorio de descargar y los comandos
#   para hacer la instalacion

if [ $SISTEMA == "linux" ]; then
    # Home Dir
    if [ $USER == "root" ]; then
        DIR="/root/"
    fi
    if [ $USER != "root" ]; then
        DIR="/home/${USER}/"
    fi
    COMMAND="echo \$HOME"
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)

    if ! [ $? -eq 0 ]; then
        echo "Fallo al descargar el archivo."
        exit 1
    fi
    # Descargamos el archivo en el equipo objetivo
    COMMAND="curl -o ${DIR}${FILE} http://${SERVER_IP}/uploads/${FILE}"
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al descargar el archivo."
        exit 1
    fi

    # Instalamos el archivo con dpkg
    # Tenemos que setear DEBIAN_FRONTEND=noninteractive antes de instalarlo para que no salga prompts
    # Despues de instalar el programa seteamos a "" la variable
    COMMAND="export DEBIAN_FRONTEND=noninteractive && dpkg -i ${DIR}${FILE} && export DEBIAN_FRONTEND="
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        # Instalamos las dependencias si falla y volvemos a ejecutar el dpkg -i
        COMMAND="apt-get -f -y install"
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al instalar dependencias."
            exit 1
        fi
        COMMAND="export DEBIAN_FRONTEND=noninteractive && dpkg -i ${DIR}${FILE} && export DEBIAN_FRONTEND="
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al instalar."
            exit 1
        fi
    fi

    # Borramos el archivo en el cliente
    COMMAND="rm ${DIR}${FILE}"
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        echo "Fallo al borrar el archivo en el cliente."
        exit 1
    fi

    # Borramos el archivo en el servidor
    RES=$(rm /var/www/html//uploads/${FILE})
    if ! [ $? -eq 0 ]; then
        echo "Fallo al borrar el archivo en el servidor."
        exit 1
    fi
fi

if [ $SISTEMA == "windows" ]; then
    # Si pref_method es ssh ejecutamos las ordenes aqui, si es winrm ejecutamos el script de python
    if [ $PREF_METHOD == "ssh" ]; then
        # Comprobamos conexion
        RES=$(sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP exit)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al realizar la conexion. ${RES}"
            exit 1
        fi
        # Descargamos el archivo en el equipo objetivo
        COMMAND="curl -o C:\Users\\${USER}\\${FILE} http://${SERVER_IP}/uploads/${FILE}"
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al descargar el archivo."
            exit 1
        fi
        # Ejecutamos el archivo
        # Start-Process -FilePath C:\Users\victorav\chrome.exe -ArgumentList "/silent","/install" -PassThru -Verb runas;
        COMMAND="Start-Process -FilePath \"C:\Users\\${USER}\\${FILE}\" -ArgumentList \"/install\",\"/silent\" -PassThru -Verb runas"
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)

        if ! [ $? -eq 0 ]; then
            echo "Fallo al ejecutar el archivo."
            exit 1
        fi
        # Una vez instalado borramos el archivo
        COMMAND="rm \"C:\Users\\${USER}\\${FILE}\""
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            echo "Fallo al borrar el archivo en el cliente."
            exit 1
        fi
        # Por ultimo lo borramos en el servidor
        RES=$(rm /var/www/html/uploads/${FILE})
        if ! [ $? -eq 0 ]; then
            echo "Fallo al borrar el archivo en el servidor."
            exit 1
        fi
    fi
    if [ $PREF_METHOD == "winrm" ]; then
        RES=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/add_soft.py $IP $USER $PASS $FILE)
        if ! [ $RES -eq 0 ]; then
            echo "Fallo al ejecutar el instalador del archivo."
            exit 1
        fi
    fi
fi
