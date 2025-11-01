#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Mute/Unmute Focused Program
;=== Works on anything, probably. You need to have nircmd for this to work

Hotkey IniRead(settingsPath,"Hotkey","ToggleProgramMute"), ToggleProgramMute
ToggleProgramMute(*)
{
	resourcesDir := rootDir "/Resources"
	varNircmd := rootDir "/" IniRead(settingsPath,"Path","nircmd")
	varMuteApp := WinGetProcessName("A") ;=== Get the exe name for nircmd
	Run varNircmd " muteappvolume " varMuteApp " 2",,"HIDE"
	SoundPlay resourcesDir "/Ding3.wav"
}