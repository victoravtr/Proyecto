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

            <form action="index.php" method="post">
                <input type="submit" class="boton" name="login" value="Instalacion software en equipos"/>
            </form>
            
            <form action="index.php" method="post">
                <input type="submit" class="boton" name="login" value="Añadir agente zabbix en equipo"/>
            </form>
            
            <form action="index.php" method="post">
                <input type="submit" class="boton" name="login" value="Añadir agente ossec en equipo"/>
            </form>

        </div>
        
    </div>
</div>

<?php
    if (isset($_POST["login"])) {
        header("Location:dominio.php");
    }
    
    // TODO: Crear add_soft.php y que haga sus cositas
    if (isset($_POST["login"])) {
        header("Location:zabbix.php");
    }

    // TODO: Crear zabbix.php y que haga sus cositas
    if (isset($_POST["login"])) {
        header("Location:zabbix.php");
    }

    // TODO: Crear ossec.php y que haga sus cositas
    if (isset($_POST["login"])) {
        header("Location:ossec.php");
    }
?>
</body>
</html>