Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

cls


function removePrinters {
    param (
        $CompterName
    )

    Remove-Printer -Name "Microsoft XPS Document Writer" -ComputerName $ComputerName
    Remove-Printer -Name "Fax" -ComputerName $ComputerName

}

function getPrint {
    param (
        $ComputerName
    )

    
}

function compData {
    param (
        $location
    )
    $locString = ""
    $data = @{}
    if ($location -eq "laptop"){
        Write-Output "Location is: Laptop Configuration Counter"
        $location = "Laptop Configuration Counter"
        $locString = "Laptop Configuration Counter"
    }else {
        $locString = "Imaging Station #$location"
        Write-Output "Location is: $locString" 
    }
    $count = 0
    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $old = $compData."Old Asset"
            $new = $compData."New Asset"
            $print = $compData."Printers"
            $data[$count] = @($old,$new,$print)
        }
    }

    return $data
}




function main {
    $location = Read-Host 'Enter number for your imaging station or type "Laptop"' 
    $compsData = compData -location $location
    $compsData[0]
    $compsData[1]
    $compsData[2]



    Read-Host "Press something to close"

}

main