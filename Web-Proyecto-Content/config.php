<?php
session_start();
$usuario = $_SESSION["usuario"];
if (empty($usuario)) {
    header("Location:login.php");
}

?>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Index</title>
    <link rel="stylesheet" href="assets/styles/style_config.css">
</head>

<body>
    <?php

    if (isset($_POST['config'])) {
        $error = false;
        $res = array();

        $FILE_PATH = array(
            "ssh" => "connect_ssh.sh",
            "winrm" => "connect_winrm.sh",
            "PSRemoting" => "connect_psremote.sh"
        );

        $IP = trim($_POST['ip']);
        $USER = trim($_POST['usuario']);
        $PASS = trim($_POST['password']);
        $SISTEMA = trim($_POST['sistema']);

        if (empty($IP)) {
            $error = true;
            array_push($res, "1!@No has introducido una IP.");
        }
        if (empty($USER)) {
            $error = true;
            array_push($res, "1!@No has introducido una IP.");
        }
        if (empty($PASS)) {
            $error = true;
            array_push($res, "1!@No has introducido una IP.");
        }

        if (!$error) {
            $STRING = "";
            $CONF_FILE = "/etc/proyecto/general/";
            $PREF_METHOD = "";
            array_push($res, "0!@Datos del formulario validados.");
            foreach ($FILE_PATH as $key => $value) {
                $output = trim(shell_exec("./assets/scripts/$value $IP $USER '$PASS'"));

                if (trim($output) == "true") {
                    array_push($res, "0!@ $test Se ha establecido una conexion mediante: $key");
                    $STRING .= "${key}:true\n";
                    if ($key == "ssh") {
                        $PREF_METHOD = "ssh";
                    }
                    if ($key == "winrm" && $PREF_METHOD != "ssh") {
                        $PREF_METHOD = "winrm";
                    }
                } else {
                    array_push($res, "1!@No se ha podido establecer una conexion mediante: $key");
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
    }
    ?>
    <a class="config" href="index.php">Volver</a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Conexion a equipo</h1>

        <div class="card">
            <div class="contenido">
                <form action="config.php" enctype="multipart/form-data" method="post">
                    <div class="left-col">
                        <h2>Datos:</h2>
                        <input type="text" name="ip" placeholder="IP">
                        <input type="text" name="usuario" placeholder="Usuario">
                        <input type="password" name="password" placeholder="Password">
                        <div class="desplegable">
                            <label for="sistema">Sistema operativo</label>
                            <select name="sistema" id="sistema">
                                <option value="windows">Windows</option>
                                <option value="linux">Linux</option>
                            </select>
                        </div>
                        <input type="submit" class="boton" name="config" value="Añadir" />
                    </div>
                    <div class="right-col">
                        <h2>Output:</h2>
                        <?php
                        if (!empty($res)) {
                            foreach ($res as $linea) {
                                $linea = explode('!@', $linea);
                                if ($linea[0] == "0") {
                                    echo "<p class=\"verde\">$linea[1]</p>";
                                } else {
                                    echo "<p class=\"rojo\">$linea[1]</p>";
                                }
                                echo "<hr></hr>";
                            }
                        }
                        ?>
                    </div>

                </form>
            </div>
        </div>
    </div>
</body>

</html>