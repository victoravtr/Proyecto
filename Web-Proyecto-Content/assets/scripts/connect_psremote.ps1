 param (
    [string]$ip = $arg[1],
    [string]$username = $arg[2],
    [string]$pass = $arg[3]
)
$password = $( ConvertTo-SecureString  -String $pass -AsPlainText -Force )
$psCred = New-Object System.Management.Automation.PSCredential -ArgumentList ($username, $password)
$Session = New-PSSession -ComputerName $ip -Credential $psCred -Authentication Negotiate
Invoke-Command -ComputerName $ip -Credential $psCred -ScriptBlock {hostname} -Authentication Negotiate