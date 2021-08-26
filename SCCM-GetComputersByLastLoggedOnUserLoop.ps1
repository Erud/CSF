$SiteName="CSF"
$SCCMServer="PSCCM-APP-01.CSFUNDS.ORG"
$SCCMNameSpace="root\sms\site_$SiteName"

$name = "usersn"
$users = get-content "c:\temp\$name.txt"
$nameOk = "C:\Temp\$name" + "OK.txt"
if (Test-Path $nameOk) 
{
	Remove-Item $nameOk
}

foreach ($user in $users) {
	
	$comp = (Get-WmiObject -namespace $SCCMNameSpace -computer $SCCMServer -query "select Name from sms_r_system where LastLogonUserName='$user'" | select Name).Name 
	Add-Content $nameOk "$($comp;$user)"
	"$comp;$user" 
}