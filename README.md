**Proyecto**
========

#### LO-QUE-VOY-HACIENDO LIST
- Agosto +/- = version 1.0 del login
- Del 26 Octubre al 8 de Noviembre = Instalador
- Del 9 al 15 de Octubre = terminar login al 100% y script de busqueda automatica de equipos intentos de login.

#### TO-DO LIST
- [ ] Meter nmap en instalador
- [ ] Cambiar todas las rutas relativas a rutas absolutas
- [ ] Para comprobar si PSRemoting esta habilitado tenemos que conectarnos por ssh, descargarnos un script y ejecutarlo
- [ ] En los scripts de conexion devolver "codigo_error;motivo_de_error" en vez de solo el codigo
- [ ] Al final no tiramos de psexec, la version para linux da problemas al instalarla y es muy antigua
- [ ] Meter winrm en el instalador
  - [ ] Necesita python y pip de primeras
- [ ] Pasos para meter equipo en dominio:
  - [ ] Buscar si en el dominio hay una entrada en los DNS (?)
  - [ ] Cambiar DNS equipo por los del dominio, IP tambien si fuese necesario
  - [ ] Incluir equipo en dominio
  - [ ] Reiniciar
  - [ ] Comprobar que se ha metido bien al dominio iniciando sesion en el propio equipo y luego por ssh
  - [ ] Mostrar mensaje indicativo de que se ha realizado la union pero y que pueden iniciar sesion ya en el equipo
  - [ ] Preparar plantilla de cambios que se pueden hacer de primeras por GPO, rollo mantener el ssh y cosas asi
- [ ] En documentacion meter apartado con descripcion de ssh, winrm, etc, etc con pros y contras
- [ ] Ya que vamos a hacer cositas con ssh, mirar si se pueden meter en los equipos fail2ban
- [ ] Desplegar .exe e instalarlos en otros equipos de forma automatica
- [ ] Instalar agente zabbix, sin proxy de primeras, y alienvault y configurarlo
- [ ] Opcion para administrar equipos de fuera del dominio
- [ ] Meter sshpass en la instalacion
- [ ] Meter en documentacion y script de instalacion que si el programa no funciona habria que descomentar la linea de extension=mysql en php.ini
- [ ] Con hugo -D podemos crear una copia estatica de la documentacion por lo que no necesita el serve continuamente
  - [ ] Revisar como generarla bien, por algun motivo falla
  - [ ] Indicar en el instalador y en la documentacion que si se quiere hacer cualquier cambio como hacerlo
  - [ ] Indicar en la documentacion y en el instalador una referencia a la documentacion de hugo
- [ ] Generar doc de timeline de los repositorios de github para la documentacion
- [ ] Instalacion mysql
  - [ ] apt install mariadb-server
  - [ ] ejecutamos el comando "sudo mysql_secure_installation
    - [ ] le metemos la password de root
    - [ ] removemos usuarios anonimos
    - [ ] no desactivamos el acceso root anonimo
    - [ ] quitamos las tablas de test
    - [ ] recargamos la tabla de privilegios
  - [ ] nos logeamos en mysql como root con "sudo mysql -u root -p"
  - [ ] CREATE USER 'proyecto'@'%' IDENTIFIED BY 'Alisec$2018';
  - [ ] CREATE DATABASE proyecto_db;
  - [ ] GRANT ALL PRIVILEGES ON proyecto_db.* TO 'proyecto'@'%';
  - [ ] FLUSH PRIVILEGES;
    
- [ ] Buscar forma de almacenar .conf de forma segura, rollo encriptar password, pero no es prioridad
- [ ] Comprobar con el metodo que me dio Carlos de $? que los comandos se ejecutan bien
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
  - [ ] Quitar las funciones de php que crean las tablas de la base de datos y meterlas en un .sql