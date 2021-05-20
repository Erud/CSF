Import-Module -Name 'Rapid7Nexpose'
#https://10.3.159.100:3780/api/3
#read-host -assecurestring | convertfrom-securestring | out-file C:\TEMP\secureD.txt
$pass = cat C:\temp\secureD.txt | convertto-securestring
$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "erudakov",$pass
Connect-NexposeAPI -HostName '10.3.159.100' -Port '3780' -Credential $mycred -SkipSSLCheck
$Sites = Get-NexposeSite
foreach ($site in $Sites){
	[String]$siteID   = $site.id
	$siteName = $site.name
	$siteConf = Get-NexposeSiteAssetConfiguration -Id $siteID
	$siteTargets = $siteConf.IncludedTargets
	foreach($target in $siteTargets){
		Add-Content C:\Temp\citeTargets.csv ($siteID + ';' + $siteName + ';' + $target)
	}
}