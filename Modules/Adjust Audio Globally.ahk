#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Audio Manipulation Key
;=== This is redundant for keyboard with media keys

Hotkey IniRead(settingsPath,"Hotkey","AdjustVolumeUp"), hotkeyAdjustVolumeUp
Hotkey IniRead(settingsPath,"Hotkey","AdjustVolumeDown"), hotkeyAdjustVolumeDown
Hotkey IniRead(settingsPath,"Hotkey","AdjustVolumeMute"), hotkeyAdjustVolumeMute
hotkeyAdjustVolumeUp(*) {
	SendEvent "{Volume_Up}"
}
hotkeyAdjustVolumeDown(*) {
	SendEvent "{Volume_Down}"
}
hotkeyAdjustVolumeMute(*) {
	SendEvent "{Volume_Mute}"
}