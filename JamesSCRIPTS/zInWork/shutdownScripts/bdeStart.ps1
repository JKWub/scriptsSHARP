Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

$location = Read-Host "Enter number for your imaging station"

function bdeStart {
    param (
        $ComputerName
    )
    manage-bde -cn $ComputerName -on c:
}

function main {
    #$P."Warehouse Location"
    $locString = "Imaging Station #$location"
    $count = 1
    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $new = $compData."New Asset"
            
            bdeStart -ComputerName $new

        }
    }
}

main
Read-Host "Press Enter to exit"