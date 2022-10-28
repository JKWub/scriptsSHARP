Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

function getBitStatus {
    param (
        $CompterName
    )

    $status = manage-bde -status -cn $CompterName
    $p = $status.split("`r`n") 
    $p[13]
    
}


getBitStatus -CompterName "IS2129617"
Read-Host "SHITENKFQEK"
