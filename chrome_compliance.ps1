# location \\psccm-app-01\repositories$\Scripts\PowerShell\Other\Chrome

#Returning version number from Chrome executable file properties
$chromeLocalVersion=(Get-Item (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe').'(Default)').VersionInfo.ProductVersion

#Returning compliant version from file
#$chromeCompliantVersion=Get-Content \\psccm-app-01\repositories$\Scripts\PowerShell\Other\Chrome\chrome_version.txt

#compliant version by security scorecard
$chromeCompliantVersion = "91.0.4472.106"

#Evaluating versions and returning value based on condition being met
#if (($chromeLocalVersion -eq $chromeCompliantVersion) -or ($chromeLocalVersion -eq $null)) {
if (($chromeLocalVersion -ge $chromeCompliantVersion) -or ($chromeLocalVersion -eq $null)) {

    Write-Host $true

}

else {

    Write-Host $false

}