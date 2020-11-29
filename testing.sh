#!/bin/bash

CLI_PASSWORD='Alisec$2018'
CLI_USER='root'
CLI_IP='192.168.10.62'

COMMAND="lsb_release -sc | tr -dc '[:print:]'"
VERSION=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
echo $VERSION
COMMAND="wget https://repo.zabbix.com/zabbix/5.0/debian/pool/main/z/zabbix-release/zabbix-release_5.0-1+${VERSION}_all.deb"
echo $COMMAND

# SISTEMA_OPERATIVO=$(sshpass -p$CLI_PASSWORD ssh -t -o StrictHostKeyChecking=no $CLI_USER@$CLI_IP $COMMAND)
# if ! [ $? -eq 0 ]; then
#     echo "Fallo al descargar el instalador."
#     exit 1
# fi

# echo $SISTEMA_OPERATIVO