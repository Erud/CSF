FUNCTION SCCM-GetComputerByLastLoggedOnUser {
Param([parameter(Mandatory = $true)]$SamAccountName,
    $SiteName="CSF",
    $SCCMServer="PSCCM-APP-01.CSFUNDS.ORG")
    $SCCMNameSpace="root\sms\site_$SiteName"
    Get-WmiObject -namespace $SCCMNameSpace -computer $SCCMServer -query "select Name from sms_r_system where LastLogonUserName='$SamAccountName'" | select Name
}


$user = "jflowers"

$comp = SCCM-GetComputerByLastLoggedOnUser $user
"$comp;$user" 