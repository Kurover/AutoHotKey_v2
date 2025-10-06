#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Link Paste Redirect 2
;=== Same as the first one, with different hotkey and destination, possibly

;== Start
Hotkey IniRead(settingsPath,"Hotkey","PasteLinkRedirect2"), hotkeyPasteLinkRedirect2
hotkeyPasteLinkRedirect2(*)
{
	;== Change the "Redirect<site>" and add/match it on config
	varRedirectBilibili := IniRead(settingsPath,"Filter","RedirectBilibili")
	varRedirectReddit := IniRead(settingsPath,"Filter","RedirectReddit")
	varRedirectTwitter := IniRead(settingsPath,"Filter","RedirectTwitter")
	varRedirectYoutube := IniRead(settingsPath,"Filter","RedirectYoutube")
	varRedirectInstagram := IniRead(settingsPath,"Filter","RedirectInstagram")
	varRedirectFacebook := IniRead(settingsPath,"Filter","RedirectFacebook")
	varRedirect6digit := IniRead(settingsPath,"Filter","Redirect6digitSite")
	
	;== Link to check, should be the same as the first
	varCheckBilibili := IniRead(settingsPath,"Filter","WhichBilibili")
	varCheckReddit := IniRead(settingsPath,"Filter","WhichReddit")
	varCheckTwitter := IniRead(settingsPath,"Filter","WhichTwitter")
	varCheckYoutube := IniRead(settingsPath,"Filter","WhichYoutube")
	varCheckInstagram := IniRead(settingsPath,"Filter","WhichInstagram")
	varCheckFacebook := IniRead(settingsPath,"Filter","WhichFacebook")

	varOriginalClipboard := A_Clipboard

	;== Twitter
	varCheck := varCheckTwitter
	varRedirect := varRedirectTwitter
	If (A_Clipboard ~= "i)(" varCheck ")") {
		Loop Parse, varCheck, "|"{
			If (A_Clipboard ~= A_LoopField) {
				A_Clipboard := StrReplace(A_Clipboard, A_LoopField, varRedirect)				
				Goto PasteRedirect
			}
		}
	}
		
	;== Youtube
	varCheck := varCheckYoutube
	varRedirect := varRedirectYoutube
	If (A_Clipboard ~= "i)(" varCheck ")") {
		Loop Parse, varCheck, "|"{
			If (A_Clipboard ~= A_LoopField) {
				A_Clipboard := StrReplace(A_Clipboard, A_LoopField, varRedirect)				
				Goto PasteRedirect
			}
		}
	}
		
	;== Reddit
	varCheck := varCheckReddit
	varRedirect := varRedirectReddit
	If (A_Clipboard ~= "i)(" varCheck ")") {		
		A_Clipboard := StrReplace(A_Clipboard, varCheck, varRedirect)				
		Goto PasteRedirect
	}
	
	;== Facebook
	varCheck := varCheckFacebook
	varRedirect := varRedirectFacebook
	If (A_Clipboard ~= "i)(" varCheck ")") {		
		A_Clipboard := StrReplace(A_Clipboard, varCheck, varRedirect)				
		Goto PasteRedirect
	}
	
	;== Instagram
	varCheck := varCheckInstagram
	varRedirect := varRedirectInstagram
	If (A_Clipboard ~= "i)(" varCheck ")") {		
		A_Clipboard := StrReplace(A_Clipboard, varCheck, varRedirect)				
		Goto PasteRedirect
	}
	
	;== Bilibili
	varCheck := varCheckBilibili
	varRedirect := varRedirectBilibili
	If (A_Clipboard ~= "i)(" varCheck ")") {	
		If (A_Clipboard ~= "i)/?")
			varLinkClean := RegExReplace(A_Clipboard, "\/\?.+") ; Remove tracking link
		A_Clipboard := StrReplace(varLinkClean, varCheck, varRedirect)				
		Goto PasteRedirect
	}
	
	;== 6digitSite
	linkCheck6digit := Trim(varOriginalClipboard, "`n `t")
	lengthCheck := StrLen(linkCheck6digit)
	If (lengthCheck = 6) {
		varLinkClean := varRedirect6digit
		A_Clipboard := StrReplace(varLinkClean, "REPLACEME", linkCheck6digit)
		Goto PasteRedirect
	}
	
	ToolTip "Nothing to convert"
	SetTimer () => ToolTip(), -1250 ;=== Kill tooltip after 1.25s
	Send "^v"
	Return
	
	PasteRedirect:
	Send "^v"
	Sleep 50 ; add small delay to restore clipboard because the paste can be inconsistent sometimes
	A_Clipboard := varOriginalClipboard
	Return
}