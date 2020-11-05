#!/bin/bash

# Requisitos:
# - apache2
# - hugo
# - mysql
# - php

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Blue='\033[0;33m'        # Blue
Yellow='\033[0;36m'        # Yellow

# Comprobamos si EUID esta vacio y le asignamos un valor
# SI esta vacio es que ya es root
echo -e "${Blue}Comprobando si se ejecuta con sudo: $Color_Off"
USER_ID="$EUID"
if [[ -z "$USER_ID" ]]; then
    $USER_ID=0
fi

if [[ $USER_ID = 0 ]]; then
    echo -e "$Green [+] already root $Color_Off"
else
    sudo -k # Pedimos password sudo
    if sudo true; then
        echo -e "$Green [+] correct password $Color_Off"
    else
        echo -e "$Red [-] wrong password $Color_Off"
        exit 1
    fi
fi

# Seguimos ejecutando el script como sudo
echo "--------------------------------------------------"
echo -e "${Blue}Comprobando requisitos software: $Color_Off"

IP=$(hostname -I | sed 's/ *$//g')

# LAMP

# Comprobamos si apache2 esta instalado
echo -e "${Blue}Comprobando instalacion de apache2: $Color_Off"
if ! [ -x "$(command -v apache2)" ]; then
  echo -e "$Red  [-] Error: apache2 no esta instalado. $Color_Off "
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar apache2 $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#apache2 $Color_Off"
    exit 1
  fi
fi
# Instalamos apache2
echo "$Yellow  [+] Instalando apache2"
sudo apt install apache2
echo -e "$Green [+] apache2 esta instalado $Color_Off"

# Comprobamos si hugo esta instalado para mostrar la documentacion


# Comprobamos si mysql esta instalado
if ! [ -x "$(command -v mysql)" ]; then
  echo -e "$Red [-] Error: mysql no esta instalado. $Color_Off"
  echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#mysql $Color_Off"
  exit 1
fi
echo "[+] mysql esta instalado"

