**Proyecto**
========

#### LO-QUE-VOY-HACIENDO LIST
- Agosto +/- = version 1.0 del login
- Del 26 Octubre al 8 de Noviembre = Instalador
- Del 9 al 15 de Noviembre = terminar login al 100% y script de para testear conexion.
- Del 16 al 20 de Noviembre = apartado para despliegue de software
- Del 20 al 23 de Noviembre = apartado para union equipos a dominio
- Del 24 al 26 de Noviembre = apartado para instalacion agentes Zabbix
- Del 27 al 28 de Noviembre = apartado para instalacion agentes alienvault
      - Se decide no continuar con este apartado ya que Alienvault ya cuenta con las opciones necesarias para realizar el deployment de forma sencilla
- Del 28 al 29 de Noviembre = apartado para ejecucion de comandos y shell
- Del 30 al 4 de Diciembre = testeo y correccion de errores
- Del 5 al 6 de Diciembre = preparacion de documentacion
- Del 7 al 8 de Diciembre = documentacion proyecto y grabacion + edicion de video presentacion
###  Hardware Usado
- Servidor Debian 2GB Ram
- 1 CPU
- 50GB HDD
- Requisito controlador de dominio: minimo la edicion 2010 para poder instalar OpenSSH

### Software usado
- Todo opensource asi que F
- VSCode para el desarrollo
- Librerias varias

### Testeo
- [ ] Revisar si habria que darle permisos de sudo a www-data para ejecutar los scripts de /etc/proyecto

### Documentacion
- [ ] Hacer una tabla para la documentacion en que aparezca cada sistema operativo en el que se ha probado y si la prueba ha sido satisfactoria o no
- [ ] Meter  aviso de que algunos programas no funcionan. Chrome por ejemplo falla porque el instalador primero descargar el programa y despues lo instala el mismo
- [ ] Hacer apartado de troubleshoting en documentacion para los fallos que puede haber y como solucionarlos. Aqui iran las cosas del estilo:
      - [ ] Editar php.ini para meter mas upload_max_filesize y post_max_size
      - [ ] Meter en documentacion y script de instalacion que si el programa no funciona habria que descomentar la linea de extension=mysql en php.ini
- [ ] meter apartado con descripcion de ssh, winrm, etc, etc con pros y contras
- [ ] Con hugo -D podemos crear una copia estatica de la documentacion por lo que no necesita el serve continuamente
- [ ] Generar doc de timeline de los repositorios de github para la documentacion
- [ ] Instalacion mysql
  - apt install mariadb-server
  - ejecutamos el comando "sudo mysql_secure_installation
    - le metemos la password de root
    - removemos usuarios anonimos
    - no desactivamos el acceso root anonimo
    - quitamos las tablas de test
    - recargamos la tabla de privilegios
  - nos logeamos en mysql como root con "sudo mysql -u root -p"
  - CREATE USER 'proyecto'@'%' IDENTIFIED BY 'Alisec$2018';
  - CREATE DATABASE proyecto_db;
  - GRANT ALL PRIVILEGES ON proyecto_db.* TO 'proyecto'@'%';
  - FLUSH PRIVILEGES;

### Posibles mejoras version 2.0
- [ ] Uso de algun framework como angular 
- [ ] Ya que vamos a hacer cositas con ssh, mirar si se pueden meter en los equipos fail2ban
- [ ] Buscar forma de almacenar .conf de forma segura, rollo encriptar password, pero no es prioridad

#### TO-DO LIST

    
- [ ] Cmbiar url script instalacion por las url de mi propia web o las del repositorio de github directamente
  - [ ] Dar la opcion de instalar o no la documentacion, indicando que esta en mi web y en github pero puede
        no estar disponible siempre
- [ ] En el sitio proyecto.local incluir una pagina requisitos.php que compruebe si todo esta bien instalado
  - [ ] Se podria guardar en un archivo con variables rollo apache2_installed : true y presentarlo de forma bonita
  - [ ] Si el instalador falla se cambia el index.html por uno que diga los requisitos que estan bien y los que estan mal
- [ ] Revisar que hacer cuando alguien intenta recuperar una contraseña con un codigo sin que ese codigo exista
- [ ] Al cambiar la contraseña se tiene que borrar la solicitud
- [ ] Revisar que las funciones están comentadas
- [ ] Revisar los outputs y dejarlos bonitos (Caja transparente con borde verde por ejemplo)
- [ ] Pasar el contenido de test.php a contra.php
- [ ] Hacer listado de requisitos y de instalación
  - [ ] LAMP
  - [ ] Libreria para ssh y herramientas para instalarla
  - [ ] Lo que uso para el correo
- [ ] Crear script bash para instalacion de requisitos
  - [ ] Necesita tener:
    - [ ] MySQL
    - [ ] Apache2
    - [ ] PHP