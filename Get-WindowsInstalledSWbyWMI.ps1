$list = 'CTS-01504-L1'

#,'CTS-STAO-VM1','CTS-ACROMB-VM01'

foreach($PC in $list){
    $data = Get-WmiObject -ComputerName $PC -Class Win32_Product | sort-object Name | 
    Select-Object Name |  Where-Object { $_.Name -like "*Visual*" -or $_.name -like "*VS*"}
    #Where-Object { $_.Name -like "*McAfee*" -or $_.name -like "*splunk*"}
    if($data){
       # Write-Output "$PC has $($data.name) installed" |
       # out-file c:\output.txt -Append
      $data | out-file c:\temp\output.txt 
    }
}