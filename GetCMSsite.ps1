﻿Set-Location 'C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin'
Import-Module .\ConfigurationManager.psd1
New-PSDrive -Name "CSF" -PSProvider CMSite -Root "psccm-app-01.csfunds.org" 
Set-Location CSF: