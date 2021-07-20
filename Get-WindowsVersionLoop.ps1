$name = "pcsw"
$computers = get-content "c:\temp\$name.txt"
$Table = New-Object System.Data.DataTable
$Table.Columns.AddRange(@("ComputerName","Windows Edition","Version","OS Build","C size","C free","Boot Time"))
foreach ($comp in $computers) {
	$comp = $comp.Trim()
	
	$Result = 	.\Get-WindowsVersion.ps1 -ComputerName $comp
	
	[void]$Table.Rows.Add($Result.Computername,$Result.'Windows Edition',$Result.Version,$Result.'OS Build',$Result.'C size',$Result.'C free',$Result.'Boot Time')
	
}

$Table | Format-Table

# Get-ADComputer -Identity IR-01098-L2 -Properties *