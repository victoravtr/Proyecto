#!/bin/bash
# PSRemoting aun no esta implementado del todo en Linux, por lo que primero hay que conectarse
#   con ssh y desde ahi comprobar si PSRemote esta habilitado
IP=$1
USER=$2
PASS=$3

# Comprobamos si el equipo es accesible por ssh
COMMAND="Enter-PSSession -ComputerName localhost"
sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP $COMMAND
if [ $? -eq 0 ]; then
    echo true
    exit 0
fi
echo false
exit 1