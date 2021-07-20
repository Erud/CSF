$comp = "CTS-01517-D1"
$comp
$disk = Get-WmiObject Win32_LogicalDisk -ComputerName $comp -Filter "DeviceID='C:'" |
Select-Object Size,FreeSpace
[int]($disk.Size / 1GB), [int]($disk.FreeSpace / 1GB)

systeminfo /s $comp | find "System Boot Time"
