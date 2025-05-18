#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;=== Back button into escape. This is for Arknights lol
;=== Rename WinActive target or your emulator window name if it's different
;=== Great for global "back" button too in most apps
#HotIf WinActive("Arknights")
~XButton1:: Send "{Esc}"
~XButton2:: ; Click on operator to lock camera to them
{
  SetKeyDelay -1, -1
  SetControlDelay -1
  SetMouseDelay -1
  SetWinDelay -1
  Send "{LButton}"
  ControlClick "X10 Y45"
}
#HotIf
