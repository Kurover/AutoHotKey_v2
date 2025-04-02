#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Mute/Unmute Focused Program
;=== Works on anything, probably

; varNircmd := "/External/nircmdc.exe" Not needed, already in .core
varNircmd := "../External/nircmd/nircmdc.exe" ;compileremoveme
resourcesDir := rootDir "/Resources"

Hotkey IniRead(settingsPath,"Hotkey","ToggleProgramMute"), ToggleProgramMute
ToggleProgramMute(*)
{
	varMuteApp := WinGetProcessName("A") ;=== Get the exe name for nircmd
	Run varNircmd " muteappvolume " varMuteApp " 2",,"HIDE"
	SoundPlay resourcesDir "/Ding3.wav"
}