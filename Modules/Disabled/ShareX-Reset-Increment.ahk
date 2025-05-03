#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: ShareX auto capture/increment file auto reset
;=== Why is this not a native feature?

#j::
{
	varShareXConfig := A_MyDocuments "/ShareX/ApplicationConfig.json" ; Change this to full path if you're using custom path (ex: "C:/yourfolder/myShareX/ApplicationConfig.json", deleting A_MyDocuments)
	varProcessName := "ShareX.exe" ; Change if you uh.. change the process name?????
	
	varSharexReplace := '"NameParserAutoIncrementNumber": ' ; The thing to edit, number is retrieved later
	varSharexExpected := '"NameParserAutoIncrementNumber": 0' ; Config we want to end up with
	
	;=== Check if exist, otherwise stop
	If !FileExist(varShareXConfig) {
		MsgBox "Config not found, make sure to change it in the file! Exiting."
		Return
	}
	
	;=== Read and Check config
	Content := FileRead(varShareXConfig)
	FoundPos := inStr(Content, '"NameParserAutoIncrementNumber"') ; Find the config position
	RegExMatch(Content, "(\d+)", &incrementNum, FoundPos) ; Get the increment value
	If (incrementNum[1] = "0") {
		Msgbox "Counter is at 0 already. Exiting.", "No need to run!"
		Return
	} ; Works as a checker whether user ran this twice or it failed to find the setting
	
	;=== ShareX Process, close it
	;=== If not exist, it will not autostart ShareX upon script completion
	ShareXPath := "0"
	If ProcessExist(varProcessName) {
		ShareXPath := ProcessGetPath(varProcessName)
		ProcessClose varProcessName
		PID := ProcessWaitClose(varProcessName)
	}
	
	;=== Retrieve config folder path, mainly for those custom pather. This is to backup config
	Loop Files, varShareXConfig {
		ConfigDir := A_LoopFileDir
		ConfigName := A_LoopFileName
	}
	
	BackupConfig := ConfigDir "/" ConfigName ".bak"
	
	;=== Backup file
	If FileExist(BackupConfig)
		FileDelete BackupConfig
	FileCopy varShareXConfig, BackupConfig
	
	;=== Replace content
	varSharexReplace := varSharexReplace incrementNum[1] ; Insert the value so we replace the whole string
	Content := RegExReplace(Content, varSharexReplace, varSharexExpected) ; Replace whole string with 0 value
	
	FileDelete varShareXConfig ; Remove file and-
	FileAppend Content, varShareXConfig ; Create the edited one
	
	If !(ShareXPath = 0) ; Run ShareX if it was running previously
		Run ShareXPath
	
	MsgBox "Previous Increment was " incrementNum[1], "Success!", "T5"
}

