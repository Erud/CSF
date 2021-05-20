#(Get-Item C:\Windows\System32\MpSigStub.exe).VersionInfo

$fileVer = (Get-Item C:\SWSetup\SP110416\HPImageAssistant.exe).VersionInfo.FileVersion
if($fileVer.Substring(0,5) -lt '5.0.3'){
	'update'
} else {
	
	#$Command = "C:\SWSetup\SP110416\HPImageAssistant.exe"
	#$Parms = "/Operation:Analyze /Action:Install /SoftpaqDownnloadFolder:c:\temp\drivers /Silent / ReportFolder:C:\temp\HPIA"
	
	#$Prms = $Parms.Split(" ")
	#& "$Command" $Prms

Start-Process -NoNewWindow -FilePath "C:\SWSetup\SP110416\HPImageAssistant.exe" -ArgumentList "/Operation:Analyze /Action:Install /SoftpaqDownnloadFolder:c:\temp\drivers /Silent / ReportFolder:C:\temp\HPIA"
#c:\SWSetup\SP110416\HPImageAssistant.exe /Operation:Analyze /Category:All /selection:All /action:extract /silent /reportFolder:c:\temp\HPIA /softpaqdownloadfolder:c:\temp\drivers
	
}