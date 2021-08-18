$preferences = Get-Content C:\temp\Preferences-jr | ConvertFrom-Json
#Add-Member -Type NoteProperty -Name 'newKey2' -Value 'newValue2'
$preferences |  Add-Member -Type NoteProperty -Name "protocol_handler1.allowed_origin_protocol_pairs.https://centralstatesfunds-qa2.crm.dynamics.com.iwl" -Value 'true'
$preferences | ConvertTo-Json