#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Windows Application Hotkey
;=== Remove WinGetPos and WinMove if you don't want to center it to screen

;=== Run Audio Mixer, and if window already exist-
;=== Press again to open audio properties
Hotkey IniRead(settingsPath,"Hotkey","RunAudioMixer"), hotkeyRunAudioMixer
hotkeyRunAudioMixer(*)
{
	If WinExist("ahk_exe rundll32.exe")
		Return
	If WinExist("ahk_exe SndVol.exe") {
		Run "mmsys.cpl"
		WinWait("ahk_exe rundll32.exe",, 5)
		WinActivate
		WinGetPos ,, &Width, &Height
		WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
		Return
		}
	Run "SndVol.exe"
	WinWait("ahk_exe SndVol.exe",, 5)
	WinActivate
	WinGetPos ,, &Width, &Height
    WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}
; === Run Calculator, and if window already exist-
;=== Press again to open notepad. Sometimes you need it (if you use windows calc)
Hotkey IniRead(settingsPath,"Hotkey","RunCalculator"), hotkeyRunCalculator
hotkeyRunCalculator(*)
{
	If WinExist("Calculator") {
		Run "notepad.exe"
		Return
	}
	Run "calc.exe"
	WinWait("Calculator")
	WinActivate
	WinGetPos ,, &Width, &Height
    WinMove (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
}
