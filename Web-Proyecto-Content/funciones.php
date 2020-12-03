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
    $config = file("/etc/proyecto/mysql/db_config.conf");//file in to an array

    $host = explode('=', trim($config[1]))[1];
    $user = explode('=', trim($config[2]))[1];
    $pass = explode('=', trim($config[3]))[1];
    $database = explode('=', trim($config[4]))[1];

    $conexion = mysqli_connect($host, $user, $pass, $database);
    return $conexion;
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
    $result = mysqli_query($conexion, "SELECT COUNT(*) FROM RESET_PASS WHERE correo = '$correo'");
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
        // La solicitud ya existe, la borramos y creamos una nueva
        //Probar query, no borra ninguna entrada
        $query = mysqli_query($conexion, "DELETE FROM RESET_PASS WHERE correo = '$correo'");
    } 
    // Si no existe simplemente creamos una
    $codigo = hash('sha256', $correo.getDate()[0]);

    $query = mysqli_query($conexion, "INSERT INTO RESET_PASS(correo, codigo, fecha_peticion, fecha_limite) VALUES('$correo', '$codigo', CURRENT_TIMESTAMP(), DATE_ADD(CURRENT_TIMESTAMP(), INTERVAL 1 HOUR) )");
    return $query;
}

function enviarCorreo($conexion, $correo){
    $titulo = "Solicitud de cambio de contraseña";
    $query = mysqli_query($conexion, "SELECT codigo FROM RESET_PASS WHERE correo = '$correo'");
    $codigo = mysqli_fetch_row($query)[0];
    $enlace = "http://proyecto.local/contra.php?code=".$codigo;
    $mensaje = "Se ha solicitado un cambio de contraseña para esta direccion de correo electronico.\n
                            Sigue el siguiente enlace para realizar el cambio: $enlace \n
                            Si no has sido tu puedes ignorar este mensaje.";
    mail($correo, $titulo, $mensaje);
}

function cambiarPass($conexion, $pass, $codigo){
    // Buscamos el correo asociado al codigo que le pasamos por el GET
    // Generamor la nueva contraseña y actualizamos la base de datos
    // Si todo ha salido bien borramos la solicitud
    $correo = mysqli_query($conexion, "SELECT correo FROM RESET_PASS WHERE codigo = '$codigo'");
    $correo = mysqli_fetch_row($correo)[0];
    
    $pass = password_hash($pass, PASSWORD_DEFAULT);
    $query = mysqli_query($conexion, "UPDATE CREDENCIALES SET pass = '$pass' WHERE correo = '$correo'");

    $borrado = mysqli_query($conexion, "DELETE FROM RESET_PASS WHERE correo = '$correo'");
    return $query;
}

// Comprobamos que los codigos que se le pasan como parametro existan en la base de datos
function comprobarCodigo($conexion, $codigo) {
    $query = mysqli_query($conexion, "SELECT COUNT(*) FROM RESET_PASS WHERE codigo = '$codigo'");
    $row = mysqli_fetch_row($query);
    if ($row[0] == 1) {
        return true;
    }
    return false;
}

function comprobarConexion() {

}

?>