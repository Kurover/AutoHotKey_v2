#Requires Autohotkey v2
#SingleInstance Force
#NoTrayIcon

;===============
;=== Module: .Executor
;=== Force program to run NOT as admin, does it REALLY need to have a grubby hand to the system? Check it out yourself.
;=== If that's not enough, ban that thing to the legacy shadow realm.
;=== Regkey from https://superuser.com/a/1122799 and https://superuser.com/a/721307

;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

myGui := Constructor()
myGui.Show("w281 h351")

Constructor()
{	
	;=== Variables
	hasCheckPermission := 0
	varRegPathPerm := "HKCU\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
	varRegPathBlock := "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options"
	varKeyDataAdmin := "RunAsAdmin"
	varKeyDataUnAdmin := "RunAsInvoker"
	varKeyNameBlock := "Debugger"
	varKeyDataBlock := "systray.exe"
	
	;= Var checks
	isPermissionPossible := 1
	isBlockingPossible := 1
	varRegValuePerm := 0
	varRegValueBlock := 0
	varPathExeName := "TestAHK123.exe"
	
	myGui := Gui()
	myGui.Opt("-MinimizeBox -MaximizeBox +AlwaysOnTop")
	myGui.Title := ".Executor"
	;======
	;= Path box, first so auto focus on edit box
	statusText := myGui.Add("Text", "x16 y264 w249 h21 +Border +Center +0x200", "~ W E L C O M E ~")
	editPath := myGui.Add("Edit", "x16 y287 w249 h21", "Full path to program | CTRL+C the file")
	;======
	;= Permission
	myGui.Add("GroupBox", "x16 y10 w249 h144", "Admin Permission")
	checkPerm1 := myGui.Add("CheckBox", "x111 y33 w127 h23 +Disabled", "Run as Administrator")
	checkPerm2 := myGui.Add("CheckBox", "x111 y57 w147 h23 Checked +Disabled", "Run as NON Administrator")
	btnRun1 := myGui.Add("Button", "x23 y34 w82 h35 +Disabled", "Apply")
	btnRestore1 := myGui.Add("Button", "x23 y72 w82 h35 +Disabled", "Remove Key")
	editVal1 := myGui.Add("Edit", "x24 y117 w233 h21 +ReadOnly", "Status | Key Value")
	btnHelp1 := myGui.Add("Button", "x242 y16 w23 h23", "?")
	;======
	;= Blocker
	myGui.Add("GroupBox", "x16 y163 w249 h95", "Blocker")
	btnRun2 := myGui.Add("Button", "x23 y183 w82 h35 +Disabled", "Block")
	btnRestore2 := myGui.Add("Button", "x108 y183 w81 h35 +Disabled", "Remove Key")
	editVal2 := myGui.Add("Edit", "x24 y222 w233 h21 +ReadOnly", "Status | Key Value")
	btnHelp2 := myGui.Add("Button", "x242 y169 w23 h23", "?")
	;======
	;= Misc
	myGui.Add("Text", "x137 y310 w32 h23 +0x200", "Path:")
	btnElevate := myGui.Add("Button", "x15 y310 w96 h23", "Restart as Admin")
	btnPath1 := myGui.Add("Button", "x169 y310 w48 h23", "Perm")
	btnPath2 := myGui.Add("Button", "x217 y310 w48 h23", "Block")
	;======
	
	;=== Window/GUI Event
	myGui.OnEvent('Escape', myGui_close)
	myGui.OnEvent('Close', myGui_close)
	myGui_close(thisgui) {
		OnClipboardChange checkClipboard, 0
		myGui.Destroy
	}
	;= Drag n Drop Event
	myGui.OnEvent('DropFiles', Gui_DropFiles)
	Gui_DropFiles(GuiObj, GuiCtrlObj, FileArray, X, Y) {
		editPath.Value := FileArray[1]
		editBoxUpdate()
	}
	;=== Init. Event
	;= Clipboard Listener
	OnClipboardChange checkClipboard
	checkClipboard(*) {
		editPath.Value := A_Clipboard
		editBoxUpdate()
	}
	If A_IsAdmin {
		btnElevate.Opt("Disabled")
		btnElevate.Text := "Full Access"
	}
	;= Permission checker, disable feature if fail
	checkPermissionPossible()
	checkPermissionPossible(*) {
		;@ Perm
		Try {
			varRegValue := RegRead(varRegPathPerm, "TestKeyAHK", 0)
			Try
				RegWrite "1", "REG_SZ", varRegPathPerm, "TestKeyAHK"
			If (A_LastError = 5) {
				isPermissionPossible := 0
				editVal1.Text := "No WRITE permission :c"
				disableGroup1()
				Return
			}
			RegDelete varRegPathPerm, "TestKeyAHK"
		}
		If (A_LastError = 5) {
			isPermissionPossible := 0
			editVal1.Text := "Can't even READ the keys :c"
			disableGroup1()
			Return
		}
		;@ Block
		Try {
			varKeyPath := varRegPathBlock "\" varPathExeName
			Try
				RegWrite "1", "REG_SZ", varKeyPath, "TestKeyAHK"
			If (A_LastError = 5) {
				isBlockingPossible := 0
				editVal2.Text := "No WRITE permission :c | Run as admin plz"
				disableGroup1()
				Return
			}
			RegDeleteKey varKeyPath
		}
		If (A_LastError = 5) {
			isPermissionPossible := 0
			editVal1.Text := "Can't even READ the keys :c"
			disableGroup1()
			Return
		}
	}
	;=== Events
	;= Edit box changes
	editPath.OnEvent("Change", editBoxUpdate)
	editBoxUpdate(*) {
		If (editPath.Value ~= "\.exe") {
			statusText.Text := "A-O.K!"
		}
		Else {
			statusText.Text := "Please select an executable file!"
			If !(isPermissionPossible = 0) {
				editVal1.Text := "-"
				disableGroup1()
			}
			If !(isBlockingPossible = 0) {
				editVal2.Text := "-"
				disableGroup2()
			}
			Return
		}
		updateStatusMain()
	}
	
	;= Refresh GUI state. Uses delay via SetTimer to prevent RegRead spam
	updateStatusMain(*) {
		SetTimer updateStatus1, 0
		SetTimer updateStatus2, 0
		SetTimer updateStatus1, 250
		SetTimer updateStatus2, 250
	}
	;@ STATUS 1
	updateStatus1(*) {
		Try
			SetTimer updateStatus1, 0
		If (isPermissionPossible = 0) ; skip this function if no permission (wow confusing!)
			Return
		
		;@ Check
		varRegValuePerm := RegRead(varRegPathPerm, editPath.Value, 0)
		If (varRegValuePerm = 0) {
			editVal1.Text := "No matching full path!"
			btnRun1.Opt("-Disabled")
			btnRestore1.Opt("+Disabled")
		}
		Else {
			editVal1.Text := "*path\*.exe: " varRegValuePerm
			btnRun1.Opt("-Disabled")
			btnRestore1.Opt("-Disabled")
		}
		
		checkPerm1.Opt("-Disabled")
		checkPerm2.Opt("-Disabled")
	}
	enableGroup1(*) {
		btnRun1.Opt("-Disabled")
		btnRestore1.Opt("-Disabled")
		checkPerm1.Opt("-Disabled")
		checkPerm2.Opt("-Disabled")
	}
	disableGroup1(*) {
		btnRun1.Opt("+Disabled")
		btnRestore1.Opt("+Disabled")
		checkPerm1.Opt("+Disabled")
		checkPerm2.Opt("+Disabled")
	}
	
	;@ STATUS 2
	updateStatus2() {
		Try
			SetTimer updateStatus2, 0
		If (isBlockingPossible = 0) ; skip this function if no permission
			Return
		
		;@ Check
		varEditValue := editPath.Value
		varEditValue := StrReplace(varEditValue, "`/", "`\")
		Loop parse, varEditValue, "\" {
			If (A_LoopField ~= "\.exe")
				varPathExeName := A_LoopField
		}
		varRegValueBlock := RegRead(varRegPathBlock "\" varPathExeName, "Debugger", 0)
		If (varRegValueBlock = 0) {
			editVal2.Text := "No matching .exe"
			btnRun2.Opt("-Disabled")
			btnRestore2.Opt("+Disabled")
		}
		Else {
			editVal2.Text := "Debugger: " varRegValueBlock
			btnRun2.Opt("-Disabled")
			btnRestore2.Opt("-Disabled")
		}
		
		btnRun2.Opt("-Disabled")
	}
	enableGroup2(*) {
		btnRun2.Opt("-Disabled")
		btnRestore2.Opt("-Disabled")
	}
	disableGroup2(*) {
		btnRun2.Opt("+Disabled")
		btnRestore2.Opt("+Disabled")
	}
	;= Checkbox on group 1 event
	checkPerm1.OnEvent("Click", (*) =>
	checkPerm2.Value := 0
	checkPermEmpty()
	)
	checkPerm2.OnEvent("Click", (*) =>
	checkPerm1.Value := 0
	checkPermEmpty()
	)
	checkPermEmpty(*) {
		If (checkPerm1.Value = 0) and (checkPerm2.Value = 0)
			btnRun1.Opt("+Disabled")
		Else
			btnRun1.Opt("-Disabled")
	}
	;= Add/Edit Registry
	;@ Group 1
	btnRun1.OnEvent("Click", applyRegValue1)
	applyRegValue1(*) {
		keyName := editPath.Value
		;@ Check the selection option
		If checkPerm1.Value = 1
			keyData := varKeyDataAdmin
		Else
			keyData := varKeyDataUnAdmin
		myGui.Opt("+Disabled")
		
		;@ Add
		If (varRegValuePerm = 0)
			ResultAddReg := MsgBox("Are you sure? `n`n[=] Key:`n" varRegPathPerm "`n[+] Name:`n" keyName "`n[+] Data:`n" keyData , "Check and make it double~!", 0x1001)
		Else
			ResultAddReg := MsgBox("Are you sure? This will replace existing value (usually config from compatibility assistant). `n`n[=] Key:`n" varRegPathPerm "`n[=] Name:`n" keyName "`n[+] Data:`n" keyData , "Replace replace replace!", 0x1031)
		If (ResultAddReg = "OK") {
			RegWrite keyData, "REG_SZ", varRegPathPerm, keyName
			myGui.Opt("-Disabled")
		}
		Else {
			myGui.Opt("-Disabled")
			statusText.Text := "Canceled"
			Return
		}
		
		updateStatus1()
		statusText.Text := "Added!"
	}
	;@ Group 2
	btnRun2.OnEvent("Click", applyRegValue2)
	applyRegValue2(*) {
		keyPath := varRegPathBlock "\" varPathExeName
		keyName := varKeyNameBlock
		keyData := varKeyDataBlock
		myGui.Opt("+Disabled")
		
		;@ Add
		If (varRegValueBlock = 0)
			ResultAddReg := MsgBox("Are you sure? `n`n[+] Key:`n" keyPath "`n[+] Name:`n" keyName "`n[+] Data:`n" keyData, "Admin level regedit... spooky~", 0x1001)
		Else
			ResultAddReg := MsgBox("Are you sure? This will replace existing value. Not a good idea if you don't know what the existing value does.`n`n[=] Key:`n" keyPath "`n[+] Name:`n" keyName "`n[+] Data:`n" keyData, "Admin level replacement... extra spooky~", 0x1031)
		If (ResultAddReg = "OK") {
			RegWrite keyData, "REG_SZ", keyPath, keyName
			myGui.Opt("-Disabled")
		}
		Else {
			myGui.Opt("-Disabled")
			statusText.Text := "Today is not the day.."
			Return
		}
		
		updateStatus2()
		statusText.Text := "Hijacked and banished~!"
	}
	
	
	;= Remove Registry
	;@ Group 1
	btnRestore1.OnEvent("Click", removeRegData1)
	removeRegData1(*) {
		varEditValue := editPath.Value
		myGui.Opt("+Disabled")
		resultRemoveReg := MsgBox("[=] Key:`n" varRegPathPerm "`n[-] Name:`n" varEditValue "`n`nConfirm Deletion.", "Check again", 0x1031)
		If (resultRemoveReg = "OK") {
			RegDelete varRegPathPerm, varEditValue
			myGui.Opt("-Disabled")
		}
		Else {
			myGui.Opt("-Disabled")
			statusText.Text := "Canceled!"
			Return
		}
		updateStatus1()
		statusText.Text := "Erased~!"
	}
	;@ Group 2
	btnRestore2.OnEvent("Click", removeRegData2)
	removeRegData2(*) {
		keyPath := varRegPathBlock "\" varPathExeName
		keyName := varKeyNameBlock
		;keyData := varKeyDataBlock
		hasKeyNameBlock := 0
		keyCount := 0
		myGui.Opt("+Disabled")
		
		;@ Check if multiple data in the key
		Loop Reg, keyPath {
			keyCount++
			If (A_LoopRegName = varKeyNameBlock)
				hasKeyNameBlock := 1
		}

		;@ if contain other than debug
		If (keyCount = 1 and hasKeyNameBlock = 1) {
			resultRemoveReg := MsgBox("Key only contain Debugger, will delete the whole key!`n`n[-] Key:`n" keyPath "`n`nConfirm Deletion.", "Check again", 0x1031)
			If (resultRemoveReg = "OK") {
				RegDeleteKey keyPath
				myGui.Opt("-Disabled")
			}
			Else {
				myGui.Opt("-Disabled")
				Return
			}
		}
		Else If (keyCount > 1 and hasKeyNameBlock = 1) {
			resultRemoveReg := MsgBox("Key contain more than Debugger, will only delete Debugger value.`n`n[=] Key:`n" keyPath "[-] Name:`n" keyName "`n`nConfirm Deletion.", "Check again", 0x1031)
			If (resultRemoveReg = "OK") {
				RegDelete keyPath, keyName
				myGui.Opt("-Disabled")
			}
			Else {
				myGui.Opt("-Disabled")
				statusText.Text := "Order retracted."
				Return
			}
		}
		Else  {
			resultRemoveReg := MsgBox("This message box should not be possible, cancelling.", "Holdup", 0x1010)
			Return
		}
		
		updateStatus2()
		statusText.Text := "Be free, little numbers!"
	}
	;= Help button event
	btnHelp1.OnEvent("Click", tooltipHelp1)
	tooltipHelp1(*) {
		SetTimer tooltipHelp1Content, 0
		SetTimer tooltipHelp1Content, 100
	}
	tooltipHelp1Content(*) {
		MouseGetPos &posX, &posY
		If (posX > 240 and posX < 266 and posY > 15 and posY < 39) {
			ToolTip (
				"Using program compatibility, it set the target executable to run as either `"RunAsAdmin`" or `"RunAsInvoker`"." '`n'
				"The former you can set it via file properties but the latter is where the magic happen." '`n'
				"RunAsInvoker will ignore UAC prompt, denying access from your precious system." '`n`n'
				"Some program that requires higher access, like Program Files, may not work as intended." '`n'
				"If you want to run something without admin privilege, move them to a folder you have ownership of first." '`n'
				"Some will even rerun and begs you to run with admin privilege, otherwise they will throw a tantrum (not running)" '`n'
				'`n'
				"This requires full path to the executable, i.e. `"C:/FOLDER/yourapp.exe`"." '`n'
				"Moving or renaming the file nullifies the hack"
			), 266, 17
		}
		Else {
			SetTimer , 0
			Tooltip
		}
	}
	btnHelp2.OnEvent("Click", tooltipHelp2)
	tooltipHelp2(*) {
		SetTimer tooltipHelp2Content, 0
		SetTimer tooltipHelp2Content, 100
	}
	tooltipHelp2Content(*) {
		MouseGetPos &posX, &posY
		If (posX > 237 and posX < 269 and posY > 164 and posY < 194) {
			ToolTip (
				"Using Image File Execution Option, we hijack an executable and pass it to a `"debugger`" instead." '`n'
				"We use `"systray.exe`" as the debugger because it's an old piece of legacy software that does nothing. Finally a good program from Microsoft!" '`n'
				'`n'
				"This is one of the method to replace Notepad with other better editor. Maybe opening your drawing software when you run your favorite game." '`n'
				"It's also used to hijack important system executable to run a malicious command alongside it. No file, no nothing." '`n'
				'`n'
				"This requires the name of executable, i.e. `"yourapp.exe`"." '`n'
				"Moving the file will still stop the program but renaming it will nullifies the hack" '`n'
				"Make sure you don't softlock yourself like banning explorer.exe"
			), 266, 170
		}
		Else {
			SetTimer , 0
			Tooltip
		}
	}
	;= Copy path event
	btnPath1.OnEvent("Click", copyPath1)
	copyPath1(*) {
		OnClipboardChange checkClipboard, 0
		A_Clipboard := varRegPathPerm
		OnClipboardChange checkClipboard
		ToolTip "Copied `"" varRegPathPerm "`""
		SetTimer () => ToolTip(), -1500
	}
	btnPath2.OnEvent("Click", copyPath2)
	copyPath2(*) {
		OnClipboardChange checkClipboard, 0
		A_Clipboard := varRegPathBlock
		OnClipboardChange checkClipboard
		ToolTip "Copied `"" varRegPathBlock "`""
		SetTimer () => ToolTip(), -1500
	}
	;= Run as admin, kinda ironic we need this on something that modifies this
	btnElevate.OnEvent("Click", runAsAdmin)
	runAsAdmin(*) {
		Try
			Run '*RunAs "' A_ScriptFullPath '" /restart'
		Catch
			btnElevate.Text := "QwQ"
	}
	
	Return myGui
}