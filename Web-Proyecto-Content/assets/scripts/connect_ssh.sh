# Comprobamos si ssh esta instalado
check_install(){
    if ! [ -x "$(command -v ssh)" ]; then
        return false
    fi
    return true
}

# Comprobamos si el equipo es accesible por ssh
check_conection(){
    sshpass -p $3 ssh -o StrictHostKeyChecking=no $2@$1 exit
    if [ $? -eq 0 ]; then
        return true
    fi
    return false
}

main() {
    IP=$1
    USER=$2
    PASS=$3
    if [ check_install ]; then
        if [ check_conection $IP $USER $PASS ]; then
            echo "0"
            exit 1
        fi
        echo "1"
        exit 1
    fi
    
}

main 
