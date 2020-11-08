**Proyecto**
========

#### TO-DO LIST
- [ ] Opcion para administrar equipos de fuera del dominio
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