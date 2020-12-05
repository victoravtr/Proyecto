<?php
# Redirige al usuario al login para cerrar la sesion
session_start();
echo '<script> alert("Sesion finalizada")</script>';
session_destroy();

echo '<script>location.replace("login.php")</script>';

?>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title></title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
    </head>
    <body>
    
    </body>
</html>