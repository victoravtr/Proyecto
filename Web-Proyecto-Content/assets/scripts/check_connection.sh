# Vamos a comprobar:
#     - ssh
#     - PsExec(winexe)
#     - SC(Service Controller)
#     - WinRM
#     - MSBuild
#     - DCOM
#     - SchTask
#     - WMI(Windows Management Instrumentator)

FILE_PATH=(
            "ssh:connect_ssh.sh"
            "psexec:connect_psexec.sh"
            "sc:connect_sc.sh"
            "winrm:connect_winrm.sh"
            "msbuild:connect_msbuild.sh"
            "dcom:connect_dcom.sh"
            "schtask:connect_schtask.sh"
            "wmi:connect_wmi.sh"
            )

IP=$1
USER=$2
PASS=$3

for i in "${FILE_PATH[@]}"
do
    tipo_conexion=$(echo $i | cut -d ":" -f 1)
    path_conexion=$(echo $i | cut -d ":" -f 2)
    echo -e "Probando conexion $tipo_conexion"
    echo -e "Ejecutando $path_conexion"
    echo -e "Tratando de conectar con $path_conexion $IP $USER $PASS"
    response=$(./$path_conexion $IP $USER $PASS)
    echo "Response: $response"
    if [ $response -eq 0 ]; then
        echo -e "Conexion realizada con exito."
    else
        echo -e "No se ha podido completar la conexion."
    fi    
done