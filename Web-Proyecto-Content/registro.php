<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>Registrar usuario</title>
  <link rel="stylesheet" href="style.css">

</head>
<body>

<form action="registro.php" method="POST" class="card" autocomplete="off">

  <h1>Registro</h1>

  <div class="form__group field">
    <input type="text" class="form__field" placeholder="Usuario" name="usuario" id="usuario" value="<?php if (isset($_POST["usuario"]) != "") { echo $_POST["usuario"]; } ?>"/>
	<label for="usuario" class="form__label">Usuario</label>
  </div>

  <div class="form__group field">
    <input type="email" class="form__field" placeholder="Correo" name="correo" id="correo" value="<?php if (isset($_POST["correo"]) != "") { echo $_POST["correo"]; } ?>"/>
    <label for="correo" class="form__label">Correo</label>
  </div>
  
  <div class="contraseñas">
	<div class="form__group field">
		<input type="password" class="form__field" placeholder="Contraseña" name="pass" id="pass"/>
		<label for="pass" class="form__label">Contraseña</label>
	</div>

	<div class="form__group field">
		<input type="password" class="form__field" placeholder="Confirmar contraseña" name="pass_confirmar" id="pass_confirmar"/>
		<label for="pass_confirmar" class="form__label">Confirmar contraseña</label>
	</div>
  </div>

  <input type="submit" class="boton" name="registro" value="Registrar usuario"/>
  <br>
  <div class="links">
    <a href="login.php">Iniciar sesión</a>
    <br>
    <a href="contra.php">¿Has olvidado tu contraseña?</a>
  </div>
</form>
	
	
	<?php

		// importamos el archivo con las funciones
		include("funciones.php");

        //Solo se ejecutará cuando le demos a iniciar sesión
        if (isset($_POST["registro"])) {
			$cadena_errores = "Error al procesar los datos del formulario:";
            // inicializamos las variables
            // con trim eliminamos los espacios en blanco
			$error = false;

			$usuario = trim($_POST["usuario"]);
			$correo = trim($_POST["correo"]);
			$contraseña = trim($_POST["pass"]);
			$contraseña_confirmar = trim($_POST["pass_confirmar"]);
			
			// si las variables estan vacias la variable $error cambia de valor
			if (empty($usuario)) {
				$error=true;
				$cadena_errores = $cadena_errores."\\n No has introducido un usuario";
			}
			if (empty($correo)) {
				$cadena_errores = $cadena_errores."\\n No has introducido un correo";
				$error=true;
			}
			if (empty($contraseña)) {
				$cadena_errores = $cadena_errores."\\n No has introducido una contraseña";
				$error=true;
			}
			if (empty($contraseña_confirmar)) {
				$cadena_errores = $cadena_errores."\\n No has introducido una contraseña de confirmación";
				$error=true;
			}

			// si las variables no están vacías confirmamos que las contraseñas coinciden
			if (!$error) {
				if ($contraseña != $contraseña_confirmar) {
					$cadena_errores = $cadena_errores."\\n Las contraseñas no coinciden";
					$error = true;
				}
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
					// comprobamos si la base de datos "AADAD" existe"
					if (existeBD($conexion)) {
						// Si existe comprobamos que no hay ningun usuario con ese nombre o correo
						if (existeUsuario($conexion, $usuario, $correo)) {
							$cadena_errores_bd = $cadena_errores_bd."\\n Ya existe un usuario con ese nombre o correo.";
						} else {
							registrarUsuario($conexion, $usuario, $correo, $contraseña);
							echo "<h1>Se ha creado el usuario $usuario</h1>";
						}
					} else {
						// Si no existe la creamos y registramos al usuario
						crearBaseDatos($conexion);
						registrarUsuario($conexion, $usuario, $correo, $contraseña);
						echo "<h1>Se ha creado el usuario $usuario y la base de datos</h1>";
						
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