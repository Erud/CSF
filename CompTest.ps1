$name = "pcs"
$computers = get-content "c:\temp\$name.txt"
$nameOut = "C:\Temp\$name" + "Out.txt"
if (Test-Path $nameOut) 
{
	Remove-Item $nameOut
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