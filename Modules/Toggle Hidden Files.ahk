#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Toggle Hidden Files
;=== This toggle between system hidden files. Only active when you have explorer on focus
;=== Minecraft debug shortcut by pressing f3 combination to toggle things

HotIfWinActive "ahk_class CabinetWClass"
Hotkey IniRead(settingsPath,"Hotkey","ToggleHiddenFiles"), hotkeyToggleHidden
hotkeyToggleHidden(*)
{
	HiddenFiles_Status := RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden")
	If (HiddenFiles_Status = 0) {
		ToolTip "(◕‿◕)"
		SetTimer () => ToolTip(), -750
	}
	Else {
		ToolTip "Zzz.."
		SetTimer () => ToolTip(), -750
	}
	RegWrite !HiddenFiles_Status, "REG_DWORD", "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced", "Hidden"
	Send "{f5}"
	Return
}
HotIfWinActive