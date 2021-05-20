#PrimaryUser,UserName,LastLogonUser
#$Error[0].Exception | Format-List * -Force

# Remove-PSDrive -Name CSF

$outFile = "C:\temp\edumps.csv"

if (Test-Path $outFile) {
	Remove-Item $outFile
}

$comps = Get-Content C:\Temp\coms.txt
foreach ($comp in $comps) {

	$acomp = $comp.Split('.')
	$comp = $acomp[0]
	$device = Get-CMDevice -Name $comp
	$duser = $device.UserName
	try {
		$user = Get-AdUser $duser -Properties Department,Mail
	} catch {
		"  > " + $comp + " <> " + $duser
		$_
	}
	
	$uname = $user.Name
	$email = $user.Mail
	$ping = Test-Connection -Cn $comp -BufferSize 16 -Count 1 -ErrorAction 0
	$ipv4 = $ping.IPV4Address.IPAddressToString
	$comp + "," + $ipv4 + "," + $uname + "," + $email | out-file -filepath $outFile -append
	$ipv4 = ''
	$uname = ''
	$email = ''
}