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
    $USER_ID=0
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
    apt install apache2
  fi
fi

echo -e "$Green [+] apache2 esta instalado $Color_Off"


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
    apt install php
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
  cp Web-Proyecto-Content/* /var/www/proyecto/
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
if [ -z "$(sudo mysql --defaults-group-suffix=proyecto -e $QUERY)" ]; then
  # Copiamos el contenido de Web-Proyecto-Content/ en /var/www/proyecto
  echo -e "$Red [-] Error: la base de datos esta vacia. $Color_Off"
  echo  -e "$Yellow  [+] Creando tablas $Color_Off"
  mysql --defaults-group-suffix=proyecto < /etc/proyecto/mysql/init_db.sql
fi

echo -e "$Green [+] Tablas comprobadas. $Color_Off"

echo -e "${Blue}\nPuedes acceder a la documentacion desde la siguiente url: $Color_Off"
echo -e "   ${Purple}http://documentacion.victorav.me $Color_Off"
echo -e "${Blue}Pero debes de tener en cuenta que puede no estar siempre disponible."
echo -e "${Blue}Por eso, es recomendable instalarla en el mismo equipo que el programa. $Color_Off"

printf "$Yellow  [?] Quieres que la instale?[y/N] $Color_Off"
read  decision
if [[ "$decision" != "y" ]]; then
    echo -e "$Red  [-] No se instalara la documentacion. $Color_Off"
    echo  -e "$Yellow  [+] Si quieres instalarla en un futuro puedes ver como en http://documentacion.victorav.me/documentacion $Color_Off"
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
    exit 1
fi

# Comprobamos si existe la entrada en /etc/hosts
echo -e "${Blue}\nComprobando archivo /etc/hosts: $Color_Off"
if [ -z "$(cat /etc/hosts | grep documentacion.local)" ]; then
  echo -e "$Red [-] Error: no existe la entrada ' $IP  documentacion.local ' en /etc/hosts. $Color_Off "
  echo  -e "$Yellow  [+] Creando entrada $Color_Off"
  command echo "$IP documentacion.local" >> /etc/hosts
fi

echo -e "$Green [+] Archivo /etc/hosts comprobado $Color_Off"

# Comprobamos si ya existen las carpetas en /var/www
echo -e "${Blue}\nComprobando carpetas en /var/www/: $Color_Off"

if ! [ -d "/var/www/doc-proyecto" ]; then
    echo -e "$Red [-] Error: no existe la carpeta /var/www/doc-proyecto $Color_Off"
    echo  -e "$Yellow  [+] Creando la carpeta /var/www/doc-proyecto $Color_Off"
    mkdir /var/www/doc-proyecto
fi
echo -e "$Green [+] Carpeta /var/www/doc-proyecto creada $Color_Off"

# Comprobamos si las carpetas estan vacias
# Si lo estan copiamos los archivos en ellas

echo -e "${Blue}\nComprobando contenido de las carpetas: $Color_Off"
if [ -z "$(ls -A /var/www/doc-proyecto)" ]; then
  # Copiamos el contenido de Web-Proyecto-Content/ en /var/www/proyecto
  echo -e "$Red [-] Error: la carpeta /var/www/doc-proyecto esta vacia. $Color_Off"
  echo  -e "$Yellow  [+] Copiando contenido en /var/www/doc-proyecto $Color_Off"
  cp -r Documentacion-Proyecto-Content/ /var/www/doc-proyecto/
fi


# Comprobamos si ya se han copiado los archivos de configuracion en el directorio /etc/apache2/sites-available
echo -e "${Blue}\nComprobando archivos de configuracion de apache2: $Color_Off"

if ! [ -a "/etc/apache2/sites-available/documentacion.conf" ]; then
  echo -e "$Red [-] Error: no existe el archivo proyecto.conf en /etc/apache2/sites-available. $Color_Off "
  echo  -e "$Yellow  [+] Copiando archivo $Color_Off"
  cp files/apache/documentacion.conf /etc/apache2/sites-available/documentacion.conf
  # Activamos el sitio
  # Al usar a2ensite desde fuera de sites-available falla, hacemos cd a la carpeta y volvemos
  echo  -e "$Yellow  [+] Activando sitio $Color_Off"
  cd /etc/apache2/sites-available/
  a2ensite documentacion.conf
  systemctl reload apache2
  cd $INSTALL_DIR
fi

echo -e "$Green [+] Sitio creado $Color_Off"

echo -e "${Blue}\nComprobando instalacion de Hugo: $Color_Off"
if ! [ -x "$(command -v hugo)" ]; then
  echo -e "$Red [-] Error: hugo no esta instalado. $Color_Off"
  echo  -e "$Yellow  [+] Instalando Hugo $Color_Off"
  apt install hugo
fi

echo -e "$Green [+] Hugo instalado $Color_Off"
echo  -e "$Yellow  [+] La instalacion de Hugo es necesaria solo si quieres realizar algun cambio en la documentacion $Color_Off"
echo  -e "$Yellow  [+] Dirigete a http://documentacion.local/hugo para ver como $Color_Off"

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
echo -e "${BLANK_SPACE} http://documentacion.local"
echo -e "${BLANK_SPACE} http://proyecto.local$Color_Off"