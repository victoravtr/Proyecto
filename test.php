<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>¿Has olvidado tu contraseña?</title>
  <link rel="stylesheet" href="style.css">

</head>
<body>

<form action="test.php" method="POST" class="card" autocomplete="off">

  <h1>¿Has olvidado tu contraseña?</h1>

  <?php
    if (!isset($_GET['code'])) {
        echo '
        <div class="form__group field">
        <input type="email" class="form__field" placeholder="Correo" name="correo" id="correo"/>
        <label for="correo" class="form__label">Correo</label>
      </div>
      <input type="submit" class="boton" name="correo_submit" value="Recuperar contraseña"/>
      ';
    } else {
        echo '
        <div class="form__group field">
            <input type="password" class="form__field" placeholder="Nueva contraseña" name="pass" id="pass"/>
            <label for="pass" class="form__label">Nueva contraseña</label>
        </div>

        <div class="form__group field">
            <input type="password" class="form__field" placeholder="Confirmar contraseña" name="pass_confirmar" id="pass_confirmar"/>
            <label for="pass_confirmar" class="form__label">Confirmar contraseña</label>
        </div>

        <input type="submit" class="boton" name="reset_pass_submit" value="Cambiar contraseña"/>
      ';
    }
  ?>



  <br>
  <div class="links">
    <a href="login.php">Iniciar sesión</a>
    <br>
    <a href="registro.php">¡Registrate aqui!</a>
  </div>
</form>
	
	
	<?php

		// importamos el archivo con las funciones
		include("funciones.php");

        //Solo se ejecutará cuando le demos a iniciar sesión
        if (isset($_POST['correo_submit'])) {
            // Si el $_POST es correo tenemos que generar una solicitud de cambio de contraseña: 
            //  - Comprobamos que el correo existe: si no existe mostramos un error, si existe continuamos
            //  - Comprobamos si ya existe alguna solicitud para ese correo: si existe, la borramos y
            //      continuamos, si no existe continuamos sin mas
            //  - Cuando hayamos comprobado que el correo existe y que no hay ninguna solicitud, o la
            //      hemos borrado, insertamos en la tabla RESET_PASS la solicitud y enviamos un correo
            //      a la direccion indicada con el link para cambiar la contraseña

            // // inicializamos las variables
            // // con trim eliminamos los espacios en blanco
            $cadena_errores = "Error al procesar los datos del formulario:";
            $conexion = conectarBase();
            $error = false;
			$correo = trim($_POST["correo"]);
			
			// si las variables estan vacias la variable $error cambia de valor
			if (empty($correo)) {
                $cadena_errores = $cadena_errores."\\n No has introducido un correo";
				$error=true;
            }
            
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

						// Si existe comprobamos que si el correo existe
						if (existeUsuario($conexion, null, $correo)) {

							// Si existe comprobamos registramos la solicitud, comprobando si ya existe una
							$check = registrarSolicitudResetPass($conexion, $correo);
							if ($check) {
								echo "La solicitud se ha registrado correctamente";
							} else {
								echo "wat";
							}


						} else {
							// Si no existe mostramos un mensaje de error
							$cadena_errores_bd = $cadena_errores_bd."\\n Ese correo no existe.";
							echo '<script> alert("'.$cadena_errores_bd.'")</script>';
		
						}
					} else {
		
						// Si no existe mostramos un mensaje de error
						$cadena_errores_bd = $cadena_errores_bd."\\n La base de datos no existe.";
						$cadena_errores_bd = $cadena_errores_bd."\\n Debes crear un nuevo usuario, la base de datos se creará automáticamente.";
						echo '<script> alert("'.$cadena_errores_bd.'")</script>';
					}
		
				}
			} else {
				echo '<script> alert("'.$cadena_errores.'")</script>';
			}

    }
    

        if (isset($_POST['reset_pass'])) {
            // Si el $_POST es correo tenemos que generar una solicitud de cambio de contraseña: 
            //     - Primero consultamos que correo tiene asignado el codigo introducido:
            //     - Una vez tengamos ese correo, cambiariamos la contraseña asignada a ese correo 
            //     - Si se ha producido el cambio sin errores, borramos la solicitud de la base de datos

            $error = false;
			$user = trim($_POST["user"]);
			$pass = trim($_POST["reset_pass"]);
			
			// si las variables estan vacias la variable $error cambia de valor
			if (empty($pass)) {
                $error = true;
            }

    }
    ?>

</body>
</html>