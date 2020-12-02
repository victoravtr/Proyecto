#!/bin/bash

IP=$1
USER=$2
PASS=$3

# Escanear red con nmap
nmap -sP $IP -oG log.txt >/dev/null
if ! [ $? -eq 0 ]; then
    STR="$STR\n 1!@Fallo al ejecutar nmap: $RES"
    echo $STR
    exit 1
fi

# Parsear log y recuperar IP
parse=$(cat log.txt | grep -v 'Nmap' | cut -d " " -f 2)
if ! [ $? -eq 0 ]; then
    STR="$STR\n 1!@Fallo al parsear log: $RES"
    echo $STR
    exit 1
fi

rm log.txt
echo $parse
exit 0

