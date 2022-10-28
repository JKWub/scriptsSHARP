$HP = "HP Universal Printing PCL 6 (v6.6.0)"
$MX = "SHARP UD2 PCL6"

rundll32 printui.dll,PrintUIEntry /dl /n "Microsoft XPS Document Writer"
rundll32 printui.dll,PrintUIEntry /dl /n "Fax"
#creating array to hold data for printers
$num = Read-Host "Please enter the number of printers. Press control-c to exit anytime"
$data = @(" ", " ") * $num
$count = 0
$z = $num
Write-Host ""


#populating array with user data
while ($z -gt 0){
    $j = $count + 1
    $name = Read-Host "#$j Enter printer name (all caps)"
    $driver = Read-Host "#$j Enter driver type (MX or HP)"
    Write-Host ""

    $data[$count] = @($name, $driver)


    $z -= 1
    $count += 1
    
}


#adding drivers in nonredundent way
$cond = @(" ", " ")
foreach ($print in $data) {
    if ($print[1] -eq "HP" -and $cond[1] -ne "HP"){
        Write-Host "HP driver found. Adding driver..."
        Add-PrinterDriver -Name $HP
        Write-Host "DONE"
        $cond[1] = "HP"
    }
    if ($print[1] -eq "MX" -and $cond[0] -ne "MX"){
        Write-Host "MX driver found. Adding driver..."
        Add-PrinterDriver -Name $MX
        $cond[0] = "MX"
        Write-Host "DONE"
    }
    Write-Host ""
}





#adding drivers and printers
foreach ($print in $data) {
    $print
    $driver = ""
    if ($print[1] -eq "HP"){
        $driver = $HP 
    }
    if ($print[1] -eq "MX"){
        $driver = $MX
    }
    if ($driver -eq ""){
        
    }else{
        Write-Host "Adding printer $print[0] with $print now..."
        Add-PrinterPort -Name $print[0] -PrinterHostAddress $print[0]
        Add-Printer -Name $print[0] -DriverName $driver -PortName $print[0]
        Write-Host "Done"
        Write-Host ""
    }
}


Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools\Print Management.lnk" -Wait

Read-Host "Done. Press enter to exit"