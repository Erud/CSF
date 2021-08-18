$name = "pcsc"
$computers = get-content "c:\temp\$name.txt"
$nameAD = "C:\Temp\$name" + "AD.txt"

if (Test-Path $nameAD) 
{
	Remove-Item $nameAD
}

$dcs = Get-ADDomainController -Filter * | select Name

foreach ($comp in $computers) {
	#	$comp = $comp.Trim() + ".centurionmp.com"
	$comp = $comp.Trim()
	$ldate = $null
	foreach ($dc in $dcs) {
		Try
		{
			$compd =  Get-ADComputer -Server $dc.Name -Identity $comp -Properties lastlogondate -ErrorAction SilentlyContinue
		}
		Catch
		{
			$compd = $null
		}
		if ($ldate -lt $compd.LastLogonDate) { $ldate = $compd.LastLogonDate}
	}
	Add-Content $nameAD "$($comp);$($ldate)"
}