#Requires -Version 3
param (
[Parameter(Mandatory = "True")]
[String]$ComputerName
)
#This is to reset any variables from previous runs
$IP = @($null)
$actualTarget = $null
$address = $null

#Grab all IPv4 addresses registered to the ComputerName, if you would like to search IPv6 also remove the parameter "-Type A"
Try {
	$IP = (Resolve-DnsName $computerName -Type A -ErrorAction "Stop" | Select-Object -Property IPAddress).ipaddress
} Catch {
	Throw "The ComputerName entered does not have a valid IP"
}
#Test if the IP responds- if not we need not continue- We'll remove the non working IP from the $IP array
ForEach ($address in $IP){
	If ((Test-Connection $address -count 1 -quiet) -eq $false){
		$IP = $IP | Select-Object -Skip 1
	}
}

#If the Test-Connection fails the address was removed above, if all IPs were removed then we will throw a terminating error, no reason to continue
If ($IP.COUNT -eq 0 ){ 
	Throw "The IPs returned from DNS failed the connection test, be sure the target is powered on and responds to a ping."
}

#Bring in the results list Object so we can filll it up later
$Results = New-Object System.Collections.Generic.List[Object]

#For every address we found registered to the target and passsed the Test-Connection step we'll loop in our tests-
ForEach ($address in $IP){
	
	#Initially we will attempt a Get-CimInstance method to grab the hostname- these methods will require permissions for the respective types of attempts.
	Try {
		$ActualTarget = (Get-CimInstance -ClassName "Win32_ComputerSystem" -ComputerName $ComputerName -ErrorAction "Stop").Name
	}Catch{
		
		#If the Get-CimInstance fails we can silently move to attempt a Get-WmiObject- if both fail we will write an error for this IP tested 
		Try {
			$actualTarget = Get-WmiObject -class Win32_ComputerSystem -property Name -ComputerName $address | select -expand Name -ErrorAction "Stop"
		} Catch {
			Write-Error "The WMI call to $address failed or the target is offline- Ensure you can remotely manage this target with PowerShell and it is powered on. Be user you are logged in as an admin. You may need to check or enable WinRM, PSRemoting, or Execution Policies"
		}
	}
	
	#This will test the SMB connection on port 445 with the name that was returned by the connected host not necessarily the ComputerName given
	$connectionTest = Test-NetConnection -computername $actualTarget -port 445
	
	#This will feed the data gathered into the $Results list we generated earlier
	$Results.Add([PSCustomObject]@{
		"Expected Target"   = $ComputerName
		"IP Address we found"      = $Address
		"Actual Target"     = $ActualTarget
		"Test Successful" = $ConnectionTest.TcpTestSucceeded
	})
}
#This will display the $Results list we filled up with the things.
$Results