﻿Get-ADUser -Filter * -SearchBase "OU=Participant Services,OU=CSF Departments,DC=CSFUNDS,DC=ORG" | Export-Csv C:\Temp\users.csv -NoTypeInformation