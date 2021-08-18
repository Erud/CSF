
#Clear Windows temp files
#Remove-Item c:\Windows\Temp\* -Recurse -Force -ErrorAction SilentlyContinue
#Remove-Item -LiteralPath "C:\Windows\SysWOW64\Macromed\Flash" -Force -Recurse -ErrorAction SilentlyContinue

$Code = 
{
	
	Try
	{
		$RC = Remove-Item -LiteralPath "C:\Windows\SysWOW64\Macromed\Flash" -Force -Recurse -ErrorAction Continue
	}
	Catch
	{
		$RC = "Error"	
	}
	
	Return $RC
}

$Result = Invoke-Command –ScriptBlock $Code

$Result

takeown /f C:\Windows\SysWOW64\Macromed\Flash /r /d y

icacls C:\Windows\SysWOW64\Macromed /grant administrators:F /T
icacls "C:\Windows\SysWOW64\Macromed" /setowner "Administrators"