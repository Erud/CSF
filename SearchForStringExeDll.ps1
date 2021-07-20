Get-ChildItem -Path c:\ -Include *.exe, *.dll -Recurse -ErrorAction SilentlyContinue -ErrorVariable +err| 
Where-Object { $_.Attributes -ne "Directory"} |
Select-String -Pattern msxml4 | Select -Unique Path
$err.count

#Get-ChildItem -Recurse filespec | Select-String pattern | Select-Object -Unique Path
#ls -r filespec | sls pattern | select -u Path