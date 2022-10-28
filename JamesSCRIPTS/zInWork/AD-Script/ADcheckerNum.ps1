#check each group one by one
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


$num = Read-Host -Prompt 'Press enter to start comparing'

while ($num -ne 0){

    $Source = Read-Host "Enter the source computer name"

    $Destination = Read-Host "Enter the destination computer name"

    $SRC = Get-ADComputer -Identity $Source -Properties MemberOf
    $DST = Get-ADComputer -Identity $Destination -Properties MemberOf
    $groupCount = 0

    $SRCGroups = CleanADGroups -ComputerName $Source
    $DSTGroups = CleanADGroups -ComputerName $Destination

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
    #note wanted to add a catch for bad matches 
    $forcount = 1
    foreach($srcG in $SRCGroups){
            foreach($dstG in $DSTGroups){
                if ($srcG -eq $dstG){
                    Write-Output "#$forcount $srcG -- Source MATCHES Destination -- $dstG"
                    
                }
            }
            $forcount++
        }

    foreach ($old in $SRC.MemberOf) {
        foreach ($new in $DST.MemberOf){
            if ($old -eq $new) {
                $groupCount++
            }
        }
    }

    if ( ($SRC.MemberOf.Count -eq $groupCount) -and ($groupCount -gt 0) ) {
        Write-Output "$Source has matching AD groups to $Destination"
    }else {
        Write-Output "WARNING!! $Source and $Destination do not match AD groups"
    }


}

Read-Host -Prompt "Press Enter to exit"