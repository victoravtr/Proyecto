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
    <link rel="stylesheet" href="assets/styles/style_index.css">
</head>

<body>

    <a class="config" href="config.php">Configuracion </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Bienvenido <?php echo $_SESSION["usuario"]; ?></h1>

        <div class="card">
            <div class="contenido">
                <form action="index.php" method="post">
                    <input type="submit" class="boton" name="dominio" value="Añadir equipos a dominio" />
                </form>

                <form action="index.php" method="post">
                    <input type="submit" class="boton" name="add_soft" value="Instalacion software en equipos" />
                </form>

                <form action="index.php" method="post">
                    <input type="submit" class="boton" name="zabbix" value="Añadir agente zabbix en equipo" />
                </form>

                <form action="index.php" method="post">
                    <input type="submit" class="boton" name="rshell" value="Abrir shell remota a equipo" />
                </form>

                <form action="index.php" method="post">
                    <input type="submit" class="boton" name="wazuh" value="Añadir agente wazuh en equipo" />
                </form>

            </div>

        </div>
    </div>

    <?php

    # Dependiendo del boton que se pulse se dirigira al usuario a una pagina u otra
    if (isset($_POST["dominio"])) {
        header("Location:dominio.php");
    }

    if (isset($_POST["add_soft"])) {
        header("Location:add_soft.php");
    }

    if (isset($_POST["zabbix"])) {
        header("Location:zabbix.php");
    }

    if (isset($_POST["rshell"])) {
        header("Location:rshell.php");
    }

    if (isset($_POST["wazuh"])) {
        header("Location:wazuh.php");
    }
    ?>
</body>

</html>