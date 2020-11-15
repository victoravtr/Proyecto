IP=$1
USER=$2
PASS=$3
COMMAND="Test-Connection -ComputerName (hostname) -Count 1  | Select IPV4Address"

RES=$(sshpass -p$PASS ssh -o StrictHostKeyChecking=no $USER@$IP $COMMAND);
if ! [ $? -eq 0 ]; then
    echo "Fallo."
    exit 1
fi
echo $RES