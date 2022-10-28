
Import-Module ActiveDirectory
#function that cleans up AD groups or nice visual validation
function CleanADGroups {

    param (
        $ComputerName
    )
    $SRC = Get-ADComputer -Identity $ComputerName -properties memberof
    $AllGroups = $SRC.memberof
    foreach ($Group in $AllGroups) {
        $split = $Group -split {$_ -eq "," -or $_ -eq  "="}
        $split[1]
        
    }
}

#$csv = Read-Host "Please enter CSV filepath"
$P = Import-Csv "U:\admin_localz\JamesK\AD-Script\ADCheckerCSV\pcDataJuly19.csv"
$count = 1
foreach ($comps in $P){
    $Source = $comps.Old
    $Destination = $comps.New

    $SRC = Get-ADComputer -Identity $Source -Properties MemberOf
    $DST = Get-ADComputer -Identity $Destination -Properties MemberOf
    $SRCGroups = CleanADGroups -ComputerName $Source
    $DSTGroups = CleanADGroups -ComputerName $Destination

    foreach ($old in $SRC.MemberOf) {
        foreach ($new in $DST.MemberOf){
            if ($old -eq $new) {
                $groupCount++
            }
        }
    }
    write-host "`n"
    write-host "`n"
    Read-Host "Press enter to check $Source/$Destination"

    if ($SRC.MemberOf.Count -eq $groupCount) {
        Write-Output "$Source has matching AD groups to $Destination"
    }else {
        Write-Output "WARNING!! $Source and $Destination do not match AD groups"
    }

    $srcGroupNum = $SRCGroups.count
    $dstGroupNum = $DSTGroups.count
    if ($SRCGroups.count -gt $DSTGroups.count) {
        Write-Output "$Source Computer has more groups with $srcGroupNum than $Destination with $dstGroupNum"
        $bigGroup = $SRCGroups.count
    }elseif ($SRCGroups.count -eq $DSTGroups.count) {
        Write "$Source Computer and $Destination Computer have the same number of groups. $dstGroupNum groups."
        $bigGroup = $SRCGroups.count
    }elseif ($SRCGroups.count -lt $DSTGroups.count) {
        Write "$Source Computer has less groups with $srcGroupNum than $Destination with $dstGroupNum"
        $bigGroup = $DSTGroups.count
    }
    
    $groupCount = 0
    foreach ($old in $SRCGroups) {
        foreach ($new in $DSTGroups){
            if ($old -eq $new) {
                $groupCount++
                Write-Output "#$groupCount $old --- MATCHES --- $new"
            }
        }
    }
    $groupcount
    if ( ($SRC.MemberOf.Count -eq $groupCount) -and ($groupCount -gt 0) ) {
        Read-Host "$Source seem to have matching AD groups to $Destination, but please press enter to visually validate"
    }else {
        Read-Host "WARNING!! $Source and $Destination do not match AD groups, but please press enter to visually validate"
    }

    for ($i = 0; $i -lt ($bigGroup); $i++){
        $srcgg = $SRCGroups[$i]
        $dstgg = $DSTGroups[$i]
        $countgg = $i + 1
        Write-Output "#$countgg : $srcgg ----- $dstgg"
    }

}

Read-Host -Prompt "Press Enter to exit"