
$Computer = Read-Host "Remote computer name"

[int]$SleepTimer = Read-Host "Minutes between attempts"
[int]$SleepSeconds = $SleepTimer * 60
[int]$Attempts = Read-Host "Number of attempts"
[int]$AttemptsCounter = 0
$StartDate = Get-Date -Format D
$StartTime = Get-Date -Format T
Write-Host "Testing to see if $Computer is online..."

Do 
{
   $AttemptsCounter++
   $RemainingAttempts = ([int]$Attempts - [int]$AttemptsCounter)
   $Online = Test-Connection -ComputerName $Computer -Quiet
   If ($Online -NE "True") 
   {
       Write-Host "Computer $Computer is " -NoNewLine
       Write-Host "Offline" -BackgroundColor Red -ForegroundColor Black -NoNewline
       If ($AttemptsCounter -eq $Attempts) {
          Write-Host "."
       }
       Else {
          Write-Host ". Pausing for $SleepSeconds seconds. Remaining attempts: $RemainingAttempts"
       }
   }

   #Check the number of attempts, break out if reached.
   If ($AttemptsCounter -eq $Attempts) {break}

   #Delay
   Start-Sleep -s ($SleepTimer * 60)
}
While ($Online -NE "True")

$EndDate = Get-Date -Format D
$EndTime = Get-Date -Format T
If ($Online -NE "True") {
   Write-Host "Maximum number of attempts reached."
   }
Else {
   Write-Host
   Write-Host "Computer $Computer is " -NoNewline
   Write-Host "ONLINE" -BackgroundColor Green -ForegroundColor White
   Write-Host "Search began on $StartDate at $StartTime."
   Write-Host "Found online on $EndDate at $EndTime."
}
