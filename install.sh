#!/bin/bash

# Requisitos:
# - apache2
#  - archivo configuracion apache para web
#  - archivo configuracion apache para documentacion
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
echo -e "${Blue}\nComprobando instalacion de apache2: $Color_Off"
if ! [ -x "$(command -v apache2)" ]; then
  echo -e "$Red  [-] Error: apache2 no esta instalado. $Color_Off "
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar apache2 $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#apache2 $Color_Off"
    exit 1
  else
    # Instalamos apache2
    echo "$Yellow  [+] Instalando apache2 $Color_Off"
    sudo apt install apache2
  fi
fi

echo -e "$Green [+] apache2 esta instalado $Color_Off"

# De primeras vamos a hacerlo todo en un proyecto.local que tenemos que meter en /etc/hosts
# Cuando este todo montado se mirara de que el usuario pueda meter su propia url por si ya esta en un dominio por 
#   ejemplo pero no es prioridad
#
# Tambien necesitamos crear las carpetas /var/www/doc-proyecto y /var/www/proyecto

# Comprobamos si existe la entrada en /etc/hosts
echo -e "${Blue}\nComprobando archivo /etc/hosts: $Color_Off"
if [ -z "$(cat /etc/hosts | grep proyecto.local)" ]; then
  echo -e "$Red [-] Error: no existe la entrada ' $IP  proyecto.local ' en /etc/hosts. $Color_Off "
  printf "$Yellow [?] Quieres que la cree por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes crear la entrada en /etc/hosts $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#hosts $Color_Off"
    exit 1
  else
    # Creamos la entrada
    echo  -e "$Yellow  [+] Creando entrada $Color_Off"
    command echo "$IP proyecto.local" >> /etc/hosts
  fi
fi

echo -e "$Green [+] Archivo /etc/hosts comprobado $Color_Off"

# Comprobamos si ya existen las carpetas en /var/www
echo -e "${Blue}\nComprobando carpetas en /var/www/: $Color_Off"
if [ -d "/var/www/proyecto" ]; then

fi

# Comprobamos si ya se han copiado los archivos de configuracion en el directorio /etc/apache2/sites-available

echo -e "${Blue}\nComprobando archivos de configuracion de apache2: $Color_Off"

if ! [ -a "/etc/apache2/sites-available/doc-proyecto.conf" ]; then
  echo -e "$Red [-] Error: no existe el archivo doc-proyecto.conf en /etc/apache2/sites-available. $Color_Off "
  printf "$Yellow [?] Quieres que la cree por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes copiar el archivo /files/apache/doc-proyecto.conf en /etc/apache2/sites-available/ $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#apache2 $Color_Off"
    exit 1
  else
    # Creamos la entrada
    echo  -e "$Yellow  [+] Copiando archivo $Color_Off"

  fi
fi









# Comprobamos si hugo esta instalado para mostrar la documentacion


# Comprobamos si mysql esta instalado
# if ! [ -x "$(command -v mysql)" ]; then
#   echo -e "$Red [-] Error: mysql no esta instalado. $Color_Off"
#   echo -e "$Red [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#mysql $Color_Off"
#   exit 1
# fi
# echo "[+] mysql esta instalado"

