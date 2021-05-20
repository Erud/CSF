# powershell.exe -nologo -command C:\Users\erudakov\Documents\PS\SayYouGetEmail.ps1
$Speaker = "{0.0.0.00000000}.{d5495279-0fed-4a90-a5cd-9814bd8e5dd3}"
$Headset = "{0.0.0.00000000}.{e5aa06fb-7739-4be1-bd9b-9d0377bc9c1e}"
Set-AudioDevice -ID $Speaker | Out-Null

Add-Type -AssemblyName System.speech
$speak = New-Object System.Speech.Synthesis.SpeechSynthesizer
$speak.Volume = 100
$speak.Speak("You get email from the boss $(Get-Date)")
$speak.Dispose()
Start-Sleep -s 3

Set-AudioDevice -ID $Headset | Out-Null