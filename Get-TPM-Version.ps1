$TPM=Get-WmiObject -Namespace root\cimv2\security\microsofttpm -Query 'Select SpecVersion from win32_tpm'
if ($TPM.SpecVersion -like "*2.0*") {Write-Host $true} else {Write-Host $false}

wmic bios get serialnumber