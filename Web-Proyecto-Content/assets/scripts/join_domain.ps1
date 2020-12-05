param (
    [string]$cli_ip = $arg[1],
    [string]$dom_ip = $arg[2],
    [string]$dom_user = $arg[3],
    [string]$dom_pass = $arg[4],
    [string]$dom_name = $arg[5]
)
# Recogemos la password del archivo pass.txt y lo borramos.
$password_file = Get-Content -Path .\pass.txt
Remove-Item -Path .\pass.txt

# Buscamos el Index de la interfaz de red y cambiamos sus DNS por la IP del controlador de dominio.
$InterfaceIndex = Get-NetIPAddress -IPAddress $cli_ip | findstr InterfaceIndex
$InterfaceIndex = $InterfaceIndex.Split(":").replace(' ','')
$InterfaceIndex = $InterfaceIndex[1]
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ($dom_ip)

# Metemos el equipo en el dominio
$password = $( ConvertTo-SecureString  -String $password_file -AsPlainText -Force )
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $dom_user, $password
Add-Computer -DomainName $dom_name -Credential $credential -Restart