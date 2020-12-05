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
    <title>Remote shell</title>
    <link rel="stylesheet" href="assets/styles/style_rshell.css">
</head>

<body>

    <a class="config" href="index.php">Volver </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Abrir shell en equipo</h1>

        <div class="card">
            <div class="contenido">
                <form action="rshell.php" method="post">
                    <h2>IP equipo: </h2>
                    <input type="text" name="ip" placeholder="IP">
                    <input type="submit" class="boton" name="rshell" value="Acceder" />
                </form>
            </div>
        </div>
    </div>

    <?php
    if (isset($_POST["rshell"])) {
        $error = false;
        $cadena_errores = "Error al procesar los datos del formulario:";
        
        # Validamos los campos del formulario
        $ip = trim($_POST["ip"]);

        if (empty($ip)) {
            $error = true;
            $cadena_errores = $cadena_errores . "\\n No has introducido una IP";
        }

        if (!$error) {
            # Una vez validados, se dirige al usuario a la siguiente URL donde se abrira una web shell.
            header("Location:http://proyecto.local:2222/ssh/host/$ip");
        } else {
            echo '<script> alert("' . $cadena_errores_bd . '")</script>';
        }
    } 
    ?>
</body>

</html>