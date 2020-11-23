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
                        </div>
                    </div>
                    <div class="bottom-col">
                        <input type="submit" class="boton" name="domain" value="Añadir" />
                    </div>
                </form>
            </div>
        </div>
    </div>

    <?php
    if (isset($_POST['domain'])) {
        $error = false;
        $cadena_errores = "Error al procesar los datos del formulario:";

        $cli_ip = trim($_POST['cli_ip']);
        $cli_user = trim($_POST['cli_usuario']);
        $cli_password = trim($_POST['cli_password']);

        $dom_ip = trim($_POST['dom_ip']);
        $dom_user = trim($_POST['dom_usuario']);
        $dom_password = trim($_POST['dom_password']);
        $dom_name = trim($_POST['dom_name']);

        # Comprobamos las variables
        if (empty($cli_ip)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la IP del cliente";
        }
        if (empty($cli_user)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido el usuario del cliente";
        }
        if (empty($cli_password)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la password del cliente";
        }

        if (empty($dom_ip)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la IP del dominio";
        }
        if (empty($dom_user)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido el usuario del dominio";
        }
        if (empty($dom_password)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la password del dominio";
        }
        if (empty($dom_name)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido el nombre de dominio";
        }

        if (!$error) {
            # Ejecutamos el script para incluir en el dominio
            $res = shell_exec("./assets/scripts/dominio.sh $cli_ip $cli_user '$cli_password' $dom_ip $dom_user '$dom_password' $dom_name");
        } else {
            echo '<script> alert("' . $cadena_errores_bd . '")</script>';
        }
    }

    ?>
</body>

</html>