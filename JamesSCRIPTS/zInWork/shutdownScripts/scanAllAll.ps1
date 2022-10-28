 
 
 start-Process -FilePath "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Ivanti Management\Security Scan (ALL).lnk"
 sleep 5
 $w = New-Object -ComObject wscript.shell;
 $w.AppActivate('EPM Patch Prompter')
 sleep 1
 $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
  $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
  $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
  $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
  $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
 $w.SendKeys('{tab}')
 $w.SendKeys('{enter}')

 