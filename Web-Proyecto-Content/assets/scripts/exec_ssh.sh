main() {
    IP=$1
    USER=$2
    PASS=$3
    COMMAND="hostname"
    RES=$(sshpass -p  $PASS ssh $USER@$IP $COMMAND);
    if [ $? -eq 0 ]; then
        echo $RES
    fi
    echo "$RES $PASS uwu"
}

main 