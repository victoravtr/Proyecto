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
    if (isset($_POST["descubrir"])) {
        $error = false;
        $res = array();
        # Comprobar que ningun campo esta vacio
        $ip = trim($_POST["ip"]);
        $usuario = trim($_POST["usuario"]);
        $password = trim($_POST["password"]);

        if (empty($ip)) {
            $error = true;
            array_push($res, "1!@No has introducido una IP.");
        }
        if (empty($usuario)) {
            $error = true;
            array_push($res, "1!@No has introducido un usuario.");
        }
        if (empty($password)) {
            $error = true;
            array_push($res, "1!@No has introducido una password.");
        }

        if (!$error) {
            # Ejecutar 
            $out = shell_exec("./assets/scripts/descubrir.sh $ip $usuario '$password'");
            $piezas = explode(' ', $out);
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
                <form action="descubrir.php" method="post">
                    <div class="left-col">
                        <h2>Datos:</h2>
                        <input type="text" name="ip" placeholder="Red: 192.168.10.0/24">
                        <input type="text" name="usuario" placeholder="Usuario">
                        <input type="password" name="password" placeholder="Password">
                        <input type="submit" class="boton" name="descubrir" value="Descubrir" />
                    </div>
                    <div class="right-col">
                        <h2>Output:</h2>
                        <?php
                        if (!empty($res)) {
                            $FILE_PATH = array(
                                "ssh" => "connect_ssh.sh",
                                "winrm" => "connect_winrm.sh",
                                "PSRemoting" => "connect_psremote.sh"
                            );
                            foreach ($res as $linea) {
                                $linea = explode(' ', $linea);
                                echo "<p>Ip descubierta: $linea[0]</p>";
                                $STRING = "";
                                $CONF_FILE = "/etc/proyecto/general/";
                                $PREF_METHOD = "";
                                $IP = $linea[0];

                                $SISTEMA = shell_exec("sshpass -p$password ssh -t -o StrictHostKeyChecking=no $usuario@$IP lsb_release");
                                echo $SISTEMA;

                                foreach ($FILE_PATH as $key => $value) {
                                    $output = shell_exec("./assets/scripts/$value $IP $usuario '$password'");
                                    if ($output) {
                                        echo "<p>Se ha establecido una conexion mediante: $key</p>";
                                        $STRING .= "${key}:true\n";
                                        if ($key == "ssh") {
                                            $PREF_METHOD = "ssh";
                                        }
                                        if ($key == "winrm" && $PREF_METHOD != "ssh") {
                                            $PREF_METHOD = "winrm";
                                        }
                                    } else {
                                        echo "<p>No ha sido posible establecer una conexion.</p>";
                                        $STRING .= "${key}:false\n";
                                    }
                                }
                                $STRING .= "sistema:${SISTEMA}\n";

                                if ($PREF_METHOD == "") {
                                    $STRING .= "pref_method:false";
                                } else {
                                    $STRING .= "pref_method:${PREF_METHOD}\n";
                                }
                                $CONF_FILE .= $IP;
                                file_put_contents($CONF_FILE, $STRING);
                            }
                            echo "<hr></hr>";
                        }
                        ?>
                    </div>

                </form>
            </div>
        </div>
    </div>


</body>

</html>