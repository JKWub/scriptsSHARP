Import-Module ImportExcel
Import-Module ActiveDirectory

Remove-Printer -name "Microsoft XPS Document Writer" -ComputerName "IS2215772"



Read-Host "Press Enter to exit"