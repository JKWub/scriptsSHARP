Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

$location = Read-Host "Enter number for your imaging station"
Read-Host "Are you sure you want to shut down rack $location ? You might shut down someone elses PCs. Press enter to continue or please exit"

function pcShutdown {
    param (
        $ComputerName
    )
    Write-Output "SHUTTING DOWN $ComputerName"
    shutdown /s /m \\$ComputerName /t 2 /c "Reconfiguring myapp.exe" /f /d p:4:1
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