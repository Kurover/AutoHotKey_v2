#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: YouTube Download Video Section
;=== Requires YT-DLP

;AutoGUI creator: Alguimist autohotkey.com/boards/viewtopic.php?f=64&t=89901
;AHKv2converter creator: github.com/mmikeww/AHK-v2-script-converter
;EasyAutoGUI-AHKv2 github.com/samfisherirl/Easy-Auto-GUI-for-AHK-v2

GUIEzDL() {	
	localSettingsPath := A_ScriptDir
	ytdlpPath := IniRead(settingsPath,"Path","ytdlp")
	downloadPath := A_Desktop
	If !(rootDir == "") {
		localSettingsPath := rootDir
	}
	localSettings := localSettingsPath "/yt-clip.ini"
	
	If !FileExist(localSettings) {
		FileAppend "
		(
		[General]
		AutoFill = 1
		Keyframe = 0
		Chat = 0
		Quality = 1
		)", localSettings
		Sleep 100
	}

	ezdlGui := Gui()
	ezdlGui.Opt("-MinimizeBox -MaximizeBox +AlwaysOnTop")
	ezdlGui.Title := "EzDownloadSections"
	ButtonDownload := ezdlGui.Add("Button", "x8 y104 w141 h31", "&Download")
	ButtonCopy := ezdlGui.Add("Button", "x152 y104 w102 h31", "&Copy Command")
	Edit1 := ezdlGui.Add("Edit", "x48 y8 w310 h21", "'Copy URL at current time' and put it here. Leave next one empty to DL normally")
	Edit2 := ezdlGui.Add("Edit", "x48 y40 w310 h21")
	ezdlGui.Add("Text", "x8 y9 w32 h21 +Center", "Start")
	ezdlGui.Add("Text", "x8 y41 w32 h21 +Center", "End")
	CheckBox1 := ezdlGui.Add("CheckBox", "x10 y72 w120 h23 +Checked", "Autofill w/ Clipboard")
	CheckBox2 := ezdlGui.Add("CheckBox", "x136 y72 w100 h23", "Cut to Keyframe")
	CheckBox3 := ezdlGui.Add("CheckBox", "x248 y72 w110 h23", "Download Chat")
	DropDownList1 := ezdlGui.Add("DropDownList", "x257 y110 w101", ["Best Quality","Interactive" ,"1080p", "720p", "480p"])
	ButtonDownload.OnEvent("Click", funcDownload)
	ButtonCopy.OnEvent("Click", funcCopyCommand)
	
	CheckBox1.Value := IniRead(localSettings,"General","AutoFill")
	CheckBox2.Value := IniRead(localSettings,"General","Keyframe")
	CheckBox3.Value := IniRead(localSettings,"General","Chat")
	DropDownList1.Value := IniRead(localSettings,"General","Quality")
	
	ezdlGui.OnEvent('Escape', ezdlGui_close)
	ezdlGui.OnEvent('Close', ezdlGui_close)
	ezdlGui_close(thisgui) {
		OnClipboardChange checkClipboard, 0
		ChangeGUIState()
		ezdlGui.Destroy
	}
	
	;= Make sure the window can be called again
	ChangeGUIState(*) {
		Global
		programGUIEzDL := 0
	}
	
	;= Clipboard Listener
	OnClipboardChange checkClipboard
	checkClipboard(*) {
		If (CheckBox1.Value = 0)
			Return
		If (A_Clipboard ~= "t`=|youtu.be") {
			If !(Edit1.Value ~= "t`=|youtu.be") {
				Edit1.Value := A_Clipboard
				Return
			}
			If (A_Clipboard = Edit1.Value)
				Return
			Edit2.Value := A_Clipboard
			funcDownload()
		}
	}
	
	funcLinkDecoder(*) {
		global linkSource := Edit1.Value
		If !(linkSource ~= "http|youtu.be|.com|www.") {
			MsgBox "No links detected?", "Ermm..", 0x1000
			Return
		}
		
		ytdlpCommand := ytdlpPath " " linkSource " -P " downloadPath
		
		If (Edit1.Value ~= "\?t=.*") {
			timestamp1Pos := InStr(Edit1.Value, "`?t=")
			timestamp1 := SubStr(Edit1.Value, timestamp1Pos + 3)
			If (Edit2.Value ~= "\?t=.*") {
				timestamp2Pos := InStr(Edit2.Value, "`?t=")
				timestamp2 := SubStr(Edit2.Value, timestamp2Pos + 3)
				If (timestamp1 > timestamp2) {
					MsgBox "The start link's timestamp is larger than the end. Fortunately for you, we are smarter. Continuing~",,0x1000
					timestamp0 := timestamp1
					timestamp1 := timestamp2
					timestamp2 := timestamp0
				}
				ytdlpCommand := ytdlpCommand ' --download-sections "*' timestamp1 '-' timestamp2 '"'
			}
		}
	
		If (DropDownList1.Value = 2)
			ytdlpCommand := ytdlpCommand " -f -"
		If (DropDownList1.Value = 3)
			ytdlpCommand := ytdlpCommand ' -S "res:1080,+codec:avc:h264"'
		If (DropDownList1.Value = 4)
			ytdlpCommand := ytdlpCommand ' -S "res:720,+codec:avc:h264"'
		If (DropDownList1.Value = 5)
			ytdlpCommand := ytdlpCommand ' -S "res:480,+codec:avc:h264"'
		If (CheckBox2.Value = 1)
			ytdlpCommand := ytdlpCommand " --force-keyframes-at-cuts"
		If (CheckBox3.Value = 0)
			ytdlpCommand := ytdlpCommand " --compat-options no-live-chat"
		
		global ytdlpCommand := ytdlpCommand
	}
	funcCopyCommand(*) {
		global ytdlpCommand := ""
		funcLinkDecoder()
		If (ytdlpCommand = "")
			Return
		A_Clipboard := ytdlpCommand
		ToolTip("Copied!`n"
		. ytdlpCommand )
		SetTimer () => ToolTip(), -3000
	}
	funcDownload(*) {
		global ytdlpCommand := ""
		funcLinkDecoder()
		If (ytdlpCommand = "")
			Return
		Run A_COMSPEC " /c " ytdlpCommand
		OnClipboardChange checkClipboard, 0
		saveSettings()
		ezdlGui.Destroy()
	}
	saveSettings(*) {
		oldSettings := FileRead(localSettings)
		finalSettings := oldSettings

		saveSetting(settingName, settingValue) {
			FoundPos := inStr(finalSettings, settingName)
			finalSettings := RegExReplace(finalSettings, "\=.*", '= ' settingValue,,, FoundPos)
		}
		saveSetting("AutoFill", CheckBox1.Value)
		saveSetting("Keyframe", CheckBox2.Value)
		saveSetting("Chat", CheckBox3.Value)
		saveSetting("Quality", DropDownList1.Value)
		
		compareSettings := StrCompare(oldSettings, finalSettings) ; If no difference, return 0 to skip the save
		If (compareSettings = "0")
			Return
		
		FileDelete localSettings
		FileAppend finalSettings, localSettings
	}
	
	Return ezdlGui
}

;= Function to prevent duplicate window when hotkey is pressed
programGUIEzDL := 0

Hotkey IniRead(settingsPath,"Hotkey","YoutubeClip"), hotkeyYTClip
hotkeyYTClip(*) {
	Global
	If (programGUIEzDL != 0) {
		programGUIEzDL.Show("Restore")
		Return
	}
	programGUIEzDL := GUIEzDL()
	programGUIEzDL.Show("w368 h144")
}
