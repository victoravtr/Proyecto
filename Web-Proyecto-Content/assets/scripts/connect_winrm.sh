IP=$1
USER=$2
PASS=$3

# Comprobamos si python esta instalado
if ! [ -x "$(command -v python3)" ]; then
    echo "1"
    exit 1
fi

#Comprobamos si pip esta instalado
if ! [ -x "$(command -v pip3)" ]; then
    echo "1"
    exit 1
fi

# Comprobamos si la libreria pywinrm esta instalada
res=$(pip3 show pywinrm)
if ! [ $? -eq 0 ]; then
    echo "1"
    exit 1
fi

# Ejecutamos el .py de comprobacion
pwd
res=$(python3 /home/victor/Documentos/GitHub/Proyecto/Web-Proyecto-Content/assets/scripts/connect_winrm.py $IP $USER $PASS)
echo $res
if [ $res -eq 0 ]; then
    echo true
    exit 1
fi
echo false
exit 1