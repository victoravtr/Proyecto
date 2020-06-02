<?php 

// con esto evitamos que nos salgan warnings y solo nos avise 
// de errores fatales
error_reporting(E_ERROR);


// conectar con la base de datos
function conectarBase(){
    ///////////////////////////////////////////////////
    // Dependiendo de tu instalacion de MySQL        //
    // puedes cambiar las siguientes variables en    //
    // el archivo de configuracion config.json       //
    ///////////////////////////////////////////////////
    $config = file_get_contents("config.json");
    $json = json_decode($config, true);

    $host = trim($json['credenciales']['host']);
    $user = trim($json['credenciales']['user']);
    $pass = trim($json['credenciales']['pass']);

    $conexion = mysqli_connect($host, $user, $pass);

    return $conexion;
}

//comprobar si AADAD existe
function existeBD($conexion){
    // cambiamos la base de datos actual a AADAD
    mysqli_select_db($conexion, "aadad");

    // comprobamos si la base de datos actual es AADAD
    // si lo es la base de datos existe, si no no existe
    $result = mysqli_query($conexion, "SELECT DATABASE()");
    $row = mysqli_fetch_row($result);
    if ($row[0] == "aadad") {
        mysqli_free_result($result);
        return true;
    } 
    return false;
}

// Crear base de datos y tablas
function crearBaseDatos($conexion){
    
    $check = mysqli_query($conexion, "CREATE DATABASE aadad");
    
    // comprobamos que la sentencia se ha ejecutado correctamente y continuamos
    if ($check) {
        
        $check = mysqli_select_db($conexion, "aadad");
        if ($check) {
            
            $check = mysqli_query($conexion, "create table CREDENCIALES(
                                                            usuario varchar(10) not null, 
                                                            pass varchar(255) not null, 
                                                            correo varchar(50) not null, 
                                                            constraint credenciales_pk primary key (usuario))");
            if ($check) {
                mysqli_free_result($check);
            } else {
                echo "No se han creado las tablas";
            }
        } else {
            echo "No se ha cambiado la base de datos: ".mysqli_error($conexion);
        }
    } else {
        echo "No se ha creado la base de datos: ".mysqli_error($conexion);
    }
}

// comprobar si un usuario existe
function existeUsuario($conexion, $usuario, $correo) {

    if ($correo == null) {
        $result = mysqli_query($conexion, "SELECT COUNT(*) FROM CREDENCIALES WHERE usuario = '$usuario'");
    } 
    if ($usuario == null) {
        $result = mysqli_query($conexion, "SELECT COUNT(*) FROM CREDENCIALES WHERE correo = '$correo'");
    }
    
    $row = mysqli_fetch_row($result);

    if ($row[0] == 0) {
        mysqli_free_result($result);
        return false;
    }
    mysqli_free_result($result);
    return true;
}

// comprobar si las credencuales son correctas
function comprobarCredenciales($conexion, $usuario, $contraseña){
    $result = mysqli_query($conexion, "SELECT pass FROM CREDENCIALES WHERE usuario = '$usuario'");
    $row = mysqli_fetch_row($result);
    if (password_verify($contraseña, $row[0])) {
        return true;
    }
    return false;
}

// registrar nuevo usuario
function registrarUsuario($conexion, $usuario, $correo, $contraseña){

    // primero hay que comprobar si hay algun usuario con ese nombre o contraseña
    if (!existeUsuario($conexion, $usuario, $correo)) {
        $contraseña = password_hash($contraseña, PASSWORD_DEFAULT);
        $check = mysqli_query($conexion, "INSERT INTO CREDENCIALES(usuario, pass, correo) VALUES('$usuario', '$contraseña', '$correo')");
        mysqli_free_result($check);
    }
}

// comprobar si ya existe una solicitud
function comprobarSolicitudResetPass($conexion, $correo) {
    $result = mysqli_query($conexion, "SELECT * FROM RESET_PASS WHERE correo = '$correo'");
    $row = mysqli_fetch_row($result);

    if ($row[0] == 0) {
        mysqli_free_result($result);
        return false;
    }
    mysqli_free_result($result);
    return true;
    
}

// registrar solicitud cambio de contraseña
function registrarSolicitudResetPass($conexion, $correo) {

    // comprobamos si la solicitud ya existe
    if (comprobarSolicitudResetPass($conexion, $correo)) {
        echo "La solitud ya existe";
        // La solicitud ya existe, la borramos y creamos una nueva
        $query = mysqli_query($conexion, "DELETE FROM RESET_PASS WHERE correo = '$correo'");
    } 
    // Si no existe simplemente creamos una
    $codigo = hash('sha256', $correo.getDate()[0]);

    $query = mysqli_query($conexion, "INSERT INTO RESET_PASS(correo, codigo, fecha_peticion, fecha_limite) VALUES('$correo', '$codigo', CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR) )");

}

?>