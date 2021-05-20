# Params
$HPIAWebUrl = "https://ftp.hp.com/pub/caps-softpaq/cmit/HPIA.html" # Static web page of the HP Image Assistant

$WorkingDirectory = "c:\temp\WHPIA"

# Function write to a log file in ccmtrace format
Function script:Write-Log {

    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
		
        [Parameter()]
        [ValidateSet(1, 2, 3)] # 1-Info, 2-Warning, 3-Error
        [int]$LogLevel = 1,

        [Parameter(Mandatory = $true)]
        [string]$Component,

        [Parameter(Mandatory = $false)]
        [object]$Exception
    )

    $LogFile = "$WorkingDirectory\HP_BIOS_Update.log"
    
    If ($Exception)
    {
        [String]$Message = "$Message" + "$Exception"
    }

    $TimeGenerated = "$(Get-Date -Format HH:mm:ss).$((Get-Date).Millisecond)+000"
    $Line = '<![LOG[{0}]LOG]!><time="{1}" date="{2}" component="{3}" context="" type="{4}" thread="" file="">'
    $LineFormat = $Message, $TimeGenerated, (Get-Date -Format MM-dd-yyyy), $Component, $LogLevel
    $Line = $Line -f $LineFormat
    
    # Write to log
    Add-Content -Value $Line -Path $LogFile -ErrorAction SilentlyContinue

}

#################################
## Disable IE First Run Wizard ##
#################################
# This prevents an error running Invoke-WebRequest when IE has not yet been run in the current context
Write-Log -Message "Disabling IE first run wizard" -Component "Preparation"
$null = New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "Internet Explorer" -Force
$null = New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer" -Name "Main" -Force
$null = New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" -Name "DisableFirstRunCustomize" -PropertyType DWORD -Value 1 -Force

##########################
## Get latest HPIA Info ##
##########################
Write-Log -Message "Finding info for latest version of HP Image Assistant (HPIA)" -Component "DownloadHPIA"
try
{
    $HTML = Invoke-WebRequest -Uri $HPIAWebUrl -ErrorAction Stop
}
catch 
{
    Write-Log -Message "Failed to download the HPIA web page. $($_.Exception.Message)" -Component "DownloadHPIA" -LogLevel 3
   # Upload-LogFilesToAzure
    throw
}
$HPIASoftPaqNumber = ($HTML.Links | Where {$_.href -match "hp-hpia-"}).outerText
$HPIADownloadURL = ($HTML.Links | Where {$_.href -match "hp-hpia-"}).href
$HPIAFileName = $HPIADownloadURL.Split('/')[-1]
Write-Log -Message "SoftPaq number is $HPIASoftPaqNumber" -Component "DownloadHPIA"
Write-Log -Message "Download URL is $HPIADownloadURL" -Component "DownloadHPIA"


##################
## Extract HPIA ##
##################
Write-Log -Message "Extracting the HPIA" -Component "Analyze"
try 
{
    $Process = Start-Process -FilePath $WorkingDirectory\$HPIAFileName -WorkingDirectory $WorkingDirectory -ArgumentList "/s /f .\HPIA\ /e" -NoNewWindow -PassThru -Wait -ErrorAction Stop
    Start-Sleep -Seconds 5
    If (Test-Path $WorkingDirectory\HPIA\HPImageAssistant.exe)
    {
        Write-Log -Message "Extraction complete" -Component "Analyze"
    }
    Else  
    {
        Write-Log -Message "HPImageAssistant not found!" -Component "Analyze" -LogLevel 3
        
        throw
    }
}
catch 
{
    Write-Log -Message "Failed to extract the HPIA: $($_.Exception.Message)" -Component "Analyze" -LogLevel 3
   
    throw
}


##############################################
## Analyze available BIOS updates with HPIA ##
##############################################
Write-Log -Message "Analyzing system for available BIOS updates" -Component "Analyze"
try 
{
    $Process = Start-Process -FilePath $WorkingDirectory\HPIA\HPImageAssistant.exe -WorkingDirectory $WorkingDirectory -ArgumentList "/Operation:Analyze /Category:BIOS /Selection:All /Action:List /Silent /ReportFolder:$WorkingDirectory\Report" -NoNewWindow -PassThru -Wait -ErrorAction Stop
    If ($Process.ExitCode -eq 0)
    {
        Write-Log -Message "Analysis complete" -Component "Analyze"
    }
    elseif ($Process.ExitCode -eq 256) 
    {
        Write-Log -Message "The analysis returned no recommendation. No BIOS update is available at this time" -Component "Analyze" -LogLevel 2
      
        Exit 0
    }
    elseif ($Process.ExitCode -eq 4096) 
    {
        Write-Log -Message "This platform is not supported!" -Component "Analyze" -LogLevel 2
     
        throw
    }
    Else
    {
        Write-Log -Message "Process exited with code $($Process.ExitCode). Expecting 0." -Component "Analyze" -LogLevel 3
      
        throw
    }
}
catch 
{
    Write-Log -Message "Failed to start the HPImageAssistant.exe: $($_.Exception.Message)" -Component "Analyze" -LogLevel 3
  
    throw
}
# Read the XML report
Write-Log -Message "Reading xml report" -Component "Analyze"
try 
{
    $XMLFile = Get-ChildItem -Path "$WorkingDirectory\Report" -Recurse -Include *.xml -ErrorAction Stop
    If ($XMLFile)
    {
        Write-Log -Message "Report located at $($XMLFile.FullName)" -Component "Analyze"
        try 
        {
            [xml]$XML = Get-Content -Path $XMLFile.FullName -ErrorAction Stop
            $Recommendation = $xml.HPIA.Recommendations.BIOS.Recommendation
            If ($Recommendation)
            {
                $CurrentBIOSVersion = $Recommendation.TargetVersion
                $ReferenceBIOSVersion = $Recommendation.ReferenceVersion
                $DownloadURL = "https://" + $Recommendation.Solution.Softpaq.Url
                $SoftpaqFileName = $DownloadURL.Split('/')[-1]
                Write-Log -Message "Current BIOS version is $CurrentBIOSVersion" -Component "Analyze" 
                Write-Log -Message "Recommended BIOS version is $ReferenceBIOSVersion" -Component "Analyze" 
                Write-Log -Message "Softpaq download URL is $DownloadURL" -Component "Analyze" 
            }
            Else  
            {
                Write-Log -Message "Failed to find a BIOS recommendation in the XML report" -Component "Analyze" -LogLevel 3
               
                throw
            }
        }
        catch 
        {
            Write-Log -Message "Failed to parse the XML file: $($_.Exception.Message)" -Component "Analyze" -LogLevel 3
           
            throw
        }
    }
    Else  
    {
        Write-Log -Message "Failed to find an XML report." -Component "Analyze" -LogLevel 3
      
        throw
    }
}
catch 
{
    Write-Log -Message "Failed to find an XML report: $($_.Exception.Message)" -Component "Analyze" -LogLevel 3
  
    throw
}

