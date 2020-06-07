<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">
</head>
<body>

<form action="test.php" method="post">
  <input type="text" name="comando" id="comando">
  <label for="comando">Comando</label>
  <br>
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
  set_include_path(get_include_path() . PATH_SEPARATOR . 'phpseclib');
  include('Net/SSH2.php');
  
  $comando = $_POST['comando'];
  $usuario = $_POST['usuario'];
  $password = $_POST['password'];
  $ip = $_POST['ip'];
  echo "<p>Comando: $comando</p>";
  echo "<p>Usuario: $usuario</p>";
  echo "<p>Password: $password </p>";
  echo "<p>IP: $ip</p>";

  echo "<p>Probando conexion</p>";
  
$ssh = new Net_SSH2($ip);
if (!$ssh->login($usuario, $password)) {
    exit('Login Failed');
}

echo $ssh->exec($comando);

}



?>

</body>
</html>