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
            <form action="config.php" method="post">
                <input type="submit" class="boton" name="descubrir" value="Descubrir nuevos equipos"/>
            </form>

            <form action="config.php" method="post">
                <input type="submit" class="boton" name="test" value="Probar conexion a equipos"/>
            </form>
        </div>
        
    </div>
</div>

<?php
    if (isset($_POST["descubrir"])) {
        header("Location:descubrir.php");
    }
    
    // TODO: Crear add_soft.php y que haga sus cositas
    if (isset($_POST["test"])) {
        header("Location:test.php");
    }
?>
</body>
</html>