$adptors = Get-NetAdapterBinding 
foreach($adapt in $adptors){
	if(($adapt.ComponentID -eq "ms_server") -or ($adapt.ComponentID -eq "ms_msclient")) { $adapt }
}