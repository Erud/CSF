$ProfileList = Get-NetConnectionProfile
ForEach ($Profile in $ProfileList.Name) {
    (netsh wlan show profile name="$($Profile)")
}

 	
Invoke-CimMethod -Namespace "root\ccm\ClientSDK" -ClassName "CCM_ClientUtilities" -MethodName GetNetworkCost

# --------------------------------------------------------------------------------------------------------------------

$connectionProfile = [Windows.Networking.Connectivity.NetworkInformation]::GetInternetConnectionProfile()

$connectionCost = $connectionProfile.GetConnectionCost()

$networkCostType = $connectionCost.NetworkCostType

echo $networkCostType 