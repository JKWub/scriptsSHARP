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
    $locString = "GROSSMONT"
    $list = @{}
    foreach ($compData in $P){
        
        if ($compData."Entity" -eq $locString){
            $old = $compData."Old Asset"
            $SRC = Get-ADComputer -Identity $compData."Old Asset" -Properties MemberOf
            $SRCGroups = CleanADGroups -ComputerName $compData."Old Asset"

            foreach ($group in $SRCGroups) {
                if ($group -eq "MB Microsoft Apps For Enterprise (Prod)"){
                    $list.add( $old, "Has 365")
                }
            }
           
            
            $count++
        }
    }
    $list
    Write-Output "Done Validating... $count number of PC's found. Will refresh in 5 mins"
}


main