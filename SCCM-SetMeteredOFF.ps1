$CCMNetworkCost = (Invoke-CimMethod -Namespace "root\ccm\ClientSDK" -ClassName "CCM_ClientUtilities" -MethodName GetNetworkCost).Value
Write-Host "ConfigMgr Cost: $($CCMNetworkCost)"
 
If($CCMNetworkCost -ne 1) {
    #Set metering to 1, restart client so it will check in, remove the policy instance, then get new policies
    $PolicyNameSpace = "root\ccm\Policy\Machine\ActualConfig"
    $NwClassName = "CCM_NetworkSettings"
    $obj = Get-CIMInstance -Namespace $PolicyNameSpace -ClassName $NwClassName
    If($obj.MeteredNetworkUsage -ne 1) {
        Write-Host "ConfigMgr MeteredNetworkUsage is set to $($obj.MeteredNetworkUsage)"
        Write-Host "Reseting ConfigMgr CCM_NetworkSettings Policy"
        #Set usage to 1 in the policy first. This allows the client to go get policies. 
        #We will delete the entry at the end to ensure that the setting gets re-applied after a policy refresh.
        #In testing, policies didn't reapply without removing the entry.
        $obj | Set-CimInstance -Property @{MeteredNetworkUsage=1}  
        Restart-Service -Name ccmexec -ErrorAction SilentlyContinue
        #Give policies time to churn
        Start-Sleep -Seconds 30 
        #Remove the policy entry from WMI
        $obj | Remove-CimInstance
        Invoke-CimMethod -Namespace "root\ccm" -ClassName "SMS_Client" -MethodName RequestMachinePolicy -Arguments @{uFlags = [uint32]1 }
        Invoke-CimMethod -Namespace "root\ccm" -ClassName "SMS_Client" -MethodName EvaluateMachinePolicy
    }
}