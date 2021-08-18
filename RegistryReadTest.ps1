$Computer = "PEN-2368-L1" 


$Code = {
	$TempTable = New-Object System.Data.DataTable
	$TempTable.Columns.AddRange(@("ComputerName","PsPath","item"))
	cd HKLM:\SOFTWARE\WOW6432Node
	Get-ChildItem . -rec -ea SilentlyContinue | 
	% { 
		$item = get-itemproperty -Path $_.PsPath -ErrorAction SilentlyContinue
		
		if($item -match 'Wordpad')
		{ 
			$_.PsPath + "  " + $item
			[void]$TempTable.Rows.Add($env:COMPUTERNAME,$_.PsPath,$item)
		} 
	}

	Return $TempTable
}

If ($Computer -eq $env:COMPUTERNAME)
{
	$Result = Invoke-Command –ScriptBlock $Code
}
Else
{
	Try
	{
		$Result = Invoke-Command –ComputerName $Computer –ScriptBlock $Code –ErrorAction Stop
	}
	Catch
	{
		$_
	}
}

$Result

#foreach($res in $Result){
#	$res.Name
#} 

	#	$regm = Get-ChildItem -path HKLM:\SOFTWARE\ -Recurse -ErrorAction SilentlyContinue | 
	#	where { $_.Name -match 'Flash' -and $_.Name -match 'Adobe' -and $_.Name -match 'Installed'} 
	#	$regu = Get-ChildItem -path HKCU:\SOFTWARE\ -Recurse -ErrorAction SilentlyContinue | 
	#	where { $_.Name -match 'Flash' -and $_.Name -match 'Adobe'}
	#	$TempTable = $regm + $regu
	#   $TempTable = $regm