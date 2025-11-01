#Requires AutoHotkey v2
#SingleInstance Force
SetWorkingDir A_ScriptDir
TraySetIcon("Resources/ahk-icon16_2.ico",,true)
DetectHiddenWindows true
FileEncoding "UTF-8-RAW"

rootDir := A_ScriptDir
settingsPath := A_ScriptDir "/settings.ini"
settingsPathDefault := A_ScriptDir "/settings_default.ini"

If !FileExist(settingsPath) {
	FileCopy settingsPathDefault, settingsPath
	Sleep 500
}

resourcesDir := A_ScriptDir "/Resources"

varIncludeName := ".include"
varTemplateName := "== Create Script.ahk"

;=== Compiler settings
;=== What to compile. This is one of the settings where we wonder
;=== "Do we nee this? in a compiler who's purpose is to compile?"
varCompileMain := IniRead(settingsPath,"Compiler","CompileMain")
varCompileAdmin := IniRead(settingsPath,"Compiler","CompileAdmin")
varCompileLegacy := IniRead(settingsPath,"Compiler","CompileLegacy")


;=== Setting for what script to run after compiling 
varRunMain := IniRead(settingsPath,"Compiler","RunMainAfter")
varRunAdmin := IniRead(settingsPath,"Compiler","RunAdminAfter")
varRunLegacy := IniRead(settingsPath,"Compiler","RunLegacyAfter")

;=== Script Name
;=== You can change it in settings.ini but uhh don't do it
;=== We don't fully remember if we put hardlink on modules or not
;=== We do know that the task-scheduler.ps1 has hardlink for admin script
varTargetMain := IniRead(settingsPath,"File","MainScript")
varTargetAdmin := IniRead(settingsPath,"File","AdminScript")
varTargetLegacy := IniRead(settingsPath,"File","LegacyScript")

;=== If you have run admin script after compile enabled in settings.ini, make this compiler admin
full_command_line := DllCall("GetCommandLine", "str")
If (varRunAdmin = "true") {
	if not (A_IsAdmin or RegExMatch(full_command_line, " /restart(?!\S)"))
	{
		Try
			Run '*RunAs "' A_ScriptFullPath '" /restart'
		ExitApp
	}
}

;=== Check file to replace them
funcCheckFile(*) {
	global
	If FileExist(varCompileTarget)
		FileDelete varCompileTarget
}

;=== Grab txt and ahk file to wherever varCompileTargetPath points to
funcCompile(varCompileTargetPath) {
	Loop Files, varCompileTargetPath {
		; Check extension. There will be a cucumber out there who put exe files (plural) and break everyhing
		If (A_LoopFileExt ~= "i)TXT|AHK") AND NOT (A_LoopFileName ~= "==") {	
			varText := FileRead(A_LoopFileFullPath)
			varText := RegExReplace(varText, "m`a).*;compileremoveme") ; Remove all lines before ;compileremove, including itself
			FileAppend varText "`n", varCompileTarget
		}
	}
}

;=== Remove comment and empty spaces
;=== +3 KB? Take it or leave it
funcCleanUp(*) {
	clean := FileRead(varCompileTarget)
	Sleep 50
	clean := RegExReplace(clean, "m);\N+")
	Sleep 50
	clean := RegExReplace(clean, "m`a)^\s+|\h+$|\s+(?-m)$")
	FileDelete varCompileTarget
	FileAppend clean, varCompileTarget
}

;=== Put everything in Modules and Modules/Program
;===================
If (varCompileMain = "true") {
	varCompileTarget := varTargetMain
	funcCheckFile()
	funcCompile("Modules/*")
	funcCompile("Modules/Program/*")
	FileAppend "#HotIf`n", varCompileTarget
	funcCleanUp()
}

;=== Put everything in Elevated (Admin mode)
;===================
If (varCompileAdmin = "true") {
	varCompileTarget := varTargetAdmin
	funcCheckFile()
	funcCompile("Modules/Elevated/*")
	funcCleanUp()
}

;=== Put everything in v1 / legacy
;===================
If (varCompileLegacy = "true") {
	varCompileTarget := varTargetLegacy
	funcCheckFile()
	funcCompile("Modules/Version1/*")
	funcCleanUp()
}

;=== Post function

;=== Initialize settings.ini
;=== Will add any new line if any
funcSettings(*) {
	oldSettings := FileRead(settingsPath)
	finalSettings := oldSettings

	Loop Read, "settings_default.ini" {
		If (A_LoopReadLine ~= "[[]") {
			currentCategory := A_LoopReadLine
			categoryValue := SubStr(A_LoopReadLine, 1)
			categoryIsNew := inStr(finalSettings, categoryValue) ; return 0 if it's new
			If (categoryIsNew = "0")
				finalSettings := strReplace(finalSettings, "[Compiler]", "`r`n" categoryValue "`r`n" "[Compiler]")
			Continue
		}
		Else If (A_LoopReadLine ~= "=") {
			nameLength := RegExMatch(A_LoopReadLine, " ") - 1
			keyValue := SubStr(A_LoopReadLine, 1, nameLength)
			keyIsNew := inStr(finalSettings, keyValue) ; return 0 if it's new
			If (keyIsNew = "0") {
				nameFullValue := SubStr(A_LoopReadLine, 1)
				;msgbox keyValue " in " currentCategory " | " inStr(finalSettings, keyValue)
				;msgbox "Inserting | " nameFullValue
				finalSettings := strReplace(finalSettings, currentCategory, currentCategory "`r`n" nameFullValue)
			}
		}
	}
	compareSettings := StrCompare(oldSettings, finalSettings) ; If no difference, return 0
	;msgbox compareSettings
	If (compareSettings = "0")
		Return
	FileDelete settingsPath
	FileAppend finalSettings, settingsPath
}
funcSettings()

