#lets validate some apps!

Write-Output ""
$comp = Read-Host "Welcome to the App Finder. The last time the Apps have been updated was 07/17/2022. Please enter asset"
$foundApps = Get-WMIObject -Query "SELECT * FROM Win32_Product" -ComputerName $comp


$appList =  Import-Csv "\\shcsd\sharp\soc\groups\ISD Common\JamesSCRIPTS\AppScripts\AppCheckCSV\appDataHand.csv"


$count = 0
foreach ($app in $foundApps.Name) {
    if ($app -eq $null){
        Write-Output ""
    }else {
        foreach ($knownApp in $appList){
                $result = $app.CompareTo($knownApp.name)
                if ($result -eq 0){
                    Write-Output $knownApp.result    
                }
            }
    }
}