If(!(test-path c:\temp))
{
	New-Item -ItemType Directory -Force -Path c:\temp
}

Copy-Item -Path \\ppdq-app-01\installs\HPIA\hp-hpia-5.0.4.exe -Destination c:\temp -Force