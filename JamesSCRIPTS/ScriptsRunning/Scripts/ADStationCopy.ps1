Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel "\\shcsd\sharp\soc\groups\ISD Common\JamesSCRIPTS\ScriptsRunning\DATAplsUpdate\sharepoint.xlsx"


cls
$location = Read-Host "Welcome to the AD copier. Enter number for your imaging station"


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



function main {
    #$P."Warehouse Location"
    $locString = "Imaging Station #$location"
    $count = 1
    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $old = $compData."Old Asset"
            $new = $compData."New Asset"
            $SRC = Get-ADComputer -Identity $compData."Old Asset" -Properties MemberOf
            $DST = Get-ADComputer -Identity $compData."New Asset" -Properties MemberOf
            $SRCGroups = CleanADGroups -ComputerName $compData."Old Asset"
            $DSTGroups = CleanADGroups -ComputerName $compData."New Asset"

            Write-Output ""
            Write-Output ""
            Read-Host "About to copy $old/$new -- Press ENTER to continue"
            Write-Output "____________ #$count - Data for $old/$new ____________"
            Write-Output ""
    
           
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
    }
    Read-Host "Done copying. Press enter to exit~~~"
}

main
