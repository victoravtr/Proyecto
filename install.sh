#!/bin/bash

# Requisitos:
# - apache2
#  - archivo configuracion apache para web
#  - archivo configuracion apache para documentacion
# - hugo
# - mysql
# - php
# - php-mysqli

#COLORS
# Reset
Color_Off='\033[0m'       # Text Reset

# Regular Colors
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Blue='\033[0;33m'        # Blue
Purple='\033[0;35m'        # Purple
Yellow='\033[0;36m'        # Yellow
echo ""
echo -e "$Purple .---------------------. ______  ______" 
echo -e " | INSTALADOR PROYECTO |[.....°][.....°]"
echo -e " '---------------------'[.....°][.....°]"
echo -e "                        [|||||°][|||||°]"
echo -e "   ____       ____      [|||||°][|||||°]"
echo -e "  |    |     |    |     [_____°][_____°]"
echo -e "  |____|     |____|     [_____°][_____°]"
echo -e "  /::::/     /::::/     [_____°][_____°]$Color_Off"
echo ""
# Almacenamos el directorio actual
INSTALL_DIR=$(pwd)

# Comprobamos si EUID esta vacio y le asignamos un valor
# SI esta vacio es que ya es root
echo -e "${Blue}Comprobando si se ejecuta con sudo: $Color_Off"
USER_ID="$EUID"
if [[ -z "$USER_ID" ]]; then
    USER_ID=0
fi

if [[ $USER_ID = 0 ]]; then
    echo -e "$Green [+] already root $Color_Off"
else
    echo -e "$Red  [-] Error: debes ejecutar el script con sudo. Ejemplo: sudo ./install.sh $Color_Off"
    exit 1
fi

# Seguimos ejecutando el script como sudo
echo -e "${Blue}Comprobando requisitos software: $Color_Off"

IP=$(hostname -I | sed 's/ *$//g')

##################################################
# Utilidades
##################################################
echo -e "${Blue}Utilidades: $Color_Off"

# nodejs
echo -e "${Blue}\nComprobando instalacion de openssh-server: $Color_Off"
if ! [ -x "$(command -v ssh)" ]; then
  echo -e "$Red  [-] Error: openssh-server no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar openssh-server $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos openssh-server
    echo -e "$Yellow  [+] Instalando openssh-server $Color_Off"
    apt install openssh-server
  fi
fi
echo -e "$Green [+] openssh-server esta instalado $Color_Off"

# nodejs
echo -e "${Blue}\nComprobando instalacion de nodejs: $Color_Off"
if ! [ -x "$(command -v nodejs)" ]; then
  echo -e "$Red  [-] Error: nodsjs no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar nodejs $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos nodejs
    echo -e "$Yellow  [+] Instalando nodejs $Color_Off"
    apt install nodejs
  fi
fi
echo -e "$Green [+] nodejs esta instalado $Color_Off"

# npm
echo -e "${Blue}\nComprobando instalacion de npm: $Color_Off"
if ! [ -x "$(command -v npm)" ]; then
  echo -e "$Red  [-] Error: npm no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar npm $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos npm
    echo -e "$Yellow  [+] Instalando npm $Color_Off"
    apt install npm
  fi
fi
echo -e "$Green [+] npm esta instalado $Color_Off"

# forever
echo -e "${Blue}\nComprobando instalacion de forever: $Color_Off"
if ! [ -x "$(command -v forever)" ]; then
  echo -e "$Red  [-] Error: forever no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar forever $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos forever
    echo -e "$Yellow  [+] Instalando forever $Color_Off"
    sudo npm install forever -g
  fi
fi
echo -e "$Green [+] forever esta instalado $Color_Off"

# sendmail
echo -e "${Blue}\nComprobando instalacion de sendmail: $Color_Off"
if ! [ -x "$(command -v sendmail)" ]; then
  echo -e "$Red  [-] Error: sendmail no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar sendmail $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos sendmail
    echo -e"$Yellow  [+] Instalando sendmail $Color_Off"
    apt install sendmail
  fi
fi
echo -e "$Green [+] sendmail esta instalado $Color_Off"

# python3
echo -e "${Blue}\nComprobando instalacion de python3: $Color_Off"
if ! [ -x "$(command -v python3)" ]; then
  echo -e "$Red  [-] Error: python3 no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar python3 $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos python
    echo -e "$Yellow  [+] Instalando python3 $Color_Off"
    apt install python3
  fi
