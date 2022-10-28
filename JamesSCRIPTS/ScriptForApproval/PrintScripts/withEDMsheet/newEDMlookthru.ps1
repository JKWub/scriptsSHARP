$P = Import-CSV "C:\Users\keyja1\OneDrive - Sharp HealthCare\Desktop\AddPrintEDM\edm0801.csv"
rundll32 printui.dll,PrintUIEntry /dl /n "Microsoft XPS Document Writer"
rundll32 printui.dll,PrintUIEntry /dl /n "Fax"



$HP = "HP Universal Printing PCL 6 (v6.6.0)"
$MX = "SHARP UD2 PCL6"

$addPrint = ""

while ($addPrint -ne "n") {
    Write-Host ""
    Write-Host ""
    $addPrint = Read-Host "Please enter a printer name or enter 'n' to exit to Print mgmnt"
    foreach ($print in $P) {
        if ($print.name -eq $addPrint) {
            Write-Output "Printer Found!"
            $type = $print.Type
            $name = $print.Name
            $driver = ""
            if ($print.Type.Contains("HP")) {
                Read-Host "HP drive found for $name with $type. Press enter if correct or Crt-C to cancel"
                $driver = "HP"
            }elseif ($print.Type.Contains("MX")) {
                Read-Host "MX drive found for $name with $type. Press enter if correct or Crt-C to cancel"
                $driver = "MX"
            }elseif ($print.Type.Contains("CL")) {
                Read-Host "A citzizen driver was found for $name with $type. This must be added manually... Press Enter"
        
            }else {
                Read-Host "No driver type found for $name with $type. Press Enter"        
            }

            if ($driver -eq 'HP') {
                Write-Host ("Adding HP port for printer #"+$i)
                Add-PrinterDriver -Name $HP
                $driver = $HP
            }elseif ($driver -eq 'MX') {
                Write-Host 'Adding Sharp port'
                Add-PrinterDriver -Name $MX
                $driver = $MX
            }else {
                Write-Host "No Driver Entered"
            } 
            Write-Host "Driver added. Now adding printer port for $name"
            Add-PrinterPort -Name $name -PrinterHostAddress $name
            Add-Printer -Name $name -DriverName $driver -PortName $name
            Write-Host "$name DONE"

        }
    }


}


Start-Process "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools\Print Management.lnk" -Wait