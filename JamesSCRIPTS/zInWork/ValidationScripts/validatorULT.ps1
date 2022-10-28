Import-Module ActiveDirectory
$P = Import-Csv ".\pcJuly20.csv"
$appList =  Import-Csv ".\appDataHand.csv"



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


#checks known apps from CSV against those found from Get-WMIObject
function appValidator {
    
    param (
        $ComputerName

    )
    Write-Output "-- Install apps for $ComputerName --"
    $foundAppsNew = Get-WMIObject -Query "SELECT * FROM Win32_Product" -ComputerName $ComputerName
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

}


$answer = Read-Host "Welcome to the Config Validator. Enter y/n for validating printers (validating printers can add ~2 mins for each PC) "

foreach ($compData in $P) {
    $old = $compData."Old Asset"
    $new = $compData."New Asset"
    $SRC = Get-ADComputer -Identity $compData."Old Asset" -Properties MemberOf
    $DST = Get-ADComputer -Identity $compData."New Asset" -Properties MemberOf
    $SRCGroups = CleanADGroups -ComputerName $compData."Old Asset"
    $DSTGroups = CleanADGroups -ComputerName $compData."New Asset"
    
    
    Write-Output ""
    Write-Output ""
    Write-Output "____________ Data for $old/$new ____________"
    Write-Output ""
    
    if ($answer -eq "y"){
        $DSTPrinters = Get-Printer -ComputerName $new
        Write-Output "Printers for $new :"
        $DSTPrinters.name
    }

    $bigCount = $SRCGroups.count
    if ($bigCount -lt $DSTGroups.count){
        $bigCount = $DSTGroups.count
    }
    
    Write-Output ""
    Write-Output "Groups for $old/$new"
    for ($i = 0; $i -lt $bigCount; $i++){
        if ( ($DSTGroups.count -gt 0) -and ($DSTGroups[$i].count -gt 0) ){
            $newGroup = $DSTGroups[$i]
        }else {
            $newGroup = "EMPTY"
        } 
        $oldGroup = $SRCGroups[$i]
        Write-Output "OLD: $oldGroup ~~~~~ $newGroup : NEW"
    }

    Write-Output ""
    $apps = appValidator -ComputerName $new
    $apps

}

Write-Host ""
Write-Host ""
Read-Host "Validator Done. Press Enter to EXIT"