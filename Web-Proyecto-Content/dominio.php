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
    <link rel="stylesheet" href="assets/styles/style_domain.css">
</head>

<body>

    <?php
    if (isset($_POST['domain'])) {
        $error = false;

        # Array con los outputs del programa
        $res = array();

        # Validamos las variables del formulario
        $cli_ip = trim($_POST['cli_ip']);
        $cli_user = trim($_POST['cli_usuario']);
        $cli_password = trim($_POST['cli_password']);

        $dom_ip = trim($_POST['dom_ip']);
        $dom_user = trim($_POST['dom_usuario']);
        $dom_password = trim($_POST['dom_password']);
        $dom_name = trim($_POST['dom_name']);

        if (empty($cli_ip)) {
            $error = true;
            array_push($res, "1!@No has introducido la IP del cliente.");
        }
        if (empty($cli_user)) {
            $error = true;
            array_push($res, "1!@No has introducido el usuario del cliente.");
        }
        if (empty($cli_password)) {
            $error = true;
            array_push($res, "1!@No has introducido la password del cliente.");
        }

        if (empty($dom_ip)) {
            $error = true;
            array_push($res, "1!@No has introducido la IP del dominio.");
        }
        if (empty($dom_user)) {
            $error = true;
            array_push($res, "1!@No has introducido el usuario del dominio.");
        }
        if (empty($dom_password)) {
            $error = true;
            array_push($res, "1!@No has introducido la password del dominio.");
        }
        if (empty($dom_name)) {
            $error = true;
            array_push($res, "1!@No has introducido el nombre del dominio.");
        }

        if (!$error) {
            array_push($res, "0!@Datos del formulario validados.");
            # Ejecutamos el script para incluir en el dominio
            $out = shell_exec("./assets/scripts/dominio.sh $cli_ip $cli_user '$cli_password' $dom_ip $dom_user '$dom_password' $dom_name");
            $piezas = explode('\n', $out);
            foreach ($piezas as $pieza) {
                if (!empty($pieza)) {
                    array_push($res, $pieza);
                }
            }
        } else {
            array_push($res, "1!@Ha ocurrido un error al tratar los datos del formulario.");
        }
    }

    ?>
    <a class="config" href="index.php">Volver </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Añadir equipo a dominio</h1>

        <div class="card">
            <div class="contenido">
                <form action="dominio.php" method="post">
                    <div class="upper-col">
                        <div class="left-col">
                            <h2>Datos cliente</h2>
                            <input type="text" name="cli_ip" placeholder="IP">
                            <input type="text" name="cli_usuario" placeholder="Usuario">
                            <input type="password" name="cli_password" placeholder="Password">
                        </div>
                        <div class="center-col">
                            <h2>Datos dominio</h2>
                            <input type="text" name="dom_ip" placeholder="IP">
                            <input type="text" name="dom_usuario" placeholder="Dominio\Usuario">
                            <input type="password" name="dom_password" placeholder="Password">
                            <input type="text" name="dom_name" placeholder="Nombre de dominio">
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