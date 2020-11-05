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
    <link rel="stylesheet" href="style_core.css">
</head>

<body>

    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Iniciar sesión como administrador</h1>

        <div class="card">
            <div class="contenido">
                <form action="index.php" method="post">

                    <div class="form__group field">
                        <input type="text" class="form__field" placeholder="Usuario" name="usuario" id="user" value="<?php if (isset($_POST["usuario"]) != "") {
                                                                                                                            echo $_POST["usuario"];
                                                                                                                        } ?>">
                        <label for="user" class="form__label">Usuario</label>
                    </div>

                    <div class="form__group field">
                        <input type="password" class="form__field" placeholder="Contraseña" name="pass" id="pass" />
                        <label for="pass" class="form__label">Contraseña</label>
                    </div>



                    <input type="submit" class="boton" name="login" value="Iniciar sesión" />
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