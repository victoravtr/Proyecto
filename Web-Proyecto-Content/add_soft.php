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
    <title>Add Soft</title>
    <link rel="stylesheet" href="assets/styles/style_add_soft.css">
</head>

<body>

    <a class="config" href="index.php">Volver </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Añadir software a equipo</h1>

        <div class="card">
            <div class="contenido">
                <form action="add_soft.php" enctype="multipart/form-data" method="post">
                    <div class="left-col">
                        <input type="text" name="ip" placeholder="IP">
                        <input type="text" name="usuario" placeholder="Usuario">
                        <input type="password" name="password" placeholder="Password">
                    </div>
                    <div class="right-col">
                        <input type="file" name="file">
                        <input type="submit" class="boton" name="add_soft" value="Añadir" />
                    </div>

                </form>
            </div>
        </div>
    </div>

    <?php
    if (isset($_POST["add_soft"])) {
        # Lista de extensiones permitidas: .exe .msi [para windows]  .deb [para linux]
        $ALLOWED_EXTENSIONS = [".exe", ".msi", ".deb"];
        $error = false;
        $cadena_errores = "Error al procesar los datos del formulario:";
        # Comprobar que ningun campo esta vacio
        $ip = trim($_POST["ip"]);
        $usuario = trim($_POST["usuario"]);
        $contraseña = trim($_POST["pass"]);
        $file = trim($_POST["file"]);

        if (empty($ip)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido una IP";
        }

        if (empty($usuario)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido un usuario";
        }

        if (empty($contraseña)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido una contraseña";
        }

        if (empty($file)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido un archivo";
        } else {
            if (!in_array(pathinfo($file)['extension'], $ALLOWED_EXTENSIONS)) {
                $error = true;
                $cadena_errores = $cadena_errores."\\n Formato de archivo no permitido.";
            }
        }

        if (!$error) {
            # Subimos el archivo al servidor
            $BASE_DIR = "/var/www/uploads/";
            $FILE_UPLOAD = $BASE_DIR.pathinfo($file)['filename'];
            if (move_uploaded_file($FILE_UPLOAD , $file)) {
                echo "El archivo se ha subido al servidor.";
              } else {
                $cadena_errores = $cadena_errores."\\n Ha ocurrido un error al intentar subir el archivo.";
                echo '<script> alert("'.$cadena_errores_bd.'")</script>';
              }
            # Ejecutamos el script que lo descarga en la IP objetivo y lo instala
            
            # Borramos el archivo del servidor
            
        } else {
            echo '<script> alert("'.$cadena_errores_bd.'")</script>';
        }
        
    }
    ?>
</body>

</html>