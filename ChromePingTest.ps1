$name = "pcsc"
$chromeCompliantVersion = "91.0.4472.106"
$computers = get-content "c:\temp\$name.txt"
$nameOk = "C:\Temp\$name" + "OK.txt"

if (Test-Path $nameOk) 
{
	Remove-Item $nameOk
}

$i = 0
foreach ($comp in $computers) {
	#	$comp = $comp.Trim() + ".centurionmp.com"
	$comp = $comp.Trim()	
	$n =$computers.count -$i
    $i = ++$i 
	"$n  $comp" 
	
	if(Test-Connection -Cn $comp -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
		# ok
		$Result = 	.\Get-ChromeVersion.ps1 -ComputerName $comp
		
		Add-Content $nameOk "$($comp + " " + $Result.bits + " " + $Result.DisplayName + " " + $Result.DisplayVersion + " " + $Result.InstallDate)"
		
	}
}