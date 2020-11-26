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
    <title>Zabbix</title>
    <link rel="stylesheet" href="assets/styles/style_domain.css">
</head>

<body>

    <a class="config" href="index.php">Volver </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Añadir agente zabbix</h1>

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
                            <div class="arquitectura">
                                <label for="cli_arch">Arquitectura: </label>
                                <select name="cli_arch">
                                    <option value="64">64-bits</option>
                                    <option value="32">32-bits</option>
                                </select>
                            </div>
                        </div>
                        <div class="center-col">
                            <h2>Datos servidor</h2>
                            <input type="text" name="server_ip" placeholder="IP">
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
        $cli_host = trim($_POST['cli_host']);
        $cli_user = trim($_POST['cli_usuario']);
        $cli_password = trim($_POST['cli_password']);
        $cli_arch =  trim($_POST['cli_arch']);

        $server_ip = trim($_POST['server_ip']);

        # Comprobamos las variables
        if (empty($cli_ip)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la IP del cliente";
        }
        if (empty($cli_host)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido el Hostname del cliente";
        }
        if (empty($cli_user)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido el usuario del cliente";
        }
        if (empty($cli_password)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la password del cliente";
        }

        if (empty($server_ip)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido la IP del servidor";
        }

        if (!$error) {
            # Ejecutamos el script para incluir en el dominio
            $res = shell_exec("./assets/scripts/zabbix.sh $cli_ip $cli_host $cli_user '$cli_password' $cli_arch $server_ip");
        } else {
            echo '<script> alert("' . $cadena_errores_bd . '")</script>';
        }
    }

    ?>
</body>

</html>