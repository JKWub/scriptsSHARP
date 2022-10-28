#may need to download windows server package for this module to be found
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

$path = Read-Host "Please enter the file path to a CSV with new/old comps"

$P = Import-Csv $path
$count = 1
:core foreach ($comps in $P) {
    $Source = $comps.Old
    $Destination = $comps.New
    write-host "`n"
    Read-Host "Press Enter to copy $Source to $Destination"
    
    $SRC = Get-ADComputer -Identity $Source -Properties MemberOf
    $DST = Get-ADComputer -Identity $Destination -Properties MemberOf

    $SRCGroups = CleanADGroups -ComputerName $Source
    $DSTGroups = CleanADGroups -ComputerName $Destination

    <#
    #The 3 loops below area a check that the DST comp does not have more groups than SRC comp. Since if this case happens it is most likely a user error and may cause damage to group orginization
    $srcCount = 0
    $dstCount = 0
    foreach ($old in $SRC.MemberOf) {
        $srcCount++
    }
    foreach ($new in $DST.MemberOf) {
        $dstCount++
    }
    if ($dstCount -ge $srcCount) {
        Write-Output "WARNING!! The group count for the destination computer was greater than or equal to the source computer. Exiting now..."
        break :core
    }
    #Checking that the SRC group count > 0
    if (($SRC.memberof).count -eq 0) {
        Write-Output "The group count of the source computer is 0. Therefore there is nothing to copy and a mistake has been made. Exiting..."
        break :core
    }
    #Checkin that the DST group count is 4 so that is a freshly imaged PC
    if (($DST.memberof).count -gt 4) {
        Write-Output "The group count of the Destination computer is greater than 4. Therefore it is not a freshly imaged PC and a mistake has been made. Exiting..."
        break :core
    }
    #>
    
    
    Write-Output "#$count copying computers $Source/$Destination"
    $zcount = 0
    foreach ($ComputerGroup in $SRC.memberOf) {
        if($DST.MemberOf -notcontains $ComputerGroup) {
            $onNum = $zcount + 1
            $groupz = $SRCGroups[$zcount]
            Write-Output "Copying Group #$onNum -- $groupz"
            Add-ADGroupMember -Identity $ComputerGroup -Members $DST
            $zcount++ 
        }
    }

    $count++

}

Read-Host -Prompt "Press Enter to exit"