$SiteCode ="CSF"
$siteserver = "psccm-app-01.csfunds.org"

$ComputerSystems = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_G_System_COMPUTER_SYSTEM -ComputerName $SiteServer
$BIOSversion = Get-WmiObject -Namespace "root\SMS\site_$($SiteCode)" -Class SMS_G_System_PC_BIOS -ComputerName $SiteServer 

$JoinedObject = Foreach ($row in $ComputerSystems)
{
	if(($row.Model -ne "VMware Virtual Platform") -and ($row.Model -ne "Virtual Machine") -and ($row.Manufacturer -ne "Apple")) {
		$line = $BIOSversion | Where-Object {$_.ResourceID -eq $row.ResourceID}
		$motherBoard.Product = ''
		$motherBoard = Get-WmiObject -Class Win32_BaseBoard -ComputerName $row.Name -ErrorAction SilentlyContinue 
		[pscustomobject]@{
			Model            = $row.Model
			Name             = $row.Name
			UserName         = $row.UserName
			Manufacturer     = $row.Manufacturer 
			TimeStamp        = $row.TimeStamp
			SMBBIOSversion   = $line.SMBIOSBIOSVersion
			SerialNumber     = $line.SerialNumber
			BIOSVersion      = $line.BIOSVersion
			BIOSManufacturer = $line.Manufacturer
			Product          = $motherBoard.Product
		}
	}
}

$JoinedObject | Export-Csv C:\Temp\Bios-Versions.csv -NoTypeInformation