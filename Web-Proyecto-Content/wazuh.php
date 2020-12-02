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
    <title>Wazuh</title>
    <link rel="stylesheet" href="assets/styles/style_domain.css">
</head>

<body>
    <?php
    if (isset($_POST['domain'])) {
        $error = false;
        $res = array();

        $cli_ip = trim($_POST['cli_ip']);
        $cli_host = trim($_POST['cli_host']);
        $cli_user = trim($_POST['cli_usuario']);
        $cli_password = trim($_POST['cli_password']);

        $server_ip = trim($_POST['server_ip']);

        # Comprobamos las variables
        if (empty($cli_ip)) {
            $error = true;
            array_push($res, "1!@No has introducido una IP.");
        }
        if (empty($cli_host)) {
            $error = true;
            array_push($res, "1!@No has introducido el Hostname del cliente.");
        }
        if (empty($cli_user)) {
            $error = true;
            array_push($res, "1!@No has introducido el usuario del cliente.");
        }
        if (empty($cli_password)) {
            $error = true;
            $array_push($res, "1!@No has introducido la password del cliente.");
        }

        if (empty($server_ip)) {
            $error = true;
            array_push($res, "1!@No has introducido la IP del servidor.");
        }

        if (!$error) {
            $out = shell_exec("./assets/scripts/wazuh.sh $cli_ip $cli_user '$cli_password' $server_ip");
            $piezas = explode('\n', $out);
            foreach ($piezas as $pieza) {
                if (!empty($pieza)) {
                    array_push($res, $pieza);
                }
            }
        } else {
            array_push($res, "1!@Error al tratar los datos del formulario.");
        }
    }
    ?>

    <a class="config" href="index.php">Volver </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Añadir agente wazuh</h1>

        <div class="card">
            <div class="contenido">
                <form action="zabbix.php" method="post">
                    <div class="upper-col">
                        <div class="left-col">
                            <h2>Datos cliente</h2>
                            <input type="text" name="cli_ip" placeholder="IP">
                            <input type="text" name="cli_host" placeholder="Hostname">
                            <input type="text" name="cli_usuario" placeholder="Usuario">
                            <input type="password" name="cli_password" placeholder="Password">
                        </div>
                        <div class="center-col">
                            <h2>Datos servidor</h2>
                            <input type="text" name="server_ip" placeholder="IP">
                        </div>
                        <div class="right-col">
                            <h2>Output: </h2>
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
                    </div>
                    <div class="bottom-col">
                        <input type="submit" class="boton" name="domain" value="Añadir" />
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>

</html>