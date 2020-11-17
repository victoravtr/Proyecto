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

<a class="config" href="index.php">Volver</a>
<a class="cerrar" href="logout.php">Cerrar sesión</a>

<div class="elementos">
    <h1>Bienvenido <?php echo $_SESSION["usuario"]; ?></h1>    

    <div class="card">
        <div class="contenido">
            <form action="index.php" method="post">
                <input type="submit" class="boton" name="descubrir" value="Descubrir nuevos equipos"/>
            </form>

            <form action="index.php" method="post">
                <input type="submit" class="boton" name="test" value="Probar conexion a equipos"/>
            </form>
            
            <form action="index.php" method="post">
                <input type="submit" class="boton" name="add_del" value="Añadir/Eliminar equipos"/>
            </form>
        </div>
        
    </div>
</div>

<?php
    if (isset($_POST["dominio"])) {
        header("Location:dominio.php");
    }
    
    // TODO: Crear add_soft.php y que haga sus cositas
    if (isset($_POST["login"])) {
        header("Location:add_soft.php");
    }

    // TODO: Crear zabbix.php y que haga sus cositas
    if (isset($_POST["zabbix"])) {
        header("Location:zabbix.php");
    }

    // TODO: Crear ossec.php y que haga sus cositas
    if (isset($_POST["ossec"])) {
        header("Location:ossec.php");
    }

        // TODO: Crear shell.php y que haga sus cositas
    if (isset($_POST["shell"])) {
        header("Location:shell.php");
    }
?>
</body>
</html>