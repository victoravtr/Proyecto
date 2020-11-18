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
                        <input type="file" name="file">
                        <input type="submit" class="boton" name="add_soft" value="Añadir"/>
                    </div>
                    <div class="right-col">
                    <?php 
                        if (isset($_POST["output"]) != "") { 
                            foreach ($output as $out) {
                                echo "<p>$out</p>";
                            }
                        } 
                    ?>
                    </div>

                </form>
            </div>
        </div>
    </div>

    <?php
    if (isset($_POST["add_soft"])) {
        # Lista de extensiones permitidas: .exe .msi [para windows]  .deb [para linux]
        $ALLOWED_EXTENSIONS = ["exe", "msi", "deb"];
        $error = false;
        $output = array();
        $cadena_errores = "Error al procesar los datos del formulario:";
        # Comprobar que ningun campo esta vacio
        $ip = trim($_POST["ip"]);
        $usuario = trim($_POST["usuario"]);
        $contraseña = trim($_POST["password"]);
        $file = $_FILES["file"];
        
        array_push($output, "Comprobando formulario...");
        if (empty($ip)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido una IP";
        }
        array_push($output, "IP comprobada...");

        if (empty($usuario)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido un usuario";
        }
        array_push($output, "Usuario comprobado...");

        if (empty($contraseña)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido una contraseña";
        }
        array_push($output, "Password comprobada...");

        if (empty($file)) {
            $error = true;
            $cadena_errores = $cadena_errores."\\n No has introducido un archivo";
        } else {
            if (!in_array(pathinfo($file["name"])['extension'], $ALLOWED_EXTENSIONS)) {
                $error = true;
                $cadena_errores = $cadena_errores."\\n Formato de archivo no permitido.";
                echo pathinfo($file["name"])['extension'];
            }
        }
        array_push($output, "Archivo comprobado...");

        if (!$error) {
            # Subimos el archivo al servidor
            $BASE_DIR = "/var/www/html/uploads/";
            $FILE_UPLOAD = $BASE_DIR.$file["name"];
            if (move_uploaded_file($file["tmp_name"] , $FILE_UPLOAD)) {
                echo '<script> alert("El archivo se ha subido al servidor.")</script>';
                array_push($output, "Archivo cargado en servidor...");
              } else {
                $cadena_errores = $cadena_errores."\\n Ha ocurrido un error al intentar subir el archivo.";
                echo '<script> alert("'.$cadena_errores_bd.'")</script>';
              }
            # Ejecutamos el script que lo descarga en la IP objetivo y lo instala
            array_push($output, "Ejecutando script de instalacion...");
            $file_name = $file['name'];
            $res = shell_exec("./assets/scripts/add_soft.sh $IP $USER '$PASS' $file_name");
            # Borramos el archivo del servidor
            
        } else {
            echo '<script> alert("'.$cadena_errores_bd.'")</script>';
        }
        
    }
    ?>
</body>

</html>