$SiteCode = 'CSF'
$SiteServer = 'PSCCM-APP-01.CSFUNDS.ORG'

$WorkArray = New-Object System.Collections.ArrayList
$Resources = Get-WmiObject -Namespace root/SMS/site_$SiteCode -Class SMS_R_SYSTEM -ComputerName $SiteServer
foreach ($Resource in $Resources) {
	for ($i=0; $i -lt $Resource.AgentName.Count; $i++) {
		if($Resource.AgentName[$i] -eq "Heartbeat Discovery" ){ 
			$WorkHash = [ordered] @{"Resource Name"=$Resource.Name;`
                "Agent Name"=$Resource.AgentName[$i];"Agent Time"=`
                [System.Management.ManagementDateTimeconverter]::`
                ToDateTime($Resource.AgentTime[$i])}
			$WorkObject = New-Object PSObject -Property $WorkHash
			$WorkArray.Add($WorkObject)
		}
	}
}
$WorkArray | Out-GridView
