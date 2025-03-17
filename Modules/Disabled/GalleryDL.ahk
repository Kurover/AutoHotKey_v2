#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Gallery-DL Automation
;=== You need Gallery-DL and its path configured in order for this to work. See G/YT-DL NGs for more info

;=== Browser groups for calls. Add your own browser here
GroupAdd "browser", "ahk_exe firefox.exe"
GroupAdd "browser", "ahk_exe chrome.exe"
GroupAdd "browser", "ahk_exe vivaldi.exe"
GroupAdd "browser_fox", "ahk_exe firefox.exe"
GroupAdd "browser_chrome", "ahk_exe chrome.exe"
GroupAdd "browser_chrome", "ahk_exe vivaldi.exe"

;=== Run gallery-dl, downloading link on clipboard
;=== If link is youtube or facebook, use yt-dlp interactive mode (-f -)
varAcceptYTDL := IniRead(settingsPath,"Filter","YTDL")
Hotkey IniRead(settingsPath,"Hotkey","GalleryDLRun"), hotkeyGalleryDLRun
hotkeyGalleryDLRun(*) {
	If (A_Clipboard ~= "i)(" varAcceptYTDL ")") { ;=== Check if YTDL compatible
		Run A_Comspec " /c yt-dlp -f - " . A_Clipboard
		Return
	}
	Run A_Comspec " /c gallery-dl " . A_Clipboard,,"Min"
}

;=== Invoke right click context menu on cursor and tries to copy link and download it
HotIfWinActive "ahk_group browser"
Hotkey IniRead(settingsPath,"Hotkey","GalleryDLRunAuto"), hotkeyGalleryDLRunAuto
HotIfWinActive
hotkeyGalleryDLRunAuto(*) {
	A_Clipboard := "" ;=== Empties clipboard for checks later

	Send "{RButton}"
	Sleep "350"
	If WinActive("ahk_group browser_chrome")
		Send "c"
	If WinActive("ahk_group browser_fox")
		Send "l"
	Sleep "250"
	If A_Clipboard != "" { ;=== Check clipboard if a link is received
		If (A_Clipboard ~= "i)(" varAcceptYTDL ")") {
			Run A_Comspec " /c yt-dlp -f - " . A_Clipboard
			Return
		}
		Run "cmd /c gallery-dl " A_Clipboard,,"Min"
	}
}