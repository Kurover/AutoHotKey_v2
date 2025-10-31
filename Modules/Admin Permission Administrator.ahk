#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Admin Permission Administrator
;=== Force program to run NOT as admin, does it REALLY need to have a grubby hand to the system? Check it out yourself.
;=== The admin selection is pretty much the same as the one in compatibility assistant!

;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

GUIAPA()
{
	varRegPathAPA := "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
	varKeyAdmin := "RunAsAdmin"
	varKeyUnAdmin := "RunAsInvoker"
	
	APAGui := Gui()
	APAGui.Opt("-MinimizeBox -MaximizeBox +AlwaysOnTop")
	APAGui.Title := "Admin Permission Administrator (APA)"
	APATextStatus := APAGui.Add("Text", "x266 y8 w87 h21 +Border +Center +0x200", "Zzz")
	Edit1 := APAGui.Add("Edit", "x8 y8 w252 h21", "Program full path (clipboard is monitored)")
	Radio1 := APAGui.AddRadio("x10 y32 w108 h23", "Run as Admin")
	Radio2 := APAGui.AddRadio("x120 y32 w108 h23 Checked", "Run un-elevated")
	APASelection := "RunAsInvoker"
	ButtonApply := APAGui.Add("Button", "x216 y56 w137 h31 Disabled", "Apply")
	ButtonCopyRegPath := APAGui.Add("Button", "x8 y56 w100 h31", "Copy Reg Path")
	ButtonCheckData := APAGui.Add("Button", "x266 y32 w87 h23 Disabled", "Check Data")
	ButtonRemoveRegistry := APAGui.Add("Button", "x112 y56 w100 h31 Disabled", "Remove Registry")
	
	;= Events
	Edit1.OnEvent("Change", UpdateAPAStatus)
	ButtonApply.OnEvent("Click", ApplyRegValue)
	ButtonCheckData.OnEvent("Click", CheckRegData)
	ButtonRemoveRegistry.OnEvent("Click", RemoveRegData)
	ButtonCopyRegPath.OnEvent("Click", CopyRegeditPath)
	
	APAGui.OnEvent('Escape', APAGui_close)
	APAGui.OnEvent('Close', APAGui_close)
	APAGui_close(thisgui) {
		OnClipboardChange CheckClipboardAPA, 0
		ChangeGUIState()
		APAGui.Destroy
	}
	
	;= Make sure the window can be called again
	ChangeGUIState(*){
		Global
		ProgramAPA := 0
	}
	
	;= Clipboard Listener
	OnClipboardChange CheckClipboardAPA
	CheckClipboardAPA(*) {
		Edit1.Value := A_Clipboard
		UpdateAPAStatus()
	}
	
	;= Check if key exist
	UpdateAPAStatus(*) {
		Try
			varRegValue := RegRead(varRegPathAPA, Edit1.Value, 0)
		If (A_LastError = 5) {
			MsgBox "You have no permission to do this actually :(", "Uh oh..", 0x1000
			ButtonApply.Opt("Disabled")
			Edit1.Opt("Disabled")
			OnClipboardChange CheckClipboardAPA, 0
			APATextStatus.Text := ":<"
			Return
		}
		If (varRegValue = 0) {
			APATextStatus.Text := "No Match!"
			ButtonApply.Opt("-Disabled")
			ButtonCheckData.Opt("Disabled")
			ButtonRemoveRegistry.Opt("Disabled")
		}
		Else {
			APATextStatus.Text := "Key Exist"
			ButtonApply.Opt("-Disabled")
			ButtonCheckData.Opt("-Disabled")
			ButtonRemoveRegistry.Opt("-Disabled")
		}
	}
	CheckRegData(*) {
		MsgBox RegRead(varRegPathAPA, Edit1.Value, 0), "Value", 0x1000
	}
	
	;= Add/Edit Registry
	ApplyRegValue(*) {
		;= Check the radio selection option
		varEditValue := Edit1.Value
		If Radio1.Value = 1
			APASelection := varKeyAdmin
		Else
			APASelection := varKeyUnAdmin
		
		APAGui.Opt("Disabled")
		ResultAddReg := MsgBox("Are you sure? This will also replace existing value if any (usually config from compatibility assistant).", "Registry is scawwy~!", 0x1001)
		If (ResultAddReg = "OK") {
			RegWrite APASelection, "REG_SZ", varRegPathAPA, varEditValue
			APAGui.Opt("-Disabled")
			}
		Else {
			APAGui.Opt("-Disabled")
			Return
			}
		UpdateAPAStatus()
		APATextStatus.Text := "Added!"
		
	}
	
	;= Remove Registry
	RemoveRegData(*) {
		varEditValue := Edit1.Value
		APAGui.Opt("Disabled")
		ResultRemoveReg := MsgBox("Confirm deletion.", "THIS IS IRREVERSIBLE", 0x1031)
		If (ResultRemoveReg = "OK") {
			RegDelete varRegPathAPA, varEditValue
			APAGui.Opt("-Disabled")
		}
		Else {
			APAGui.Opt("-Disabled")
			Return
		}
		UpdateAPAStatus()
		APATextStatus.Text := "ERASED~"
	}
	
	CopyRegeditPath(*) {
		OnClipboardChange checkClipboardAPA, 0
		A_Clipboard := varRegPathAPA
		APATextStatus.Text := "Copied!"
		OnClipboardChange checkClipboardAPA, 1
	}

	Return APAGui
}

;= Function to prevent duplicate window when hotkey is pressed
programAPA := 0

Hotkey IniRead(settingsPath,"Hotkey","AdminPermission"), hotkeyProgramAPA
hotkeyProgramAPA(*) {
	Global
	If (programAPA != 0) {
		programAPA.Show("Restore")
		Return
	}
	programAPA := GUIAPA()
	programAPA.Show("w360 h96")
}
