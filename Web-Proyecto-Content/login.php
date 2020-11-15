<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>Iniciar sesión</title>
  <link rel="stylesheet" href="assets/styles/style.css">

</head>
<body>

<form action="login.php" method="POST" class="card" autocomplete="off">

  <h1>Iniciar sesión</h1>

  <div class="form__group field">
	<input type="text" class="form__field" placeholder="Usuario" name="usuario" id="user" value="<?php if (isset($_POST["usuario"]) != "") { echo $_POST["usuario"]; } ?>">
    <label for="user" class="form__label">Usuario</label>
  </div>

  <div class="form__group field">
    <input type="password" class="form__field" placeholder="Contraseña" name="pass" id="pass"/>
    <label for="pass" class="form__label">Contraseña</label>
  </div>

  <input type="submit" class="boton" name="login" value="Iniciar sesión"/>

  <br>
  <div class="links">
    <a href="registro.php">¡Registrate aquí!</a>
    <br>
    <a href="contra.php">¿Has olvidado tu contraseña?</a>
  </div>
</form>
	
	
<?php

// importamos el archivo con las funciones
include("funciones.php");

//Solo se ejecutará cuando le demos a iniciar sesión
if (isset($_POST["login"])) {
	$cadena_errores = "Error al procesar los datos del formulario:";
	// inicializamos las variables
	// con trim eliminamos los espacios en blanco
	$error = false;

	$usuario = trim($_POST["usuario"]);
	$contraseña = trim($_POST["pass"]);
	
	// si las variables estan vacias la variable $error cambia de valor
	if (empty($usuario)) {
		$error=true;
		$cadena_errores = $cadena_errores."\\n No has introducido un usuario";
	}
	if (empty($contraseña)) {
		$cadena_errores = $cadena_errores."\\n No has introducido una contraseña";
		$error=true;
	}

	// solo se ejecutara si la variable $error es false
	if (!$error) {
		$cadena_errores_bd = "Error al operar con la base de datos:";
		$conexion = conectarBase();
		
		// comprobamos si la conexion se ha realizado correctamente
		if (!$conexion) {
			$cadena_errores_bd = $cadena_errores_bd."\\n Error al intentar conectar con la base de datos.";
			$cadena_errores_bd = $cadena_errores_bd."\\n".mysqli_error($conexion);
			echo '<script> alert("'.$cadena_errores_bd.'")</script>';
		} else {
			// Comprobamos que  el usuario existe
			if (existeUsuario($conexion, $usuario, null)) {
				// comprobamos que las credenciales son correctas
				$check = comprobarCredenciales($conexion, $usuario, $contraseña);
				if ($check) {
					// las credenciales estan bien, redirigimos al usuario a index.php
					session_start();
					$_SESSION["usuario"] = $usuario;

					header("Location:index.php");
				}
				$cadena_errores_bd = $cadena_errores_bd."\\n Las credenciales no son correctas.";
				echo '<script> alert("'.$cadena_errores_bd.'")</script>';
			} else {
				// Si no existe mostramos un mensaje de error
				$cadena_errores_bd = $cadena_errores_bd."\\n Ese usuario no existe.";
				echo '<script> alert("'.$cadena_errores_bd.'")</script>';

			}

		}
	} else {
		echo '<script> alert("'.$cadena_errores.'")</script>';
	}
	// FALTA DEJAR BONITOS LOS ECHO DE CUANDO SE CREAN LOS USUARIOS Y CAMBIAR LA PASS POR UN HASH
	// REVISAR ADEMAS TODOS LOS MENSAJES DE ERROR
	
}
?>

</body>
</html>