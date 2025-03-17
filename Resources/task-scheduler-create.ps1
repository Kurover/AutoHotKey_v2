if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$ahkPath = cmd /c "where Run-Gadget-Elevated.ahk"
$delay = new-timespan -seconds 5
$taskName = "AHK Gadget Elevated"
$description = "Run AutoHotKey script with elevation to allow hotkeys to be run on top of another focused program that has the same level"
$action = New-ScheduledTaskAction -Execute $ahkPath
$trigger = New-ScheduledTaskTrigger -AtLogon
$trigger.delay = 'PT5S'
$principal = New-ScheduledTaskPrincipal -UserID "$env:USERDOMAIN\$env:USERNAME" -LogonType ServiceAccount -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -DontStopIfGoingOnBatteries -AllowStartIfOnBatteries -ExecutionTimeLimit 0
Register-ScheduledTask -TaskName $taskName -Description $description -Principal $principal -Action $action -Trigger $trigger -Settings $settings
echo ""
echo "If you don't see red text that mean we are gucchi"
echo "Otherwise you gotta do it the manual way... refer to our docs"
echo "Unless you run this .ps1 standalone. Which wouldn't work"
Timeout -1