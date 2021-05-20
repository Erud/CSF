
$OutArray = @()

$comps = Get-Content C:\Temp\coms.txt


foreach ($comp in $comps) {
	$serial = (get-ciminstance -classname win32_bios -computername $comp).SerialNumber
	# Construct an object
	$myobj = "" | Select "computer", "Serial"
	
	# Fill the object
	$myobj.computer = $comp
	$myobj.Serial = $Serial
	
	
	# Add the object to the out-array
	$outarray += $myobj
	
	# Wipe the object just to be sure
	$myobj = $null
	
	
}
$outarray | export-csv "c:\temp\serials.csv" -NoTypeInformation
# $computer + "," + $Serial  | out-file -filepath C:\temp\scripts\pshell\dump.txt -append 