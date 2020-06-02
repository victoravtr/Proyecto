<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
  <title>¿Has olvidado tu contraseña?</title>
  <link rel="stylesheet" href="style.css">

</head>
<body>

<form action="contra.php" method="POST" class="card" autocomplete="off">

  <h1>¿Has olvidado tu contraseña?</h1>

  <div class="form__group field">
	<input type="email" class="form__field" placeholder="Correo" name="correo" id="correo"/>
	<label for="correo" class="form__label">Correo</label>
  </div>


  <input type="submit" class="boton" name="pass" value="Recuperar contraseña"/>
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
        if (isset($_POST["pass"])) {

			ini_set( 'display_errors', 1 );
			error_reporting( E_ALL );

			$to = "primesock@gmail.com";
			$subject = "Email de prueba";
			$txt = "Hello world!";
			$headers = "From: primesock@gmail.com";
			mail($to,$subject,$txt,$headers);

			echo "The email message was sent.";
            // // inicializamos las variables
            // // con trim eliminamos los espacios en blanco
			// $error = false;
			// $user = trim($_POST["user"]);
			// $pass = trim($_POST["pass"]);
			
			// // si las variables estan vacias la variable $error cambia de valor
			// if (empty($user)) {
			// 	echo "<p>No has introducido un usuario</p>";
			// 	$error=true;
			// }
			// if (empty($pass)) {
			// 	echo "<p>No has introducido una contraseña</p>";
			// 	$error=true;
			// }

            // // solo se ejecutara si la variable $error es false
			// if (!$error) {
			// 	$conexion = conectarBase();
				
			// 	// comprobamos si la conexion se ha realizado correctamente
			// 	if (!$conexion) {
			// 		echo "<p>Ha ocurrido un error al intentar conectar con la base de datos</p>";
			// 		echo "<p>".mysqli_error($conexion)."</p>";
			// 	} else {

			// 		// comprobamos si la base de datos "AADAD" existe"
			// 		if (existeBD($conexion)) {
			// 			echo "<p>funciona, comprobamos credenciales de usuario</p>";
			// 		} else {
			// 			echo "<p>La base de datos no existe.</p>";
			// 			echo "<p>Debes registrar un nuevo usuario, la base de datos se creará automáticamente.</p>";
			// 		}
			// 	}
		    // } else {
            //     echo "<p>Los datos estan pochos</p>";
            // }
	}
    ?>

</body>
</html>