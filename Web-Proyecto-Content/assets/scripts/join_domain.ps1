param (
    [string]$cli_ip = $arg[1],
    [string]$dom_ip = $arg[2],
    [string]$dom_user = $arg[3],
    [string]$dom_pass = $arg[4],
    [string]$dom_name = $arg[5]
)
# Primero tenemos que conseguir el InterfaceIndex de la interfaz de red de la IP que ha introducido el usuario
$password_file = Get-Content -Path .\pass.txt
Remove-Item -Path .\pass.txt
$InterfaceIndex = Get-NetIPAddress -IPAddress $cli_ip | findstr InterfaceIndex
$InterfaceIndex = $InterfaceIndex.Split(":").replace(' ','')
$InterfaceIndex = $InterfaceIndex[1]
Set-DnsClientServerAddress -InterfaceIndex $InterfaceIndex -ServerAddresses ($dom_ip)
$password = $( ConvertTo-SecureString  -String $password_file -AsPlainText -Force )
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList $dom_user, $password
Add-Computer -DomainName $dom_name -Credential $credential -Restart