fi
echo -e "$Green [+] python3 esta instalado $Color_Off"

# python3-pip
if ! [ -x "$(command -v pip3)" ]; then
  echo -e "$Red  [-] Error: python3-pip no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar python3-pip $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos python3-pip
    echo -e "$Yellow  [+] Instalando python3 $Color_Off"
    apt install python3-pip
  fi
fi
echo -e "$Green [+] python3-pip esta instalado $Color_Off"

# pywinrm
if [ -z "$(pip3 list | grep pywinrm)" ]; then
  echo -e "$Red  [-] Error: pywinrm no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar pywinrm $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos pywinrm
    echo -e "$Yellow  [+] Instalando pywinrm $Color_Off"
    pip3 install pywinrm
  fi
fi
echo -e "$Green [+] pywinrm esta instalado $Color_Off"

#sshpass
echo -e "${Blue}\nComprobando instalacion de sshpass: $Color_Off"
if ! [ -x "$(command -v sshpass)" ]; then
  echo -e "$Red  [-] Error: sshpass no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar sshpass $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos sshpass
    echo -e "$Yellow  [+] Instalando sshpass $Color_Off"
    apt install sshpass
  fi
fi
echo -e "$Green [+] sshpass esta instalado $Color_Off"

# git
echo -e "${Blue}\nComprobando instalacion de git: $Color_Off"
if ! [ -x "$(command -v git)" ]; then
  echo -e "$Red  [-] Error: git no esta instalado. $Color_Off"
  printf "$Yellow  [?] Quieres que lo instale por ti?[y/N] $Color_Off"
  read  decision
  if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] Para continuar con el instalador debes instalar git $Color_Off"
    echo -e "$Red  [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#utilidades $Color_Off"
    exit 1
  else
    # Instalamos git
    echo -e "$Yellow  [+] Instalando git $Color_Off"
    apt install git
  fi
fi
echo -e "$Green [+] git esta instalado $Color_Off"

# webssh2

echo -e "${Blue}\nComprobando webssh2: $Color_Off"
if [ -z "$(ls -A /var/www/webssh2)" ]; then
  # Clonamos el repositorio en su directorio
  echo -e "$Red [-] Error: la carpeta /var/www/webssh2 esta vacia. $Color_Off"
  echo  -e "$Yellow  [+] Copiando contenido en /var/www/webssh2 $Color_Off"
  git clone https://github.com/billchurch/webssh2.git
  cp -r webssh2/ /var/www/
  sudo npm install /var/www/webssh2/app/ 
  sudo forever start /var/www/webssh2/app/index.js 
  if ! [ $? -eq 0 ]; then
    echo -e "$Red  [-] Ha ocurrido un error al instalar webssh2 $Color_Off"
    exit 1
  fi
fi
echo -e "$Green [+] webssh2 esta instalado $Color_Off"

##################################################
# Apache
##################################################

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
    echo -e "$Yellow  [+] Instalando apache2 $Color_Off"
    apt install apache2
  fi
fi

echo -e "$Green [+] apache2 esta instalado $Color_Off"

##################################################
# php
##################################################
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
    echo -e "$Yellow  [+] Instalando php $Color_Off"
    apt install php
    apt install php-mysqli
  fi
fi

echo -e "$Green [+] php esta instalado $Color_Off"

# De primeras vamos a hacerlo todo en un proyecto.local que tenemos que meter en /etc/hosts
# Cuando este todo montado se mirara de que el usuario pueda meter su propia url por si ya esta en un dominio por 
#   ejemplo pero no es prioridad
#
# Tambien necesitamos crear la carpeta /var/www/proyecto

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
    mkdir /var/www/proyecto
fi
echo -e "$Green [+] Carpeta /var/www/proyecto creada $Color_Off"

# Comprobamos si las carpetas estan vacias
# Si lo estan copiamos los archivos en ellas

