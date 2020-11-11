IP=$1
USER=$2
PASS=$3

echo $PASS
echo $3
# Comprobamos si ssh esta instalado
if ! [ -x "$(command -v ssh)" ]; then
    echo "1"
    exit 1
fi

# Comprobamos si el equipo es accesible por ssh
sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP exit
if [ $? -eq 0 ]; then
    echo "0"
    exit 1
fi
echo "1"
exit 1