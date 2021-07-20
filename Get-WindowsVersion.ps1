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
	$Table.Columns.AddRange(@("ComputerName","Windows Edition","Version","OS Build","C size","C free","Boot Time"))
}
Process
{
	Foreach ($Computer in $ComputerName)
	{
		if(Test-Connection -Cn $Computer -BufferSize 16 -Count 1 -ErrorAction 0 -quiet){
			$Code = {
				$ProductName = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' –Name ProductName).ProductName
				Try
				{
					$Version = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' –Name ReleaseID –ErrorAction Stop).ReleaseID
				}
				Catch
				{
					$Version = "N/A"
				}
				$CurrentBuild = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' –Name CurrentBuild).CurrentBuild
				$UBR = (Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion' –Name UBR).UBR
				$OSVersion = $CurrentBuild + "." + $UBR
				$disk = Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='C:'" |
				Select-Object Size,FreeSpace
				$Csize = [int]($disk.Size / 1GB)
				$Cfree = [int]($disk.FreeSpace / 1GB)
				
				$BootTime = ((systeminfo | find "System Boot Time").Substring(20)).trim()
				
				
				$TempTable = New-Object System.Data.DataTable
				$TempTable.Columns.AddRange(@("ComputerName","Windows Edition","Version","OS Build","C size","C free","Boot Time"))
				[void]$TempTable.Rows.Add($env:COMPUTERNAME,$ProductName,$Version,$OSVersion,$Csize,$Cfree,$BootTime)
				
				Return $TempTable
			}
			
			If ($Computer -eq $env:COMPUTERNAME)
			{
				$Result = Invoke-Command –ScriptBlock $Code
				[void]$Table.Rows.Add($Result.Computername,$Result.'Windows Edition',$Result.Version,$Result.'OS Build',$Result.'C size',$Result.'C free',$Result.'Boot Time')
			}
			Else
			{
				Try
				{
					$Result = Invoke-Command –ComputerName $Computer –ScriptBlock $Code –ErrorAction Stop
					[void]$Table.Rows.Add($Result.Computername,$Result.'Windows Edition',$Result.Version,$Result.'OS Build',$Result.'C size',$Result.'C free',$Result.'Boot Time')
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