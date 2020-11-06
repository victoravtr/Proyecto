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
    <link rel="stylesheet" href="style_index.css">
</head>
<body>

<a class="cerrar" href="logout.php">Cerrar sesión</a>

<div class="elementos">
    <h1>Bienvenido <?php echo $_SESSION["usuario"]; ?></h1>    

    <div class="card">
        <div class="contenido">
            <form action="index.php" method="post">
                <input type="submit" class="boton" name="login" value="Añadir equipos a dominio"/>
            </form>
        </div>
        
    </div>
</div>

<?php
    if (isset($_POST["login"])) {
        header("Location:dominio.php");
    }

?>
</body>
</html>