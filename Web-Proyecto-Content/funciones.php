<?php 

// con esto evitamos que nos salgan warnings y solo nos avise 
// de errores fatales
error_reporting(E_ERROR);


// conectar con la base de datos
// Se recupera el contenido de db_config.conf y se establece
// una conexion a la base de datos con el contenido del archivo
function conectarBase(){
    ///////////////////////////////////////////////////
    // Dependiendo de tu instalacion de MySQL        //
    // puedes cambiar las siguientes variables en    //
    // el archivo de configuracion en                //
    // /etc/proyecto/mysql/db_config.conf            //
    ///////////////////////////////////////////////////
    $config = file("/etc/proyecto/mysql/db_config.conf");//file in to an array

    $host = explode('=', trim($config[1]))[1];
    $user = explode('=', trim($config[2]))[1];
    $pass = explode('=', trim($config[3]))[1];
    $database = explode('=', trim($config[4]))[1];

    $conexion = mysqli_connect($host, $user, $pass, $database);
    return $conexion;
}


// Comprobar si un usuario existe
// A la funcion se le pasa una conexion, un usuario y un correo
// y por medio de varias consultas a la base de datos se comprueba
// si ya existen registros de ese usuario y correo.
// Devuelve true si ya existe ese usuario y correo y false si no.
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

// Comprobar si las credencuales son correctas
// A la funcion se le pasa una conexion, un usuario y una contraseña,
// se recupera la contraseña asociada al usuario y con se verifica
// que tanto esa contraseña como la que se le pasa como parametro
// coinciden.
// Devuelve true si los datos concuerdan y false si no lo hacen.
function comprobarCredenciales($conexion, $usuario, $contraseña){
    $result = mysqli_query($conexion, "SELECT pass FROM CREDENCIALES WHERE usuario = '$usuario'");
    $row = mysqli_fetch_row($result);
    if (password_verify($contraseña, $row[0])) {
        return true;
    }
    return false;
}

// Registrar nuevo usuario
// A la funcion se le pasa una conexion, un usuario, un correo y una
// contraseña, se calcula el hash de la misma y se insertan los datos
// en la tabla CREDENCIALES
function registrarUsuario($conexion, $usuario, $correo, $contraseña){

    // primero hay que comprobar si hay algun usuario con ese nombre o contraseña
    if (!existeUsuario($conexion, $usuario, $correo)) {
        $contraseña = password_hash($contraseña, PASSWORD_DEFAULT);
        $check = mysqli_query($conexion, "INSERT INTO CREDENCIALES(usuario, pass, correo) VALUES('$usuario', '$contraseña', '$correo')");
        mysqli_free_result($check);
    }
}

// Comprobar si ya existe una solicitud
// A la funcion se le pasa una conexion y un correo y se comprueba si ya
// existe una entrada que corresponda con el correo que se le suministra. 
// Devuelve false si no existe ningun registro asociado a ese correo y true
// si hay alguno.
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

// Registrar solicitud cambio de contraseña
// A la funcion se le pasa una conexion y un correo, comprueba si existe ya
// una solicitud, la borra si la hay y si no la  genera.
// Devuelve el resultado de la query de insercion.
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

// Enviar correo de solicitud de cambio de contraseña
// A la funcion se le pasa una conexion y un correo, consulta en la base de
// datos el codigo de recuperacion asociado con el correo, genera una url
// en base a ese codigo y envia los datos en un correo
function enviarCorreo($conexion, $correo){
    $titulo = "Solicitud de cambio de contraseña";
    $query = mysqli_query($conexion, "SELECT codigo FROM RESET_PASS WHERE correo = '$correo'");
    $codigo = mysqli_fetch_row($query)[0];
    $enlace = "http://proyecto.local/contra.php?code=".$codigo;
    $mensaje = "Se ha solicitado un cambio de contraseña para esta direccion de correo electronico.\n
                            Sigue el siguiente enlace para realizar el cambio: $enlace \n
                            Si no has sido tu puedes ignorar este mensaje.";
    mail($correo, $titulo, $mensaje,'From: admin@proyecto.local','-f admin@proyecto.local');
}

// Realizar un cambio de contraseña
// A la funcion se le pasa una conexion, una contraseña y un codigo, se busca
// el correo asociado al codigo , se genera el hash de la nueva contraseña y se actualiza
// la base de datos con los nuevos datos. Por ultimo, se borra la solicitud de cambio de
// contraseña asociada con ese correo.
function cambiarPass($conexion, $pass, $codigo){
    $correo = mysqli_query($conexion, "SELECT correo FROM RESET_PASS WHERE codigo = '$codigo'");
    $correo = mysqli_fetch_row($correo)[0];
    
    $pass = password_hash($pass, PASSWORD_DEFAULT);
    $query = mysqli_query($conexion, "UPDATE CREDENCIALES SET pass = '$pass' WHERE correo = '$correo'");

    $borrado = mysqli_query($conexion, "DELETE FROM RESET_PASS WHERE correo = '$correo'");
    return $query;
}

// Comprobar si ya existe una solicitud de cambio de contraseña 
// A la funcion se le pasa una conexion y un codigo y comprueba que ese codigo no exista
// en la base de datos. 
// Se devuelve true si existe y false si no.
function comprobarCodigo($conexion, $codigo) {
    $query = mysqli_query($conexion, "SELECT COUNT(*) FROM RESET_PASS WHERE codigo = '$codigo'");
    $row = mysqli_fetch_row($query);
    if ($row[0] == 1) {
        return true;
    }
    return false;
}

?>