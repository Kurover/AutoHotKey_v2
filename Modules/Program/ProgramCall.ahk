#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;=== Call "= Executor.ahk". Standalone script since it has admin requirement
Hotkey IniRead(settingsPath,"Hotkey","RunExecutor"), hotkeyProgramExecutor
hotkeyProgramExecutor(*) {
	Run rootDir "/Modules/Program/= Executor.ahk"
}