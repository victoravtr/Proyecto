#!/bin/bash

IP=$1
USER=$2
PASS=$3

# Comprobamos si el equipo es accesible por ssh
sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP exit
if [ $? -eq 0 ]; then
    echo true
    exit 0
fi
echo false
exit 1