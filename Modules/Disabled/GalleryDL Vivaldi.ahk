#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Vivaldi Remap. It will run one of the function from `GalleryDL.ahk`.

;= Restart the browser. Win + Backspace
#HotIf WinActive("ahk_exe vivaldi.exe")
#Backspace UP:: {
	varOriginalClipboard := A_Clipboard
	A_Clipboard := "vivaldi://restart"
	Sleep 25
	Send "{F8}"
	Sleep 100
	Send "^v"
	Sleep 10
	Send "{Enter}"
	A_Clipboard := varOriginalClipboard
}

;= Run a function when the cursor is a pointer
#HotIf WinActive("ahk_exe vivaldi.exe") and (A_Cursor = "Unknown")
XButton2:: hotkeyGalleryDLRunAuto()

#HotIf
