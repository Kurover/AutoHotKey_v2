#Requires AutoHotkey v2
SetWorkingDir A_ScriptDir

MsgBox "What the- Hey, please read the readme, you.", "Huhh??"
MsgBox "But...", ".,o*thinking*o,."
MsgBox "..Since you're cute, I'll let it pass.", "Fine"
choic := MsgBox("I'll even help you on the next step if you can promise me something~", "Trade offer", "YesNo")
If (choic = "No")
	{
	MsgBox "Hmph.", "I see"
	varTarget := A_ScriptFullPath
	FileDelete varTarget
	FileAppend "
	(
	#Requires AutoHotkey v2
	SetWorkingDir A_ScriptDir
	
	MsgBox "Go read.", "..."
	)", varTarget
	}
Else
	{
	MsgBox "Just kidding, I'll run the compiler script for ya. Do read the readme though.", "Initializing"
	Run "Compile.ahk"
	}