function Invoke-BLEvaluation
{
	param (
	[String][Parameter(Mandatory=$true, Position=1)] $ComputerName,
	[String][Parameter(Mandatory=$False, Position=2)] $BLName
	)
	if(Test-Connection -Cn $ComputerName -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
		If ($BLName -eq $Null)
		{
			$Baselines = Get-WmiObject -ComputerName $ComputerName -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration
		}
		Else
		{
			$Baselines = Get-WmiObject -ComputerName $ComputerName -Namespace root\ccm\dcm -Class SMS_DesiredConfiguration | Where-Object {$_.DisplayName -like $BLName}
		}
		
		$Baselines | % {
			
			([wmiclass]"\\$ComputerName\root\ccm\dcm:SMS_DesiredConfiguration").TriggerEvaluation($_.Name, $_.Version) 
			
		}
	} else {
		"Offline " + $ComputerName
	}
	
}
$name = "pcsOK"
$computers = get-content "c:\temp\$name.txt"
foreach ($comp in $computers) {
	$comp = $comp.Trim()
	$comp
	if(Test-Connection -Cn $comp -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
		$result = Invoke-BLEvaluation -ComputerName $comp -BLName "Google Chrome Compliance"
        #$result = Invoke-BLEvaluation -ComputerName $comp -BLName "Windows 10 BIOS Compliance"
		if($comp -ne $result.__SERVER){ "WMI name mismatch " + $comp + " " + $result.__SERVER } 
		if($result.ReturnValue){"Bad return " + $comp + " " + $result.ReturnValue} 
	} else {
		"Offline " + $comp
	}
}