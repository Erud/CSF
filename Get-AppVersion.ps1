[CmdletBinding()]

Param
(
[Parameter(Mandatory=$false,
ValueFromPipelineByPropertyName=$true,
ValueFromPipeline=$true
)]
[string[]]$ComputerName = $env:COMPUTERNAME,
[string[]]$Appname = "Google Chrome"
)


Begin
{
	$Table = New-Object System.Data.DataTable
	$Table.Columns.AddRange(@("ComputerName","bits","DisplayName","DisplayVersion","InstallDate"))
}
Process
{
	Foreach ($Computer in $ComputerName)
	{
		if(Test-Connection -Cn $Computer -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
			$Code = {
				
				Try
				{
					$line = Get-CimInstance Win32_Product | select -Property *  | Where-Object { $_.Name -match "^*$appname*"} 
					$32bit = get-itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "^*$appname*"}
					$64bit = get-itemproperty 'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "^*$appname*"}
				}
				Catch
				{
					$32bit = "N/A"
					$64bit = "N/A"
					$line  = "N/A"
					
				}
				
				$TempTable = New-Object System.Data.DataTable
				$TempTable.Columns.AddRange(@("ComputerName","bits","DisplayName","DisplayVersion","InstallDate"))
				if ($64bit -eq "" -or $64bit.count -eq 0) {
					
					switch ($32bit.DisplayName.count) {
						0 {[void]$TempTable.Rows.Add($env:COMPUTERNAME,"Cannot find the uninstall string","","")}
						1 {
							[void]$TempTable.Rows.Add($env:COMPUTERNAME,"32",$32bit[0].DisplayName,$32bit[0].DisplayVersion,$line.InstallDate)
						}
						default { Write-Host "Please Narrow Down Your Search" -ForegroundColor Red }
					}
				}
				else {
					
					switch ($64bit.DisplayName.count) {
						0 {[void]$TempTable.Rows.Add($env:COMPUTERNAME,"Cannot find the uninstall string","","")}
						1 {
							[void]$TempTable.Rows.Add($env:COMPUTERNAME,"64",$64bit[0].DisplayName,$64bit[0].DisplayVersion,$line.InstallDate)
						}
						default { Write-Host "Please Narrow Down Your Search" -ForegroundColor Red }
					}
				}
				
				
				Return $TempTable
			}
			
			If ($Computer -eq $env:COMPUTERNAME)
			{
				$Result = Invoke-Command –ScriptBlock $Code
				[void]$Table.Rows.Add($Result.Computername,$Result.bits,$Result.DisplayName,$Result.DisplayVersion,$Result.InstallDate)
			}
			Else
			{
				Try
				{
					$Result = Invoke-Command –ComputerName $Computer –ScriptBlock $Code –ErrorAction Stop
					[void]$Table.Rows.Add($Result.Computername,$Result.bits,$Result.DisplayName,$Result.DisplayVersion,$Result.InstallDate)
				}
				Catch
				{
					$_
				}
			}
		}
		else { 
			[void]$Table.Rows.Add($Computer,"Offline","","") 
		}	
	}
	
}
End
{
	Return $Table
}