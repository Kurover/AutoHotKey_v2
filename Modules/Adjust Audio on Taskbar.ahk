#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Audio Manipulation on Taskbar
;=== This script is straight out of the docs, convenient!
;=== Great for those who don't have media keys on their keyboard

#HotIf MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send "{Volume_Up}"
WheelDown::Send "{Volume_Down}"
#HotIf

;=== Mouseover check
;=== This one doesn't work with "Hotkey" command and we couldn't be bothered to figure nor fix that
MouseIsOver(WinTitle) {
    MouseGetPos ,, &Win
    return WinExist(WinTitle " ahk_id " Win)
}