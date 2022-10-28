#lets validate some apps!


Read-Host "Welcome to the App Finder. The last time the Apps have been updated was 07/17/2022. Press enter to continue"

$compList = Import-Csv "U:\admin_localz\JamesK\AppScripts\AppCheckCSV\pcDataJuly19.csv"
$appList =  Import-Csv "U:\admin_localz\JamesK\AppScripts\AppCheckCSV\appDataHand.csv"



$count = 0
foreach ($compPair in $compList){
    $count++
    $newComp = $compPair.New
    Write-Host "#$count Checkin apps for $newComp.."
    $foundAppsNew = Get-WMIObject -Query "SELECT * FROM Win32_Product" -ComputerName $compPair.New 

    foreach ($app in $foundAppsNew.Name) {
        if ($app -eq $null){
        }else {
            foreach ($knownApp in $appList){
                    $result = $app.CompareTo($knownApp.name)
                    if ($result -eq 0){
                        Write-Output $knownApp.result    
                    }
                }
        }
    }
    write-host "`n"
    write-host "`n"
}

Read-Host "Press Enter to exit"