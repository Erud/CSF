[CmdletBinding()]

Param
(
[Parameter(Mandatory=$false,
ValueFromPipelineByPropertyName=$true,
ValueFromPipeline=$true
)]
[string[]]$ComputerName = $env:COMPUTERNAME
)


Begin
{
	$Table = New-Object System.Data.DataTable
	$Table.Columns.AddRange(@("ComputerName","DisplayName","Publisher","InstallDate","DisplayVersion","UninstallString"))
}
Process
{
	Foreach ($Computer in $ComputerName)
	{
		if(Test-Connection -Cn $Computer -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
			$Code = {
				$regpath = @(
				'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'
				'HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*'
				)
				Try
				{
					$result = Get-ItemProperty $regpath | .{process{if($_.DisplayName -and $_.UninstallString) { $_ } }} | Select DisplayName, Publisher, InstallDate, DisplayVersion, UninstallString
				}
				Catch
				{
					$result = "N/A"
				}
				
				
				Return $result
			}
			
			If ($Computer -eq $env:COMPUTERNAME)
			{
				$Result = Invoke-Command –ScriptBlock $Code
				foreach($line in $Result){
					[void]$Table.Rows.Add($Computer,$line.DisplayName,$line.Publisher,$line.InstallDate,$line.DisplayVersion,$line.UninstallString)
				}
			}
			Else
			{
				Try
				{
					$Result = Invoke-Command –ComputerName $Computer –ScriptBlock $Code –ErrorAction Stop
					foreach($line in $Result){
						[void]$Table.Rows.Add($Computer,$line.DisplayName,$line.Publisher,$line.InstallDate,$line.DisplayVersion,$line.UninstallString)
					}
				}
				Catch
				{
					$_
				}
			}
		}
		else { 
			[void]$Table.Rows.Add($Computer,"Offline","","","","") 
		}	
	}
	
}
End
{
	Return $Table
}

# .\Get-WindowsInstalledSW.ps1 CTS-01504-L1 | sort displayname | Out-GridView