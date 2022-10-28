Import-Module ActiveDirectory


#isolated function that cleans up AD groups or nice visual validation
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






$num = Read-Host -Prompt 'Enter number of computers?'

while ($num -ne 0){



$Source = Read-Host "Enter the source computer name"

$Destination = Read-Host "Enter the destination computer name"


# OUPath is the South Bend OU in AD Computers & Users
$OUPath = "OU=Domain Controllers,DC=shcsd,DC=sharp,DC=com"

# PDC is the Primary Domain Controller
$PDC = "Domain Controller"


$SRC = Get-ADComputer -Identity $Source -Properties MemberOf
$DST = Get-ADComputer -Identity $Destination -Properties MemberOf


$SRCGroups = CleanADGroups -ComputerName $Source
$DSTGroups = CleanADGroups -ComputerName $Destination





foreach ($ComputerGroup in $SRC.memberOf) {
    if($DST.MemberOf -notcontains $ComputerGroup) {
        Add-ADGroupMember -Identity $ComputerGroup -Members $DST 
    }
    Write-Output $ComputerGroup
    Write-Output " "
}
$num = $num - 1
}

