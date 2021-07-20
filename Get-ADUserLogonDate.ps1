$user = "acromble"
Get-ADUser -Identity $user -Properties “LastLogonDate”

Get-ADComputer -Identity "CTS-00911-D1" -Properties * | FT Name, LastLogonDate -Autosize


Get-ADUser -Identity $user -Properties * | Select-Object Name, msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon | Sort-Object -Descending msDS-FailedInteractiveLogonCountAtLastSuccessfulLogon