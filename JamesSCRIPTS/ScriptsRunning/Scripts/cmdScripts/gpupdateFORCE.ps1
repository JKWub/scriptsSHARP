Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel "\\shcsd\sharp\soc\groups\ISD Common\JamesSCRIPTS\ScriptsRunning\DATAplsUpdate\sharepoint.xlsx"

$location = Read-Host "Enter number for your imaging station"

function bdeStart {
    param (
        $ComputerName
    )
    Invoke-GPUpdate -Computer $ComputerName  -RandomDelayInMinutes 0
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