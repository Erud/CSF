$versions = ((Invoke-WebRequest -Uri "http://omahaproxy.appspot.com/all").Content).Split("`n")
foreach($line in $versions) {
	if($line.Substring(0,11) -eq "win,stable,"){
		$aline = $line.Split(",")
		$aline[2] + "   " + $aline[4] 
		break
	}
} 