#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;=== Title match, this will be active on ANY window title that has "minecraft" in it
;=== You can use "ahk_exe java.exe" instead if you don't use java for other thing
#HotIf WinActive("Minecraft")
XButton1::Send "{F5}"
XButton2:: {
	Loop {
		Send "{RButton}"
		If !GetKeyState("XButton2","P")
			Break
		Sleep 20
	}
}
#HotIf
