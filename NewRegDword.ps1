$location = 'hklm:\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\KeyExchangeAlgorithms'

IF(!(Test-Path "$location\PKCS")){
	# Create new key 
	New-Item -Path "$location\PKCS"
}
# Create new DWORD in UserList
New-ItemProperty -Path "$location\PKCS" -Name 'Enabled' -Value '0' -PropertyType DWORD
# Reset back to the original location
Pop-Location
