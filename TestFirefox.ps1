if (Test-Path ($env:USERPROFILE + "\AppData\Local\Mozilla Firefox\uninstall\helper.exe") )
{
   [System.Diagnostics.FileVersionInfo]::GetVersionInfo($env:USERPROFILE + "\AppData\Local\Mozilla Firefox\uninstall\helper.exe").ProductVersion
}

if (Test-Path (${env:ProgramFiles(x86)} + "\Mozilla Firefox\uninstall\helper.exe") )
{
    [System.Diagnostics.FileVersionInfo]::GetVersionInfo(${env:ProgramFiles(x86)} + "\Mozilla Firefox\uninstall\helper.exe").ProductVersion
}

if (Test-Path ($env:ProgramFiles + "\Mozilla Firefox\uninstall\helper.exe") )
{
    [System.Diagnostics.FileVersionInfo]::GetVersionInfo($env:ProgramFiles + "\Mozilla Firefox\uninstall\helper.exe").ProductVersion
}