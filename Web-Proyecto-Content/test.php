<!DOCTYPE html>
<html lang="en">

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
    <select name="sistema">
      <option value="windows">Windows 10</option>
      <option value="linux">Linux</option>
    </select>
    <label for="sistema">Sistema operativo</label>
    <br>
    <input type="submit" name="enviar">
  </form>

  <?php


  if (isset($_POST['enviar'])) {
    $cadena_errores = "Error al procesar los datos del formulario:";
    $error = false;

    $IP = trim($_POST['ip']);
    $USER = trim($_POST['usuario']);
    $PASS = trim($_POST['password']);
    $SISTEMA = trim($_POST['sistema']);
    echo "$IP $USER $PASS";

    $FILE_PATH = array(
      "ssh" => "connect_ssh.sh",
      "winrm" => "connect_winrm.sh",
      "PSRemoting" => "connect_psremote.sh"
    );

    $STRING = "";
    $CONF_FILE = "/etc/proyecto/general/";
    $PREF_METHOD = "";

    foreach ($FILE_PATH as $key => $value) {
      echo "<p>Probando conexion " . $key . "</p>";
      echo "<p>Ejecutando " . $value . "</p>";
      $output = shell_exec("./assets/scripts/$value $IP $USER '$PASS'");
      if ($output) {
        echo "<p>Se ha establecido una conexion.</p>";
        $STRING .= "${key}:true\n";
        if ($key == "ssh") {
          $PREF_METHOD = "ssh";
        }
        if ($key == "winrm" && $PREF_METHOD != "ssh") {
          $PREF_METHOD = "winrm";
        }
      } else {
        echo "<p>No ha sido posible establecer una conexion.</p>";
        $STRING .= "${key}:false\n";
      }
    }
    $STRING .= "sistema:${SISTEMA}\n";

    if ($PREF_METHOD == "") {
      $STRING .= "pref_method:false";
    } else {
      $STRING .= "pref_method:${PREF_METHOD}\n";
    }
    $CONF_FILE .= $IP;
    file_put_contents($CONF_FILE, $STRING);
  }



  ?>

</body>

</html>