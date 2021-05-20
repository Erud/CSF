$model=(Get-WmiObject -Class:Win32_ComputerSystem).Model
#$BIOSKey=Get-ItemProperty -path HKLM:\SYSTEM\HardwareConfig\Current\ -ErrorAction SilentlyContinue
$BIOSVersion=0
$BIOSVersion=(wmic bios get smbiosbiosversion) -replace '\D+(\d+)','$1'
[int]$intBIOSVersion=[convert]::ToInt32($BIOSVersion[2].TrimEnd(), 10)
$CompliantVersion=0
$Compliant=0
$a=0

#Add all models and versions in a 2d array for later iteration
$VersionMap=@(
("A-1054-QALAN",""),
("HP Compaq 6200 Pro SFF PC","J01 v02.31"),
("HP Compaq Pro 4300",""),
("HP Compaq Pro 4300 SFF PC",""),
("HP Elite Dragonfly","R93 Ver. 01.05.03"),
("HP EliteBook 1040 G4","P96 Ver. 01.23"),
("HP EliteBook 840 G3","N75 Ver. 01.33"),
("HP EliteBook 840 G5","Q78 Ver. 01.04.00"),
("HP EliteBook 840 G6","R70 Ver. 01.03.03"),
("HP EliteBook 840 G7 Notebook PC","S70 Ver. 01.04.02"),
("HP EliteBook 850 G4","P78 Ver. 01.23"),
("HP EliteBook 850 G6","R70 Ver. 01.08.01"),
("HP EliteBook Folio 1040 G3","N83 Ver. 01.33"),
("HP EliteBook Folio 9470m","68IBD Ver. F.69"),
("HP EliteBook Folio 9480m","M85 Ver. 01.46"),
("HP EliteBook x360 1030 G2","P80 Ver. 01.25"),
("HP EliteBook x360 1030 G3","Q90 Ver. 01.04.04"),
("HP EliteBook x360 1040 G5","Q74 Ver. 01.06.00"),
("HP EliteDesk 800 G1","L01 v02.3"),
("HP EliteDesk 800 G1 SFF","L01 v02.74"),
("HP EliteDesk 800 G1 TWR","L01 v02.74"),
("HP EliteDesk 800 G2 TWR","N01 Ver. 02.36"),
("HP EliteDesk 800 G3 DM 35W","P21 Ver. 02.25"),
("HP EliteDesk 800 G3 TWR","P01 Ver. 02.22"),
("HP EliteDesk 800 G4 DM 35W","Q21 Ver. 02.04.01"),
("HP EliteDesk 800 G4 DM 35W (TAA)","Q21 Ver. 02.04.01"),
("HP EliteDesk 800 G4 DM 65W","Q21 Ver. 02.04.01"),
("HP EliteDesk 800 G5 Desktop Mini","R21 Ver. 02.03.01"),
("HP EliteOne 1000 G2 34-in Curved AiO","Q10 Ver. 02.04.02"),
("HP EliteOne 800 G1 AiO","L01 v02.74"),
("HP Z2 Mini Desktop G4","Q50 Ver. 01.05.05"),
("HP Z2 Mini G4 Workstation","Q50 Ver. 01.01.08"),
("HP Z230 Tower Workstation","L51 v01.61"),
("HP Z240 Tower Workstation","N51 Ver. 01.72"),
("HP ZBook 14u G5","Q78 Ver. 01.04.00"),
("HP ZBook 15 G4","P70 Ver. 01.29"),
("HP ZBook 15v G5","F.10"),
("HP ZBook Power G7 Mobile Workstation","T75 Ver. 01.04.01"),
("HP ZBook Studio G5","Q71 Ver. 01.04.05"),
("P70 Ver. 01.23","P70 Ver. 01.23"),
("SLIC-BPC",""),
("SLIC-CPC","")
)

#Iterate through VersionMap to confirm version number based on model
while ($a -lt $VersionMap.Length) {

	if ($model -eq $VersionMap[$a][0]){$CompliantVersion=$VersionMap[$a][1]; $a=$VersionMap.Length+1}$a++

	}
#Normalize version format to decimal integer and compare versions to determine if local version is greater or equal to qalifying version
if ($CompliantVersion -ne "" -or $null -or 0){

$CleanCompliantVersion=$CompliantVersion -replace '\D+(\d+)','$1'

$intCleanCompliantVersion=[int]$intCleanCompliantVersion=[convert]::ToInt32($CleanCompliantVersion.TrimEnd(), 10)

    if ($intCleanCompliantVersion -ne "" -or $null -or 0) {

        if ($intBIOSVersion -ge $intCleanCompliantVersion) {

        $Compliant=$true

        }

        else {

        $Compliant=$false

        }

	}

	else {

    $Compliant=$false

	}
}

else {

$Compliant=$false

}

$Compliant