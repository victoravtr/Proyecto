<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>¿Has olvidado tu contraseña?</title>
  <link rel="stylesheet" href="style.css">

</head>
<body>

<form action="<?php $_SERVER['PHP_SELF'] ?>" method="POST" class="card" autocomplete="off">

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
            <input type="password" class="form__field" placeholder="Nueva contraseña" name="password" id="password"/>
            <label for="password" class="form__label">Nueva contraseña</label>
        </div>

        <div class="form__group field">
            <input type="password" class="form__field" placeholder="Confirmar contraseña" name="password_confirmar" id="password_confirmar"/>
            <label for="password_confirmar" class="form__label">Confirmar contraseña</label>
        </div>

        <input type="submit" class="boton" name="reset_password_submit" value="Cambiar contraseña"/>
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
                enviarCorreo($conexion, $correo);
								echo "<h1>La solicitud se ha registrado correctamente.<br>Revisa tu correo electronico.</h1>";
							} else {
								echo "<h1>La solicitud no se ha registrado correctamente</h1>";
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
    

        if (isset($_POST['reset_password_submit'])) {
            // Si el $_POST es correo tenemos que generar una solicitud de cambio de contraseña: 
            //     - Primero consultamos que correo tiene asignado el codigo introducido:
            //     - Una vez tengamos ese correo, cambiariamos la contraseña asignada a ese correo 
            //     - Si se ha producido el cambio sin errores, borramos la solicitud de la base de datos

            $error = false;
            $pass = trim($_POST["password"]);
            $pass_confirmar = trim($_POST["password_confirmar"]);
            $codigo = trim($_GET['code']);
            $cadena_errores = "Error al procesar los datos del formulario:";

			
            // si las variables estan vacias la variable $error cambia de valor
            if (empty($pass)) {
              $cadena_errores = $cadena_errores."\\n No has introducido una contraseña";
              $error = true;
            }
            if (empty($pass_confirmar)) {
              $cadena_errores = $cadena_errores."\\n No has introducido una contraseña de confirmacion";
              $error = true;
            }

            // si las variables no están vacías confirmamos que las contraseñas coinciden
            if (!$error) {
              if ($pass != $pass_confirmar) {
                $cadena_errores = $cadena_errores."\\n Las contraseñas no coinciden";
                $error = true;
              }
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
                  
                  // Comprobamos que el codigo existe
                  if (comprobarCodigo($conexion, $codigo)) {

                    // Si existe cambiamos la contraseña
                    $check = cambiarPass($conexion, $pass, $codigo);
                    if ($check) {
                      echo "<h1>La contraseña ha sido cambiada</h1>";
                    } else {
                      $cadena_errores_bd = $cadena_errores_bd."\\n Ha habido un error al cambiar la contraseña.";
                    }
                    
                  } else {

                    $cadena_errores_bd = $cadena_errores_bd."\\n El codigo de solicitud no es valido.";
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
    ?>

</body>
</html>