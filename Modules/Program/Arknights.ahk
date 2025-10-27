#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;=== Arknights on emulator. Tested on MuMu, Gplay, and LDPlayer.
;=== You can rename "ahk_exe MuMuNxDevice.exe" to direct window title "Arknights" if you name your instance that. It might be active if other window has the same name though.
#HotIf WinActive("ahk_exe MuMuNxDevice.exe")
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
