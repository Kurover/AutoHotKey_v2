#Requires AutoHotkey v2 ;compileremoveme
#Include ".include" ;compileremoveme

;===============
;=== Module: Link Paste Redirect
;=== Paste things to another things instead of the original thing

;== Start
Hotkey IniRead(settingsPath,"Hotkey","PasteLinkRedirect"), hotkeyPasteLinkRedirect
hotkeyPasteLinkRedirect(*)
{
	;== Var inside function for a tiny memory optimization
	;== Where does the script redirect you to. Change in settings.ini
	varRedirectBilibili := IniRead(settingsPath,"Filter","RedirectBilibili")
	varRedirectReddit := IniRead(settingsPath,"Filter","RedirectReddit")
	varRedirectTwitter := IniRead(settingsPath,"Filter","RedirectTwitter")
	varRedirectYoutube := IniRead(settingsPath,"Filter","RedirectYoutube")
	;varRedirect★YOURSITE★ := "lo.li"
	
	;== Link to check
	varCheckBilibili := IniRead(settingsPath,"Filter","WhichBilibili")
	varCheckReddit := IniRead(settingsPath,"Filter","WhichReddit")
	varCheckTwitter := IniRead(settingsPath,"Filter","WhichTwitter")
	varCheckYoutube := IniRead(settingsPath,"Filter","WhichYoutube")
	;varCheck★YOURSITE★ := "hag.com"

	;== Link to ignore because there may be text overlap like "fx[twitter.com]"
	;== Optional and honestly a nothing burger since we don't replace our actual ctrl+v lol, but it's cool
	varRedirectIgnore := "fxtwitter.com|vxtwitter.com|girlcockx.com|rxddit.com|inv.nadeko.net|vxbilibili.com"

	varOriginalClipboard := A_Clipboard ; = store your original clipboard because we are replacing it for fast paste
	If (A_Clipboard ~= "i)(" varRedirectIgnore ")") {
		Send "^v"
		varOriginalClipboard := ""
		Return
	}
	
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
	
	;== Bilibili
	varCheck := varCheckBilibili
	varRedirect := varRedirectBilibili
	If (A_Clipboard ~= "i)(" varCheck ")") {	
		If (A_Clipboard ~= "i)/?")
			varLinkClean := RegExReplace(A_Clipboard, "\/\?.+") ; Remove tracking link
		A_Clipboard := StrReplace(varLinkClean, varCheck, varRedirect)				
		Goto PasteRedirect
	}
		
	;### Add your website here. Make sure to add the site variable above
	;### If your website is ass like twitter or youtube that has multiple address, copy the those section instead.
	;== Example
;	varCheck := varCheck★YOURSITE★
;	varRedirect := varRedirect★YOURSITE★
;	If (A_Clipboard ~= "i)(" varCheck ")") {		
;		A_Clipboard := StrReplace(A_Clipboard, varCheck, varRedirect)				
;		Goto PasteRedirect
;		}
	;### END
	
	Return
	
	PasteRedirect:
	Send "^v"
	Sleep 50 ; add small delay to restore clipboard because the paste can be inconsistent sometimes
	A_Clipboard := varOriginalClipboard
	Return
}