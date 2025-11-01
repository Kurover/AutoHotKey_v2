#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Audio Manipulation on Taskbar
;=== Untested for long term performance

hotkeyTaskbarVolumeUp(*) {
    Send "{Volume_Up}"
}
hotkeyTaskbarVolumeDown(*) {
    Send "{Volume_Down}"
}

;=== Mouseover check
MouseIsOver(*) {
    MouseGetPos ,, &Win
    return WinExist("ahk_class Shell_TrayWnd ahk_id " Win)
}

;=== Trigger hotkey when mouse is on taskbar
HotIf MouseIsOver
Hotkey IniRead(settingsPath,"Hotkey","TaskbarVolumeUp"), hotkeyTaskbarVolumeUp
Hotkey IniRead(settingsPath,"Hotkey","TaskbarVolumeDown"), hotkeyTaskbarVolumeDown
HotIf
