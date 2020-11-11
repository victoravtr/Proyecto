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
done