;=== Add working dir variable to root path so every module script has this data
;=== This allow us to simulate script to be run as compiled together
;=== We could use SetWorkingDir instead of custom variable but that potentially creates confusion
funcIncluder(fileInclude) {
	If FileExist(fileInclude) { ; Check if path match with current root, if yes, stop replacing
		varMatch := FileRead(fileInclude) ; Read the file
		If InStr(varMatch, A_ScriptDir) ; Check if match
			Return ; If has match, return
		FileDelete fileInclude
	}
	FileAppend 'rootDir := "' A_ScriptDir '"`n', fileInclude
	FileAppend "
	(
	settingsPath := rootDir "/settings.ini"
	Hotkey IniRead(settingsPath,"Hotkey","ModuleReload"), hotkeyModuleReload
	hotkeyModuleReload(*) {
		Reload
	}
	Hotkey IniRead(settingsPath,"Hotkey","ModuleExit"), hotkeyModuleExit
	hotkeyModuleExit(*) {
		ExitApp
	}
	)", fileInclude
}
funcIncluderV1(fileInclude) {
	If FileExist(fileInclude) {
		varMatch := FileRead(fileInclude)
		If InStr(varMatch, A_ScriptDir)
			Return
		FileDelete fileInclude
	}
	FileAppend 'rootDir := "' A_ScriptDir '"`n', fileInclude
	FileAppend 'settingsPath := rootDir "/settings.ini"`n', fileInclude
	FileAppend "
	(
	IniRead, hotkeyModuleReload, %settingsPath%, Hotkey, ModuleReload
	IniRead, hotkeyModuleExit, %settingsPath%, Hotkey, ModuleExit
	Hotkey, %hotkeyModuleReload%, labelModuleReload
	Hotkey, %hotkeyModuleExit%, labelModuleExit
	Goto includeContinue
	labelModuleReload:
	Reload
	labelModuleExit:
	ExitApp
	includeContinue:
	Sleep 10
	)", fileInclude
}
funcIncluder("Modules/" varIncludeName)
Loop Files, "Modules/*", "D" {
	varTargetDir := "Modules/" A_LoopFileName
	If !(A_LoopFileName = "Version1")
		funcIncluder(varTargetDir "/" varIncludeName)
}
funcIncluderV1("Modules/Version1/" varIncludeName)

;=== Add template maker shortcut (the main one is in resources)
funcTemplater(fileTemplater) {
	If FileExist(fileTemplater) {
		varMatch := FileRead(fileTemplater)
		If InStr(varMatch, A_ScriptDir)
			Return
		FileDelete fileTemplater
	}
	varTarget := resourcesDir "/template-master.txt"
	FileAppend "
	(
	#Requires Autohotkey v2
	#SingleInstance force`n
	)", fileTemplater
	FileAppend '#Include "' varIncludeName '"`n', fileTemplater
	FileAppend '#Include "' varTarget '"', fileTemplater
}
funcTemplater("Modules/" varTemplateName)
Loop Files, "Modules/*", "D" {
	varTargetDir := "Modules/" A_LoopFileName
	If !(A_LoopFileName = "Version1")
		funcTemplater(varTargetDir "/" varTemplateName)
}

;=== Post confirmation
varFullPathMain := A_ScriptDir "/" IniRead(settingsPath,"File","MainScript")
varFullPathAdmin := A_ScriptDir "/" IniRead(settingsPath,"File","AdminScript")
varFullPathLegacy := A_ScriptDir "/" IniRead(settingsPath,"File","LegacyScript")

; Run things unelevated, relevant if you are trying to have admin autorun after compile
funcRunUnelevated(varUnelevatedTarget) {
	DllCall("wdc.dll\WdcRunTaskAsInteractiveUser", "wstr", "rundll32.exe shell32.dll,ShellExec_RunDLL " varUnelevatedTarget, "wstr", A_ScriptDir, "int", 0x27)
}

If (varRunLegacy = "true") {
	If A_IsAdmin
		funcRunUnelevated(varFullPathLegacy)
	Else
		Run varTargetLegacy
}
If (varRunMain = "true") {
	Sleep 250
	If A_IsAdmin
		funcRunUnelevated(varFullPathMain)
	Else
		Run varTargetMain
}
If (varRunAdmin = "true") {
	Sleep 250
	Run varTargetAdmin
}
If (IniRead(settingsPath,"Compiler","PopupOnFinish") = "false") {
	Try
		varEndDing()
	Sleep 500
	ExitApp
}
; the thing i do just to make the sound sync with the animated popup... looks ok if you have anim disabled too
SetTimer varEndDing, 135
varEndDing(*) {
	SoundPlay "Resources/Ding1.wav"
	SetTimer , 0
}
; 0x40 is to add the "i" icon, T4 is timeout 4s
	MsgBox("Modules, modulated! (Re)loading.", "Compiled!", "0x40 T4")