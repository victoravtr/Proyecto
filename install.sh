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

# Almacenamos el directorio actual
INSTALL_DIR=$(pwd)

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
    echo -e "$Red  [-] Error: debes ejecutar el script con sudo. Ejemplo: sudo ./install.sh $Color_Off"
    exit 1
fi

# Seguimos ejecutando el script como sudo
echo "--------------------------------------------------"
echo -e "${Blue}Comprobando requisitos software: $Color_Off"

IP=$(hostname -I | sed 's/ *$//g')

# LAMP

# Comprobamos si apache2 esta instalado
echo -e "${Blue}\nComprobando instalacion de apache2: $Color_Off"
if ! [ -x "$(command -v apache2)" ]; then
  echo -e "$Red  [-] Error: apache2 no esta instalado. $Color_Off"
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
if ! [ -d "/var/www/proyecto" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /var/www/proyecto $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /var/www/proyecto $Color_Off"
    sudo mkdir /var/www/proyecto
fi
echo -e "$Green [+] Carpeta /var/www/proyecto creada $Color_Off"

if ! [ -d "/var/www/doc-proyecto" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /var/www/doc-proyecto $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /var/www/doc-proyecto $Color_Off"
    sudo mkdir /var/www/doc-proyecto
fi
echo -e "$Green [+] Carpeta /var/www/doc-proyecto creada $Color_Off"

echo -e "$Green [+] Carpetas creadas $Color_Off"

# Comprobamos si las carpetas estan vacias
# Si lo estan copiamos los archivos en ellas

echo -e "${Blue}\nComprobando contenido de las carpetas: $Color_Off"
if [ -z "$(ls -A /var/www/proyecto)" ]; then
  # Copiamos el contenido de Web-Proyecto-Content/ en /var/www/proyecto
  echo -e "$Red [-] Error: la carpeta /var/www/proyecto esta vacia. $Color_Off"
  echo  -e "$Yellow  [+] Copiando contenido en /var/www/proyecto $Color_Off"
  sudo cp Web-Proyecto-Content/* /var/www/proyecto/
fi


# Comprobamos si ya se han copiado los archivos de configuracion en el directorio /etc/apache2/sites-available
echo -e "${Blue}\nComprobando archivos de configuracion de apache2: $Color_Off"

if ! [ -a "/etc/apache2/sites-available/proyecto.conf" ]; then
  echo -e "$Red [-] Error: no existe el archivo proyecto.conf en /etc/apache2/sites-available. $Color_Off "
  printf "$Yellow [?] Quieres que lo cree por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes copiar el archivo /files/apache/proyecto.conf en /etc/apache2/sites-available/ $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#apache2 $Color_Off"
    exit 1
  else
    # Copiamos el archivo
    echo  -e "$Yellow  [+] Copiando archivo $Color_Off"
    sudo cp files/apache/proyecto.conf /etc/apache2/sites-available/proyecto.conf
    # Activamos el sitio
    # Al usar a2ensite desde fuera de sites-available falla, hacemos cd a la carpeta y volvemos
    echo  -e "$Yellow  [+] Activando sitio $Color_Off"
    cd /etc/apache2/sites-available/
    sudo a2ensite proyecto.conf
    sudo systemctl reload apache2
    cd $INSTALL_DIR
  fi
fi

echo -e "$Green [+] Sitio creado $Color_Off"

# Comprobamos si php esta instalado
echo -e "${Blue}\nComprobando instalacion de php: $Color_Off"
if ! [ -x "$(command -v php)" ]; then
  echo -e "$Red  [-] Error: php no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar php $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#php $Color_Off"
    exit 1
  else
    # Instalamos apache2
    echo "$Yellow  [+] Instalando php $Color_Off"
    sudo apt install php
  fi
fi

echo -e "$Green [+] php esta instalado $Color_Off"








# Comprobamos si hugo esta instalado para mostrar la documentacion


# Comprobamos si mysql esta instalado
# if ! [ -x "$(command -v mysql)" ]; then
#   echo -e "$Red [-] Error: mysql no esta instalado. $Color_Off"
#   echo -e "$Red [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#mysql $Color_Off"
#   exit 1
# fi
# echo "[+] mysql esta instalado"

