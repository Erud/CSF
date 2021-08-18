#Get-ADComputer -Identity 'CTS-01397-L1'

Get-Content C:\Temp\pc.txt | Get-ADComputer | select name,DistinguishedName