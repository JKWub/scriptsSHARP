Scripts labeled with CSV at end of name use CSV docs with IS info. The file paths are at the top and may need to be changed as I'm copying these over from U: drive. 
ValidattionScripts are the most recent scripts that are probably the most orginized. 

Everything is a little scattered as I wrote these things as I am configing.

PowerShell Commands I would like access to:
Get-BitLockerVolume --- to check bitlocker completion remotly
Get-WMIObject --- This one is a little tricky. I have access for assets that are new and freshly imaged at SOC. I do not have access to assets that are old and not in SOC.



Most of these scripts use the ActiveDirectory module in Powershell. This requires and optional feature to be added to windows. 
Seach in windows "Manage optional features" -> Add a feature -> RSAT: Remote Access Management Tools

Or just install with:
link: https://www.microsoft.com/en-us/download/details.aspx?id=45520


