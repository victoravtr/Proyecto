IP=$1
USER=$2
PASS=$3
COMMAND=$4

RES=$(sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP $COMMAND);
if ! [ $? -eq 0 ]; then
    echo "Fallo."
    exit 1
fi
echo $RES