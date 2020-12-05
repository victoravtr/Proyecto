<!-- Este .php permite instalar software en equipos de forma remota. 

Funcionamiento:
1. Se validan los datos del formulario
2. Si todo ha salido bien se sube el archivo al servidor. 
3. Una vez el archivo haya sido subido, se ejcuta el script que nos permite realizar la instacion. 
4. Se recoge la salida de ese script y se muestra al usuario el resultado. -->

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
    <?php
    if (isset($_POST["add_soft"])) {
        # Lista de extensiones permitidas: .exe .msi [para windows]  .deb .rpm [para linux]
        $ALLOWED_EXTENSIONS = ["exe", "msi", "deb", "rpm"];
        $error = false;
        $res = array();
        
        # Comprobar que ningun campo esta vacio
        $ip = trim($_POST["ip"]);
        $usuario = trim($_POST["usuario"]);
        $contraseña = trim($_POST["password"]);
        $file = $_FILES["file"];

        if (empty($ip)) {
            $error = true;
            array_push($res, "1!@No has introducido una IP.");
        }
        if (empty($usuario)) {
            $error = true;
            array_push($res, "1!@No has introducido un usuario.");
        }
        if (empty($contraseña)) {
            $error = true;
            array_push($res, "1!@No has introducido una password.");        }
        if (empty($file)) {
            $error = true;
            array_push($res, "1!@No has introducido un archivo.");
        } else {
            if (!in_array(pathinfo($file["name"])['extension'], $ALLOWED_EXTENSIONS)) {
                $error = true;
                array_push($res, "1!@Formato de archivo no permitido.");
                echo pathinfo($file["name"])['extension'];
            }
        }

        if (!$error) {
            # Subimos el archivo al servidor
            array_push($res, "0!@Los datos del formulario son validos.");
            $BASE_DIR = "/var/www/html/uploads/";
            $FILE_UPLOAD = $BASE_DIR . $file["name"];
            if (move_uploaded_file($file["tmp_name"], $FILE_UPLOAD)) {
                array_push($res, "0!@Archivo subido al servidor.");
            } else {
                array_push($res, "1!@Ha ocurrido un error al subir el archivo.");
            }
            # Ejecutamos el script que lo descarga en la IP objetivo y lo instala
            $file_name = $file['name'];
            $out = shell_exec("./assets/scripts/add_soft.sh $ip $usuario '$contraseña' $file_name");
            $piezas = explode('\n', $out);
            foreach ($piezas as $pieza) {
                if (!empty($pieza)) {
                    array_push($res, $pieza);
                }
            }
            
        } else {
            array_push($res, "1!@Error al tratar los datos del formulario.");
        }
    }
    ?>
    <a class="config" href="index.php">Volver </a>
    <a class="cerrar" href="logout.php">Cerrar sesión</a>

    <div class="elementos">
        <h1>Añadir software a equipo</h1>

        <div class="card">
            <div class="contenido">
                <form action="add_soft.php" enctype="multipart/form-data" method="post">
                    <div class="left-col">
                        <h2>Datos:</h2>
                        <input type="text" name="ip" placeholder="IP">
                        <input type="text" name="usuario" placeholder="Usuario">
                        <input type="password" name="password" placeholder="Password">
                        <input type="file" name="file">
                        <input type="submit" class="boton" name="add_soft" value="Añadir" />
                    </div>
                    <div class="right-col">
                        <h2>Output:</h2>
                        <?php
                        if (!empty($res)) {
                            foreach ($res as $linea) {
                                $linea = explode('!@', $linea);
                                if ($linea[0] == "0") {
                                    echo "<p class=\"verde\">$linea[1]</p>";
                                } else {
                                    echo "<p class=\"rojo\">$linea[1]</p>";
                                }
                                echo "<hr></hr>";
                            }
                            
                        }
                        ?>
                    </div>

                </form>
            </div>
        </div>
    </div>


</body>

</html>