#!/bin/bash

IP=$1
USER=$2
PASS=$3
FILE=$4
SERVER_IP=$(hostname -I | sed 's/ *$//g')
STR=""
# Comprobar conexion con equipo
#   Leemos archivo, comprobando antes si existe, para ver si hay un metodo preferido.
#   Si no existe un PREF_METHOD significa que no hay ningun metodo de conexion, por lo que se termina la ejecucion del programa.
PREF_METHOD_FILE="/etc/proyecto/general/${IP}"
if ! [ -f $PREF_METHOD_FILE ]; then
    STR="$STR\n 1!@El archivo no existe, se creara automaticamente usando http://proyecto.local/test.php "
    echo $STR
    exit 1
fi

PREF_METHOD=$(tail -n 1 /etc/proyecto/general/${IP} | cut -d ":" -f 2)

if [ $PREF_METHOD == "false" ]; then
    STR="$STR\n 1!@Debes habilitar alguna forma de comunicacion y ejecutar http://proyecto.local/test.php "
    echo $STR
    exit 1
fi

SISTEMA=$(cat /etc/proyecto/general/${IP} | grep sistema | cut -d ":" -f 2)

# Si el sistema es Windows tenemos que comprobar el tipo de conexion
# SI el sistema es Linux solo se podra usar ssh
# Ademas dependiendo del sistema cambia el directorio de descargar y los comandos
#   para hacer la instalacion
EXT=${FILE: -3}

