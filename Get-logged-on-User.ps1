#Get logged on User
$Loggedon = Get-WmiObject -ComputerName $env:COMPUTERNAME -Class Win32_Computersystem | Select-Object UserName
#Split User and Domain
$Domain,$User = $Loggedon.Username.split('\',2)
Write-Host $Domain $user