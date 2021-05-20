$appname = "Google Chrome"
$32bit = get-itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "^*$appname*"}
$64bit = get-itemproperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "^*$appname*"}


if ($64bit -eq "" -or $64bit.count -eq 0) {
	
	switch ($32bit.DisplayName.count) {
		0 {Write-Host "Cannot find the uninstall string" -ForegroundColor Red}
		1 {
			"32 bit  " + $32bit[0].DisplayName + "  " + $32bit[0].DisplayVersion
		}
		default { Write-Host "Please Narrow Down Your Search" -ForegroundColor Red }
	}
}
else {
	
	switch ($64bit.DisplayName.count) {
		0 {Write-Host "Cannot find the uninstall string" -ForegroundColor Red}
		1 {
			"64 bit  " + $64bit[0].DisplayName + "  " + $64bit[0].DisplayVersion
		}
		default { Write-Host "Please Narrow Down Your Search" -ForegroundColor Red }
	}
}