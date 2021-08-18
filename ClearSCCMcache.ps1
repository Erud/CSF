$MinDays = 80
$UIResourceMgr = New-Object -com “UIResource.UIResourceMgr”
$Cache = $UIResourceMgr.GetCacheInfo()
($Cache.GetCacheElements() |
where-object {[datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} |
Measure-object).Count
$ans = Read-Host -Prompt 'Clear cache?'
If ($ans -eq 'y'){
	$Cache.GetCacheElements() |
	where-object {[datetime]$_.LastReferenceTime -lt (get-date).adddays(-$mindays)} |
	foreach {
		$Cache.DeleteCacheElement($_.CacheElementID)
	}
}

Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID,@{'Name' = 'FreeSpace (GB)'; Expression= { [int]($_.FreeSpace / 1GB) }}