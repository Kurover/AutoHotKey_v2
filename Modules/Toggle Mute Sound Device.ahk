#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Toggle Audio Mute
;=== Device muting 101
;=== Complex device might have more channels in the audio device "levels" tab
;=== These have their own config so do ask us if you need help. Alternatively check ahk docs

;=== Variables, change in settings.ini
;=== Check your device name in audio device "mmsys.cpl"
varMicrophone := IniRead(settingsPath,"SoundDevice","MicrophoneName")
varSpeaker := IniRead(settingsPath,"SoundDevice","SpeakerName")
resourcesDir := rootDir "/Resources"

;=== Mute Microphone
Hotkey IniRead(settingsPath,"Hotkey","ToggleMicrophone"), hotkeyToggleMicrophone
hotkeyToggleMicrophone(*)
{
	SoundSetMute -1,,varMicrophone
	If SoundGetMute(, varMicrophone) {
		SoundPlay resourcesDir "/Deactivate.wav"
		ToolTip "(￣x￣) •••"
		SetTimer () => ToolTip(), -750 ;=== Kill tooltip after .75s
		}
	Else {
		SoundPlay resourcesDir "/Activate.wav"
		ToolTip "(￣▽￣)/♫•*¨*•.¸¸♪"
		SetTimer () => ToolTip(), -750
		}
	}
	
;=== Mute Speaker
Hotkey IniRead(settingsPath,"Hotkey","ToggleSpeaker"), hotkeyToggleSpeaker
hotkeyToggleSpeaker(*)
{
	If SoundGetMute(, varSpeaker) = 0 {
		SoundPlay resourcesDir "/Step3.wav"
		Sleep 50
		SoundSetMute -1,,varSpeaker
		ToolTip "(╥﹏╥)"
		SetTimer () => ToolTip(), -750 ;=== Kill tooltip after .75s
	}
	Else {
		SoundSetMute -1,,varSpeaker
		Sleep 100
		SoundPlay resourcesDir "/Ding2.wav"
		ToolTip "＼(＾▽＾)／"
		SetTimer () => ToolTip(), -750
	}
}

;=== These 2 function above are identical and we can combine it into 1 function
;=== But those can get overwhelming for newcomer in this module section so we opt that out 