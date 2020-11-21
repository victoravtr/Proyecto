param (
    [string]$cli_ip = $arg[1]
    [string]$dom_ip = $arg[2],
    [string]$dom_user = $arg[3],
    [string]$dom_pass = $arg[4]
)
# Primero tenemos que conseguir el InterfaceIndex de la interfaz de red de la IP que ha introducido el usuario
$InterfaceIndex = Get-NetIPAddress -IPAddress "192.168.10.23" | findstr InterfaceIndex
$InterfaceIndex = $InterfaceIndex.Split(":").replace(' ','')
$InterfaceIndex = $InterfaceIndex[1]
#Get-NetIPAddress -InterfaceIndex $InterfaceIndex[1]