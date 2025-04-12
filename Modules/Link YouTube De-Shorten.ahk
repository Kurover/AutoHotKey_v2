#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Youtube shorts unshorten

Hotkey IniRead(settingsPath,"Hotkey","YoutubeUnShorten"), hotkeyYoutubeUnShorten
hotkeyYoutubeUnShorten(*) {
	If !(A_Clipboard ~= "youtube.com/shorts") {
		ToolTip "Clipboard has no YT shorts link!"
		SetTimer () => ToolTip(), -1250 ;=== Kill tooltip after 1.25s
		Return
	}	
	varLinkClean := StrReplace(A_Clipboard, "?feature=share") ; Remove tracking link ("?feature=share")
	varLinkClean := StrReplace(varLinkClean, "shorts/", "watch?v=") ; Remove tracking link ("?feature=share")
	A_Clipboard := varLinkClean
	ToolTip 'Clipboard is now "' varLinkClean '"!'
	SetTimer () => ToolTip(), -2500
}