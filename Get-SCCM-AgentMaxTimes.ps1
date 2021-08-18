$SiteCode = 'CSF'
$SiteServer = 'PSCCM-APP-01.CSFUNDS.ORG'

$WorkArray = New-Object System.Collections.ArrayList
$Resources = Get-WmiObject -Namespace root/SMS/site_$SiteCode -Class SMS_R_SYSTEM -ComputerName $SiteServer
foreach ($Resource in $Resources) {
	$times = $Resource.AgentTime
	$ltime = $null
	foreach ($time in $times) {
		if($ltime -lt $time ){$ltime = $time}
	}
	$WorkHash = [ordered] @{
		"Resource Name"=$Resource.Name;
		"Agent Time"= [System.Management.ManagementDateTimeconverter]::ToDateTime($ltime)
	}
	$WorkObject = New-Object PSObject -Property $WorkHash
	$res = $WorkArray.Add($WorkObject)	
}
$WorkArray | Out-GridView