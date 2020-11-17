IP=$1
USER=$2
PASS=$3
SERVER_IP=$(hostname -I | sed 's/ *$//g')
URL="http://${SERVER_IP}/uploads/test.exe"


COMMAND="curl -o C:\Users\victorav\npp.7.Installer.exe http://192.168.10.67/uploads/npp.7.Installer.exe"
RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND);
if ! [ $? -eq 0 ]; then
    echo "Fallo."
    exit 1
fi

COMMAND='Start-Process -Wait -FilePath "C:\Users\victorav\npp.7.Installer.exe" -ArgumentList "/S" -PassThru'
RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND);
if ! [ $? -eq 0 ]; then
    echo "Fallo."
    exit 1
fi

COMMAND='rm "C:\Users\victorav\npp.7.Installer.exe"'
RES=$(sshpass -p$PASS ssh -t -o StrictHostKeyChecking=no $USER@$IP $COMMAND);
if ! [ $? -eq 0 ]; then
    echo "Fallo."
    exit 1
fi

rm /var/www/html/uploads/npp.7.Installer.exe