echo -e "${Blue}\nComprobando contenido de las carpetas: $Color_Off"
if [ -z "$(ls -A /var/www/proyecto)" ]; then
  # Copiamos el contenido de Web-Proyecto-Content/ en /var/www/proyecto
  echo -e "$Red [-] Error: la carpeta /var/www/proyecto esta vacia. $Color_Off"
  echo  -e "$Yellow  [+] Copiando contenido en /var/www/proyecto $Color_Off"
  cp -r Web-Proyecto-Content/* /var/www/proyecto/
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
    cp files/apache/proyecto.conf /etc/apache2/sites-available/proyecto.conf
    # Activamos el sitio
    # Al usar a2ensite desde fuera de sites-available falla, hacemos cd a la carpeta y volvemos
    echo  -e "$Yellow  [+] Activando sitio $Color_Off"
    cd /etc/apache2/sites-available/
    a2ensite proyecto.conf
    systemctl reload apache2
    cd $INSTALL_DIR
  fi
fi

echo -e "$Green [+] Sitio creado $Color_Off"

# Comprobamos si mysql esta instalado
# mysql requiere configuracion a parte que el usuario tiene que realizar
# Se comprueba si esta instalado:
#   Si no lo esta salta un mensaje de error y se pone la url a la documentacion
#   Si lo esta comprobamos que un usuario "proyecto" este creado

echo -e "${Blue}\nComprobando instalacion de mysql: $Color_Off"
if ! [ -x "$(command -v mysql)" ]; then
  echo -e "$Red [-] Error: mysql no esta instalado. $Color_Off"
  echo -e "$Red [-] Puedes revisar como hacerlo en en http://$IP/posts/instalacion#mysql $Color_Off"
  exit 1
fi
echo -e "$Green [+] mysql instalado. $Color_Off"

# Una vez hayamos comprobado que mysql esta instalado y el usuario existe
# comprobamos si la base de datos proyecto_db esta creada:
#   Si no esta creada salta un mensaje de error y se muestra la documentacion
#   Si esta creada comprobamos que tenemos todos los privilegios sobre esa base de datos
#     Si no los tenemos salta un mensaje de error y se muestra la documentacion
#     Si los tenemos creamos las tablas necesarias para la web

# Leemos el archivo /etc/proyecto/db_config.conf y tratamos de conectarnos con esas credenciales
#Si el archivo no existe creamos la carpeta y copiamos el archivo en ella
echo -e "${Blue}\nComprobando archivo de configuracion de mysql: $Color_Off"
if ! [ -d "/etc/proyecto" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /etc/proyecto $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /etc/proyecto $Color_Off"
    mkdir /etc/proyecto
    echo -e "$Green [+] Carpeta creada $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /etc/proyecto/mysql $Color_Off"
    mkdir /etc/proyecto/mysql
    echo -e "$Green [+] Carpetas creada $Color_Off"
    echo  -e "$Yellow  [+] Copiando archivos de configuracion en /etc/proyecto/mysql $Color_Off"
    cp files/mysql/db_config.conf /etc/proyecto/mysql/db_config.conf
    cp files/mysql/init_db.sql /etc/proyecto/mysql/init_db.sql
    echo -e "$Green [+] Archivos copiados $Color_Off"
    echo  -e "$Yellow  [+] El archivo /etc/proyecto/mysql/db_config.conf contiene una configuracion de ejemplo. $Color_Off"
    echo  -e "$Yellow  [+] Debes editar el archivo y corregir los datos de prueba. $Color_Off"
    exit 1
fi

# Leemos el archivo de configuracion y probamos a conectarnos con esas credenciales
# Primero tenemos que ver si estan, si no las copiamos
echo -e "${Blue}\nComprobando credenciales de mysql: $Color_Off"

# Comprobamos si existe la entrada en /etc/mysql/my.cnf
echo -e "${Blue}\nComprobando archivo /etc/mysql/my.cnf: $Color_Off"
if [ -z "$(cat /etc/mysql/my.cnf | grep clientproyecto)" ]; then
  echo -e "$Red [-] Error: no existe la entrada en /etc/mysql/my.cnf. $Color_Off "
  echo  -e "$Yellow  [+] Copiando /etc/proyecto/mysql/db_config.conf en /etc/mysql/my.cnf. $Color_Off"
  cat /etc/proyecto/mysql/db_config.conf >> /etc/mysql/my.cnf
fi

NUM_LINEA=$(cat -n /etc/mysql/my.cnf | grep clientproyecto | cut -f1)
NUM_LINEA=$((NUM_LINEA + 1))
HOST=$(sed -n ${NUM_LINEA}p /etc/mysql/my.cnf)
NUM_LINEA=$((NUM_LINEA + 1))
USER=$(sed -n ${NUM_LINEA}p /etc/mysql/my.cnf)
NUM_LINEA=$((NUM_LINEA + 1))
PASS=$(sed -n ${NUM_LINEA}p /etc/mysql/my.cnf)
NUM_LINEA=$((NUM_LINEA + 1))
DATABASE=$(sed -n ${NUM_LINEA}p /etc/mysql/my.cnf)

echo -e "${Blue}\nComprobando conexion con la base de datos: $Color_Off"
echo  -e "$Yellow  [+] Se intenta realizar una conexion a mysql con los siguientes datos: $Color_Off"
echo  -e "$Yellow     [+] Host: $HOST $Color_Off"
echo  -e "$Yellow     [+] User: $USER $Color_Off"
echo  -e "$Yellow     [+] Password: $PASS $Color_Off"
echo  -e "$Yellow     [+] Database: $DATABASE $Color_Off"

if ! mysql --defaults-group-suffix=proyecto -e exit; then
  echo -e "$Red [-] Error: Algo ha salido mal. $Color_Off"
  echo -e "$Red [-] Puedes revisar como hacerlo en http://$IP/posts/instalacion#mysql $Color_Off"
  exit 1
fi

echo -e "$Green [+] Conexion realizada con exito. $Color_Off"

# Comprobamos que las tablas estan creadas. Si no lo estan cargamos el archivo /etc/proyecto/mysql/init_db.sql
echo -e "${Blue}\nComprobando tablas de mysql: $Color_Off"
QUERY="use ${DATABASE}; SHOW TABLES;"
if ! [ -z "$(sudo mysql --defaults-group-suffix=proyecto -e $QUERY)" ]; then
  # Se ejecuta el .sql para
  echo -e "$Red [-] Error: la base de datos esta vacia. $Color_Off"
  echo  -e "$Yellow  [+] Creando tablas $Color_Off"
  mysql --defaults-group-suffix=proyecto < /etc/proyecto/mysql/init_db.sql
fi

echo -e "$Green [+] Tablas comprobadas. $Color_Off"

# Comprobamos si HUgo esta instalado
echo -e "${Blue}\nComprobando instalacion de Hugo: $Color_Off"
if ! [ -x "$(command -v hugo)" ]; then
  echo -e "$Red [-] Error: hugo no esta instalado. $Color_Off"
else
  echo -e "$Green [+] Hugo instalado $Color_Off"
fi
echo  -e "$Yellow  [+] La instalacion de Hugo es necesaria solo si quieres tener acceso a la documentacion de forma local $Color_Off"
echo  -e "$Yellow  [+] Dirigete a http://victoravtr.github.io/hugo para ver como $Color_Off"

# Por ultimo, comprobamos que toda la estructura de carpetas en /etc/ y sus archivos se han creado bien
# proyecto/mysql
# 
echo -e "${Blue}\nComprobando carpetas en /etc/: $Color_Off"
if ! [ -d "/etc/proyecto" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /etc/proyecto $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /etc/proyecto $Color_Off"
    mkdir /etc/proyecto
fi
echo -e "$Green [+] Carpeta /etc/proyecto creada $Color_Off"

if ! [ -d "/etc/proyecto/general" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /etc/proyecto/general $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /etc/proyecto/general $Color_Off"
    mkdir /etc/proyecto/general
fi
echo -e "$Green [+] Carpeta /etc/proyecto/general creada $Color_Off"

if ! [ -f "/etc/proyecto/general/exe_switch" ]; then
    echo -e "$Red [-] Error: no existe el archivo exe_switch en /etc/proyecto/general $Color_Off"
    echo  -e "$Yellow  [+] Copiando el archivo $Color_Off"
    cp files/general/exe_switch /etc/proyecto/general/exe_switch
fi
echo -e "$Green [+] Archivo /etc/proyecto/general/exe_switch copiado $Color_Off"

if ! [ -d "/etc/proyecto/zabbix" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /etc/proyecto/zabbix $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /etc/proyecto/zabbix $Color_Off"
    mkdir /etc/proyecto/zabbix
fi
echo -e "$Green [+] Carpeta /etc/proyecto/zabbix creada $Color_Off"

if ! [ -f "/etc/proyecto/zabbix/zabbix_agentd.conf" ]; then
    echo -e "$Red [-] Error: no existe el archivo zabbix_agentd.conf en /etc/proyecto/zabbix/zabbix_agentd.conf $Color_Off"
    echo  -e "$Yellow  [+] Copiando el archivo $Color_Off"
    cp files/zabbix/zabbix_agentd.conf /etc/proyecto/zabbix/zabbix_agentd.conf
fi
echo -e "$Green [+] Archivo /etc/proyecto/zabbix/zabbix_agentd.conf copiado $Color_Off"
if ! [ -f "/etc/proyecto/zabbix/zabbix_agentd32.exe" ]; then
    echo -e "$Red [-] Error: no existe el archivo zabbix_agentd32.exe en /etc/proyecto/zabbix/zabbix_agentd32.exe $Color_Off"
    echo  -e "$Yellow  [+] Copiando el archivo $Color_Off"
    cp files/zabbix/zabbix_agentd32.exe /etc/proyecto/zabbix/zabbix_agentd32.exe
fi
echo -e "$Green [+] Archivo /etc/proyecto/zabbix/zabbix_agentd32.exe copiado $Color_Off"
if ! [ -f "/etc/proyecto/zabbix/zabbix_agentd64.exe" ]; then
    echo -e "$Red [-] Error: no existe el archivo zabbix_agentd64.exe en /etc/proyecto/zabbix/zabbix_agentd64.exe $Color_Off"
    echo  -e "$Yellow  [+] Copiando el archivo $Color_Off"
    cp files/zabbix/zabbix_agentd64.exe /etc/proyecto/zabbix/zabbix_agentd64.exe
fi
echo -e "$Green [+] Archivo /etc/proyecto/zabbix/zabbix_agentd64.exe copiado $Color_Off"

if ! [ -d "/etc/proyecto/mysql" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /etc/proyecto/mysql $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /etc/proyecto/mysql $Color_Off"
    mkdir /etc/proyecto/mysql
fi
echo -e "$Green [+] Carpeta /etc/proyecto/mysql creada $Color_Off"
if ! [ -f "/etc/proyecto/mysql/db_config.conf" ]; then
    echo -e "$Red [-] Error: no existe el archivo exe_switch en /etc/mysql/db_config.conf $Color_Off"
    echo  -e "$Yellow  [+] Copiando el archivo $Color_Off"
    cp files/mysql/db_config.conf /etc/proyecto/mysql/db_config.conf
fi
echo -e "$Green [+] Archivo /etc/proyecto/mysql/init_db.sql copiado $Color_Off"
if ! [ -f "/etc/proyecto/mysql/init_db.sql" ]; then
    echo -e "$Red [-] Error: no existe el archivo exe_switch en /etc/mysql/init_db.sql $Color_Off"
    echo  -e "$Yellow  [+] Copiando el archivo $Color_Off"
    cp files/mysql/init_db.sql /etc/proyecto/mysql/init_db.sql
fi
echo -e "$Green [+] Archivo /etc/proyecto/mysql/init_db.sql copiado $Color_Off"

BLANK_SPACE="  "
echo ""
echo -e "${Purple}${BLANK_SPACE}｜￣￣￣￣￣￣￣￣￣￣￣｜"
echo -e "${BLANK_SPACE}｜Ｉｎｓｔａｌａｃｉｏｎ｜"
echo -e "${BLANK_SPACE}｜ ｆｉｎａｌｉｚａｄａ ｜"
echo -e "${BLANK_SPACE}｜　　　      　　　　  ｜"
echo -e "${BLANK_SPACE}｜　 Ｄｉｓｆｒｕｔａ　 ｜"
echo -e "${BLANK_SPACE}｜　　 　ｄｅｌ　　　　 ｜"
echo -e "${BLANK_SPACE}｜ ｐｒｏｇｒａｍａ！　 ｜"
echo -e "${BLANK_SPACE}｜＿＿＿＿＿＿＿＿＿＿＿｜"
echo -e "${BLANK_SPACE} (\__/) ||"
echo -e "${BLANK_SPACE} (•ㅅ•) ||"
echo -e "${BLANK_SPACE} / 　 づ"
echo ""
echo -e "${BLANK_SPACE} http://proyecto.local$Color_Off"