#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Cursor Pointer
;=== NOTE if you're changing the default hotkey in settings
;=== Make sure you edit External/CursorPointer/ngs-pointer.ahk
;=== On the very bottom

varCursorPath := rootDir "/External/CursorPointer/ngs-pointer.ahk"

;=== Toggle on/off. For settings, go to script directory in the External folder
;=== Win + P, the script has same hotkey to terminate itself (which overrides this one)
Hotkey IniRead(settingsPath,"Hotkey","ToggleBigCursor"), hotkeyToggleBigCursor
hotkeyToggleBigCursor(*) {
	Run varCursorPath,,"Hide"
}
