#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;=== Back button into escape. This is for Arknights lol
;=== Great for global "back" button too in most apps
#HotIf WinActive("ahk_exe dnplayer.exe")
~XButton1:: Send "{Esc}"