#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Open Directory of Focused Program
;=== Don't you hate it when you want to open something this certain program save, but They saved it in their own directory?
;=== Or there's this stupid program that's stored in the depths of AppData?
;=== Hate no more!

Hotkey IniRead(settingsPath,"Hotkey","OpenProgramDir"), hotkeyOpenProgramDir
hotkeyOpenProgramDir(*) {
	varProcPath := WinGetProcessPath("A") ; Get active window name
	varDir := RegexReplace(varProcPath, "(?!.*\\)\N+") ; "(?!.*\\)" to determine last slash and start on next character, by using positive lookahead. "\N+" to select all line after so we select the process name to delete.
	Run varDir ; We breach the wall
}
