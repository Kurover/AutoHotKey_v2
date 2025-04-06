#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Few example things we run that is more specific! Need mentioned apps if any

;=== DL YouTube with simple GUI and preset, it's bundled here but the yt-dlp does not
;= Win + Y
#y::Run "External\YouTubeDL-GUI\ydl.ahk"

;=== Run whatever is in clipboard, especially useful with links and you have-
;=== http/s hijacker like Browser Tamer to pass that link to some other program instead
;= R.Shift + Enter
>+Enter:: {
	Try
		Run A_Clipboard
}

;=== Paste image clipboard to image viewer
;= Ctrl + Alt + V
!^v:: {
	Run "C:\Program Files\XnViewMP\xnviewmp.exe -clipaste"
	WinWait("ahk_exe xnviewmp.exe")
	WinActivate
	Return
}