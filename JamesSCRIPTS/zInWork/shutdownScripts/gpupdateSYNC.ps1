Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

$location = Read-Host "Enter number for your imaging station"

function bdeStart {
    param (
        $ComputerName
    )
    psexec \\$ComputerName gpupdate /sync
}

function main {
    #$P."Warehouse Location"
    $locString = "Imaging Station #$location"
    $count = 1
    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $new = $compData."New Asset"

            Write-Output ""
            Write-Output "Group Policy is being updated for $new"
            bdeStart -ComputerName $new

        }
    }
}

main
Read-Host "Press Enter to exit"