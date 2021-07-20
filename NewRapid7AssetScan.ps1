Import-Module -Name 'Rapid7Nexpose'
function IsIpAddressInRange {
	param(
	[string] $ipAddress,
	[string] $fromAddress,
	[string] $toAddress
	)
	
	$ip = [system.net.ipaddress]::Parse($ipAddress).GetAddressBytes()
	[array]::Reverse($ip)
	$ip = [system.BitConverter]::ToUInt32($ip, 0)
	
	$from = [system.net.ipaddress]::Parse($fromAddress).GetAddressBytes()
	[array]::Reverse($from)
	$from = [system.BitConverter]::ToUInt32($from, 0)
	
	$to = [system.net.ipaddress]::Parse($toAddress).GetAddressBytes()
	[array]::Reverse($to)
	$to = [system.BitConverter]::ToUInt32($to, 0)
	
	$from -le $ip -and $ip -le $to
}


#https://10.3.159.100:3780/api/3
#read-host -assecurestring | convertfrom-securestring | out-file C:\TEMP\secureD.txt
$pass = cat C:\temp\secureD.txt | convertto-securestring
$mycred = new-object -typename System.Management.Automation.PSCredential -argumentlist "erudakov",$pass
$null = Connect-NexposeAPI -HostName '10.3.159.100' -Port '3780' -Credential $mycred -SkipSSLCheck
$Sites = Get-NexposeSite

$name = "pcsw"

$computers = get-content "c:\temp\$name.txt"
foreach ($comp in $computers) {
	#$comp = "CTS-00560-L1"
	$compIP = $false
	$compIP = (Test-Connection -Cn $comp -BufferSize 16 -Count 1 -ErrorAction 0).IPV4Address.IPAddressToString
	if(!$compIP){
		$comp + " offline"
	} else {
		foreach ($site in $Sites){
			[String]$siteID   = $site.id
			$siteName = $site.name
			$siteConf = Get-NexposeSiteAssetConfiguration -Id $siteID
			$siteTargets = $siteConf.IncludedTargets
			foreach($target in $siteTargets){
				#Add-Content C:\Temp\citeTargets.csv ($siteID + ';' + $siteName + ';' + $target)
				$atarget = $target.Split(" ")
				if($atarget.Count -gt 1 ){ 
					if(IsIpAddressInRange $compIP $atarget[0] $atarget[2]){
						if(($siteID -ne 3) -and ($siteID -ne 6072)){ 
							#$asset = Get-NexposeAsset -Name $comp
							$asset = Get-NexposeAsset -IpAddress $compIP
							$comp + '  ' + $compIP + '  ' + $asset.id + '  ' + $siteID + '  ' + $siteName + '  ' + $target
							#Get-NexposeScanTemplate | out-gridview "full-audit-without-web-spider"
							if ($asset.id) {
							#	Start-NexposeAssetScan -Name 'ER' -SiteId $siteID -AssetId $asset.id -TemplateId full-audit-without-web-spider
							}
							#break 
						}
					}
				} else {
					if($compIP -eq $atarget){
						if(($siteID -ne 3) -and ($siteID -ne 6072)){
							$asset = Get-NexposeAsset -Name $comp
							$comp + '  ' + $compIP + '  ' + $asset.id + '  ' + $siteID + '  ' + $siteName + '  ' + $target
							#Get-NexposeScanTemplate | out-gridview "full-audit-without-web-spider"
							Start-NexposeAssetScan -Name 'ER' -SiteId $siteID -AssetId $asset.id -TemplateId full-audit-without-web-spider
							break
						}
					}
				}
			}
		}
	}
}
