#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Pin to Top Window
;=== Works on anything

Hotkey IniRead(settingsPath,"Hotkey","TogglePinWindow"), hotkeyTogglePinWindow
hotkeyTogglePinWindow(*)
{
	WinSetAlwaysOnTop -1, "A"
	ExStyle := WinGetExStyle("A")
	If (ExStyle & 0x8) {
		SoundPlay rootDir "/Resources/Step1.wav"
		ToolTip "(つ✧ω✧)つ"
		SetTimer () => ToolTip(), -750
	}
	Else {
		SoundPlay rootDir "/Resources/Step1b.wav"
		ToolTip "ε===(≧ω≦)"
		SetTimer () => ToolTip(), -750
	}
}