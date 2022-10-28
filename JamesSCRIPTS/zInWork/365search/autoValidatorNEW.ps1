Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 

cls



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

    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $old = $compData."Old Asset"
            $new = $compData."New Asset"
            $SRC = Get-ADComputer -Identity $compData."Old Asset" -Properties MemberOf
            $DST = Get-ADComputer -Identity $compData."New Asset" -Properties MemberOf
            $SRCGroups = CleanADGroups -ComputerName $compData."Old Asset"
            $DSTGroups = CleanADGroups -ComputerName $compData."New Asset"

            Write-Verbose "Test"
            
            $count++
        }
    }
    Write-Output "Done Validating... $count number of PC's found. Will refresh in 5 mins"
}


