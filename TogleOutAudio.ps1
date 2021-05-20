
$Speaker = "{0.0.0.00000000}.{d5495279-0fed-4a90-a5cd-9814bd8e5dd3}"
$Headset = "{0.0.0.00000000}.{e5aa06fb-7739-4be1-bd9b-9d0377bc9c1e}"

# Toggle default playback device
$DefaultPlayback = Get-AudioDevice -Playback
If ($DefaultPlayback.ID -eq $Speaker) {Set-AudioDevice -ID $Headset | Out-Null}
Else {Set-AudioDevice -ID $Speaker | Out-Null}