if [ "$SISTEMA" == "linux" ]; then
    # Home Dir
    if [ $USER == "root" ]; then
        DIR="/root/"
    fi
    if [ $USER != "root" ]; then
        DIR="/home/${USER}/"
    fi

    # Descargamos el archivo en el equipo objetivo
    COMMAND="curl -o ${DIR}${FILE} http://${SERVER_IP}/uploads/${FILE}"
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al descargar el archivo."
        echo $STR
        exit 1
    fi
    STR="$STR\n 0!@Archivo descargado en el cliente."

    if [ "$EXT" == "deb" ]; then
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
                STR="$STR\n 1!@Fallo al instalar dependencias: $RES"
                echo $STR
                exit 1
            fi

            COMMAND="export DEBIAN_FRONTEND=noninteractive && dpkg -i ${DIR}${FILE} && export DEBIAN_FRONTEND="
            RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar el archivo: $RES"
                echo $STR
                exit 1
            fi
        fi
        STR="$STR\n Archivo instalado."

    elif [ "$EXT" == "rpm" ]; then
        # Instalamos el archivo con rpm
        # Tenemos que setear DEBIAN_FRONTEND=noninteractive antes de instalarlo para que no salga prompts
        # Despues de instalar el programa seteamos a "" la variable
        COMMAND="export DEBIAN_FRONTEND=noninteractive && rpm -i ${DIR}${FILE} && export DEBIAN_FRONTEND="
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            # Instalamos las dependencias si falla y volvemos a ejecutar el dpkg -i
            COMMAND="apt-get -f -y install"
            RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar dependencias: $RES"
                echo $STR
                exit 1
            fi
            COMMAND="export DEBIAN_FRONTEND=noninteractive && rpm -i ${DIR}${FILE} && export DEBIAN_FRONTEND="
            RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar instalar el archivo: $RES"
                echo $STR
                exit 1
            fi
            STR="$STR\n 0!@Archivo instalado"
        fi
    else
        STR="$STR\n 1!@Tipo de archivo no permitido en este sistema,"
        echo $STR
        exit 1
    fi
    # Borramos el archivo en el cliente
    COMMAND="rm ${DIR}${FILE}"
    RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al borrar el archivo en el cliente: $RES"
        echo $STR
        exit 1
    fi
    STR="$STR\n 1!@Archivo eliminado en el cliente."
    echo $STR
    exit 1

    # Borramos el archivo en el servidor
    RES=$(rm /var/www/proyecto//uploads/${FILE})
    if ! [ $? -eq 0 ]; then
        STR="$STR\n 1!@Fallo al eliminar el archivo del servidor: $RES"
        echo $STR
        exit 1
    fi
    STR="$STR\n 0!@Archivo eliminado del servidor."
    STR="$STR\n 0!@Instalacion de software finalizada."
    echo $STR
    exit 0
fi

if [ "$SISTEMA" == "windows" ]; then

    # Si pref_method es ssh ejecutamos las ordenes aqui, si es winrm ejecutamos el script de python
    if [ $PREF_METHOD == "ssh" ]; then

        # Descargamos el archivo en el equipo objetivo
        COMMAND="curl -o C:\Users\\${USER}\\${FILE} http://${SERVER_IP}/uploads/${FILE}"
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al descargar el archivo en el cliente: $RES"
            echo $STR
            exit 1
        fi

        if [ "$EXT" == "exe" ]; then
            # Comprobamos el Producto name con exiftool
            # Comprobamos si coincide con alguna entrada de exe_switch.txt
            # SI hay alguna entrada, ponemos sus argumentos, si no ponemos los default
            DEFAULT_SWITCH="\"/qn\""

            PRODUCTO_NAME=$(exiftool /var/www/proyecto/uploads/$FILE | grep "Product Name" | cut -d ":" -f 2 | xargs)
            COINCIDENCIA=$(cat /etc/proyecto/general/exe_switch | grep "$PRODUCTO_NAME")
            
 
            if [ -n "$PRODUCTO_NAME" ]; then
                echo "entra pri0" >> log.txt
                if [ -n "$COINCIDENCIA" ]; then
                    SWITCH=$(cat /etc/proyecto/general/exe_switch | grep "$PRODUCTO_NAME" | cut -d ":" -f 2)
                    echo "entra sec" >> log.txt
                else
                    SWITCH=$DEFAULT_SWITCH
                fi
            else
                SWITCH=$DEFAULT_SWITCH
            fi
            # Ejecutamos el archivo
            # Start-Process -FilePath C:\Users\victorav\chrome.exe -ArgumentList "/silent","/install" -PassThru -Verb runas;
            COMMAND="\"C:\Users\\${USER}\\${FILE}\" \"$SWITCH\" -PassThru -Verb runAs"
            RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar el archivo: $RES"
                echo $STR
                exit 1
            fi
        elif [ "$EXT" == "msi" ]; then
            COMMAND="msiexec.exe /i \"C:\Users\\${USER}\\${FILE}\" /qn"
            if ! [ $? -eq 0 ]; then
                STR="$STR\n 1!@Fallo al instalar el archivo: $RES"
                echo $STR
                exit 1
            fi
        fi

        STR="$STR\n 0!@Archivo instalado."

        # Una vez instalado borramos el archivo
        COMMAND="rm \"C:\Users\\${USER}\\${FILE}\""
        RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND)
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al eliminar el archivo del cliente: $RES"
            echo $STR
            exit 1
        fi
        # Por ultimo lo borramos en el servidor
        RES=$(rm /var/www/proyecto/uploads/${FILE})
        if ! [ $? -eq 0 ]; then
            STR="$STR\n 1!@Fallo al eliminar el archivo del servidor: $RES"
            echo $STR
            exit 1
        fi
    fi
    STR="$STR\n 0!@Instalacion finalizada"
    echo $STR
    exit 0
    if [ $PREF_METHOD == "winrm" ]; then
        RES=$(python3 /var/www/proyecto/assets/scripts/add_soft.py $IP $USER $PASS $FILE)
        if ! [ $RES -eq 0 ]; then
            STR="$STR\n 1!@Fallo al instalar el archivo: $RES"
            echo $STR
            exit 1
        fi
        STR="$STR\n 0!@Archivo instalado"
            echo $STR
            exit 0
    fi
fi

if [ "$SISTEMA" != "windows" ] && [ "$SISTEMA" != "linux" ]; then
    STR="$STR\n 1!@Sistema no soportado: $SISTEMA"
    echo $STR
    exit 1
fi