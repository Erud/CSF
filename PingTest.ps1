$name = "pc"
$computers = get-content "c:\temp\$name.txt"
$nameOk = "C:\Temp\$name" + "OK.txt"
$nameNO = "C:\Temp\$name" + "NO.txt"
if (Test-Path $nameOk) 
{
	Remove-Item $nameOk
}
if (Test-Path $nameNO) 
{
	Remove-Item $nameNO
}
foreach ($comp in $computers) {
	#	$comp = $comp.Trim() + ".centurionmp.com"
	$comp = $comp.Trim()
	$comp
	if(Test-Connection -Cn $comp -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
		# ok
		Add-Content $nameOk "$($comp)"
	}
	else {
		#	$comp += " No Ping" 
		#	$comp
		Add-Content $nameNo "$($comp)"
	}
}