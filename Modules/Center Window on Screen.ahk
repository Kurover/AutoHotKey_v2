#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Center Active Window on Screen
;=== Great for your OCD needs

Hotkey IniRead(settingsPath,"Hotkey","CenterWindow"), hotkeyCenterWindow
hotkeyCenterWindow(*) {
	varActive := WinExist("A")
	WinActivate(varActive)
	WinGetPos ,, &Width, &Height
    WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}