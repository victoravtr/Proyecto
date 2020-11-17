IP=$1
USER=$2
PASS=$3
FILE=$4

# Comprobar conexion con equipo
#   Leemos archivo, comprobando antes si existe, para ver si hay un metodo preferido.
PREF_METHOD_FILE="/etc/proyecto/general/${IP}"
if ! [ -f $PREF_METHOD_FILE ]; then
    echo "El archivo no existe, se creara automaticamente usando http://proyecto.local/test.php "
    exit
fi

PREF_METHOD = "tail -n 1 /etc/proyecto/general/${IP} | cut -d ":" -f 2"
if [ $PREF_METHOD == "false" ]
    
fi
# Descargar el archivo en el equipo objetivo
# Ejecutarlo
# Borrar archivo en ambos equipos
# Devolver resultado