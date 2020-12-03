#!/bin/bash

IP=$1
USER=$2
PASS=$3

# Ejecutamos el .py de comprobacion

res=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/connect_winrm.py $IP $USER $PASS)
if [ $res -eq 0 ]; then
    echo true
    exit 0
fi
echo false
exit 1