Import-Module ImportExcel
Import-Module ActiveDirectory
$P = Import-Excel ".\pc_laptop2022.xlsx" 
$appList =  Import-Csv ".\appDataHand.csv"

cls
$location = Read-Host "Welcome to the AD copier. Enter number for your imaging station"


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


function getBitStatus {
    param (
        $CompterName
    )

    $status = manage-bde -status -cn $CompterName
    $p = $status.split("`r`n") 
    $p[13]
    
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


function main {
    #$P."Warehouse Location"
    $locString = "Imaging Station #$location"
    $count = 1
    foreach ($compData in $P){
        if ($compData."Warehouse Location" -eq $locString){
            $old = $compData."Old Asset"
            $new = $compData."New Asset"
            $SRC = Get-ADComputer -Identity $compData."Old Asset" -Properties MemberOf
            $DST = Get-ADComputer -Identity $compData."New Asset" -Properties MemberOf
            $SRCGroups = CleanADGroups -ComputerName $compData."Old Asset"
            $DSTGroups = CleanADGroups -ComputerName $compData."New Asset"

            Write-Output ""
            Write-Output ""
            Write-Output "____________ #$count - Data for $old/$new ____________"
            Write-Output ""
    
           
            Write-Output "#$count copying computers $Source/$Destination"
            $zcount = 0
            foreach ($ComputerGroup in $SRC.memberOf) {
                if($DST.MemberOf -notcontains $ComputerGroup) {
                    $onNum = $zcount + 1
                    $groupz = $SRCGroups[$zcount]
                    Write-Output "Copying Group #$onNum -- $groupz"
                    Add-ADGroupMember -Identity $ComputerGroup -Members $DST
                    $zcount++ 
                }
            }

            
            $count++
        }
    }
    Write-Output "Done Validating... $count number of PC's found. Will refresh in 5 mins"
}


$timer = new-timespan -Minutes 1
$clock = [diagnostics.stopwatch]::StartNew()
while ($clock.elapsed -lt $timer){
    cls
    main
    start-sleep -seconds 30000
}
