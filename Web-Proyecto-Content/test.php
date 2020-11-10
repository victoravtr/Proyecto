<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
</head>
<body>

<form action="test.php" method="post">
  <input type="text" name="usuario" id="usuario">
  <label for="comando">Usuario</label>
  <br>
  <input type="text" name="password" id="password">
  <label for="password">Password</label>
  <br>
  <input type="text" name="ip" id="ip">
  <label for="ip">IP</label>
  <br>
  <input type="submit" name="enviar">
</form>

<?php


if (isset($_POST['enviar'])) {
  $cadena_errores = "Error al procesar los datos del formulario:";
  $error = false;

  $IP=trim($_POST['ip']);
  $USER=trim($_POST['usuario']);
  $PASS=trim($_POST['password']);
  
  if (empty($USER)) {
		$error=true;
		$cadena_errores = $cadena_errores."\\n No has introducido un usuario";
  }

  if (empty($PASS)) {
		$error=true;
		$cadena_errores = $cadena_errores."\\n No has introducido una pass";
  }

  if (empty($IP)) {
		$error=true;
		$cadena_errores = $cadena_errores."\\n No has introducido una IP";
  }
  
  if ($error) {
    echo '<script> alert("'.$cadena_errores_bd.'")</script>';
  } else {
    echo "<pre>Comprobando conexion por ssh: </pre>";
    $output = shell_exec("bash assets/scripts/connect_ssh.sh $IP $USER $PASS");
    if ($output==0) {
      echo "<pre>La conexion por ssh ha sido exitosa.</pre>";
      $output = shell_exec("bash assets/scripts/exec_ssh.sh $IP $USER $PASS hostname");
      echo $output;
  } else {
      echo "<pre>No se ha podido conectar por ssh.</pre>";
  }
  }
  

}



?>

</body>
</html>