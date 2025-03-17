;;;;;;;;;;;;;;;;;;;;;;;;;; Original - Cursor Highlighter v. 2.2 https://www.autohotkey.com/boards/viewtopic.php?f=6&t=78701
;;;;;;;;;;;;;;;;;;;;;;;;;; Boisvert lab: https://sites.google.com/site/boisvertlab/computer-stuff/online-teaching
;;;;;;;;;;;;;;;;;;;;;;;;;; Stripped down for Picture mode only
;;;;;;;;;;;;;;;;;;;;;;;;;; Also has no tray icon, press Win+P to terminate or via task manager
#NoTrayIcon
#Requires AutoHotkey v1
#SingleInstance, force
#NoEnv
#Persistent
SetBatchLines -1
SetWinDelay, -1
SetMouseDelay, -1
ListLines Off
Coordmode, Mouse, Screen
SetWorkingDir %A_ScriptDir%
IniRead, hotkeyBigCursor, ../../settings.ini, Hotkey, ToggleBigCursor
Hotkey, %hotkeyBigCursor%, cursorExit

Install_Folder = %A_ScriptDir%
General_IniFile = %Install_Folder%\settings.ini
globalsFromIni(General_IniFile)

Gui, PresCursor: Margin, 0, 0
Gui, PresCursor: -caption +ToolWindow +AlwaysOnTop +E0x20 +LastFound
General_Picture_File_Gui := General_Picture_File
Gui, PresCursor: Add, Picture, x0 y0 w%General_Picture_Width% h%General_Picture_Height% vPointer_Icon, %General_Picture_File_Gui%
Gui, PresCursor: Show, x-9999 y-9999 NoActivate
hGui_Cursor := WinExist()
GoSub, Update_Cursor
SetTimer, CheckMouseMovement, 0
Return

Update_Cursor:
Coordmode, Mouse, Screen
MouseGetPos,CurrentX,CurrentY

Gui, PresCursor: Show, % "x" CurrentX-General_Picture_Width/2+General_Picture_XOffset "y" CurrentY-General_Picture_Height/2+General_Picture_YOffset " w" General_Picture_Width " h" General_Picture_Height "NoActivate"
Winset, Transparent, Off, ahk_id %hGui_Cursor%
Gui, PresCursor: Color, %General_Picture_Background%
GuiControl, PresCursor: Show, Pointer_Icon
WinSet, TransColor, %General_Picture_Background%, ahk_id %hGui_Cursor%
Winset, Region,, ahk_id %hGui_Cursor%
Sleep, 50
GuiControl, PresCursor: MoveDraw, Pointer_Icon, % " w" General_Picture_Width " h" General_Picture_Height
Return

CheckMouseMovement:
MouseGetPos,CurrentX,CurrentY
If General_Cursor_Type = 1
	Gui, PresCursor: Show, % "x" CurrentX-General_Cursor_Width/2 "y" CurrentY-General_Cursor_Height/2 " w" General_Cursor_Width " h" General_Cursor_Height " NoActivate"
If General_Cursor_Type = 2
	Gui, PresCursor: Show, % "x" CurrentX-General_Picture_Width/2+General_Picture_XOffset "y" CurrentY-General_Picture_Height/2+General_Picture_YOffset " w" General_Picture_Width " h" General_Picture_Height "NoActivate"
Winset, AlwaysOnTop, ON, ahk_id %hGui_Cursor%
Return

;----------------------------------------- Fast ini read
; Creates global variables from an Ini file.
; by Tuncay: http://www.autohotkey.com/board/topic/25515-globalsfromini-creates-globals-from-an-ini-file/
globalsFromIni(_SourcePath, _VarPrefixDelim = "_")
{
Global
Local FileContent, CurrentPrefix, CurrentVarName, CurrentVarContent, DelimPos
FileRead, FileContent, %_SourcePath%
If ErrorLevel = 0
	{
    Loop, Parse, FileContent, `n, `r%A_Tab%%A_Space%
		{
        If A_LoopField Is Not Space
			{
            If (SubStr(A_LoopField, 1, 1) = "[")
				{
                StringTrimLeft, CurrentPrefix, A_LoopField, 1
                StringTrimRight, CurrentPrefix, CurrentPrefix, 1
				}
			Else If (SubStr(A_LoopField, 1, 1) <> ";")
				{
                DelimPos := InStr(A_LoopField, "=")
                StringLeft, CurrentVarName, A_LoopField, % DelimPos - 1
                StringTrimLeft, CurrentVarContent, A_LoopField, %DelimPos%
                CurrentVarName = %CurrentVarName%
                %CurrentPrefix%%_VarPrefixDelim%%CurrentVarName% = %CurrentVarContent%
				}
			}
		}
	}
}

Return




cursorExit:
ExitApp