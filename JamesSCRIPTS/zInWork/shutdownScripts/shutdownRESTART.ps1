Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

$location = Read-Host "Enter number for your imaging station"
Read-Host ("Are you sure you would like to restart rack #" + $location + "?")

function pcShutdown {
    param (
        $ComputerName
    )
    Write-Output "RESTARTING $computername"
    shutdown /r /m \\$ComputerName /t 2 /c "RESTARTING" /f /d p:4:1
}

function main {
    #$P."Warehouse Location"
    $locString = "Imaging Station #$location"
    $count = 1
    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $new = $compData."New Asset"
            
            pcShutdown -ComputerName $new

        }
    }
}

main
Read-Host "Press Enter to exit"