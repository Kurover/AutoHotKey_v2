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
	varRedirectInstagram := IniRead(settingsPath,"Filter","RedirectInstagram")
	varRedirectFacebook := IniRead(settingsPath,"Filter","RedirectFacebook")
	;varRedirectX := IniRead(settingsPath,"Filter","RedirectX")
	;varRedirect★YOURSITE★ := "lo.li"
	
	varRedirect6digit := IniRead(settingsPath,"Filter","Redirect6digitSite")
	
	;== Link to check
	varCheckBilibili := IniRead(settingsPath,"Filter","WhichBilibili")
	varCheckReddit := IniRead(settingsPath,"Filter","WhichReddit")
	varCheckTwitter := IniRead(settingsPath,"Filter","WhichTwitter")
	varCheckYoutube := IniRead(settingsPath,"Filter","WhichYoutube")
	varCheckInstagram := IniRead(settingsPath,"Filter","WhichInstagram")
	varCheckFacebook := IniRead(settingsPath,"Filter","WhichFacebook")
	;varCheckX := IniRead(settingsPath,"Filter","WhichX")
	;varCheck★YOURSITE★ := "hag.com"

	;== Link to ignore because there may be text overlap like "fx[twitter.com]"
	;== Optional and honestly a nothing burger since we don't replace our actual ctrl+v lol, but it's cool
	varRedirectIgnore := "fxtwitter.com|vxtwitter.com|girlcockx.com|rxddit.com|inv.nadeko.net|vxbilibili.com"

	varOriginalClipboard := A_Clipboard ; = store your original clipboard because we are replacing it for fast paste
	If (A_Clipboard ~= "i)(" varRedirectIgnore ")") {
		Send "^v"
		ToolTip "Already converted, pasting normally."
		SetTimer () => ToolTip(), -1250 ;=== Kill tooltip after 1.25s
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
		If (A_Clipboard ~= "youtube.com/shorts") {
			ToolTip "YT Shorts detected. Unshortening instead"
			SetTimer () => ToolTip(), -1250 ;=== Kill tooltip after 1.25s
			varLinkClean := StrReplace(A_Clipboard, "?feature=share") ; Remove tracking link ("?feature=share")
			varLinkClean := StrReplace(varLinkClean, "shorts/", "watch?v=") ; Remove tracking link ("?feature=share")
			A_Clipboard := varLinkClean
			Goto PasteRedirect
		}
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
	
	;== 6digitSite convert exactly 6 digit into its link
	linkCheck6digit := Trim(varOriginalClipboard, "`n `t")
	lengthCheck := StrLen(linkCheck6digit)
	If (lengthCheck = 6) {
		varLinkClean := varRedirect6digit
		A_Clipboard := StrReplace(varLinkClean, "REPLACEME", linkCheck6digit)
		Goto PasteRedirect
	}
	
	;== GalleryDL folder to link - Twitter
	;== Basically it convert this
	; C:\Users\Illith\Downloads\Gallery-DL\twitter\suzukannn\1910289114777149464_1.jpg
	
	;== to this
	; https://x.com/suzukannn/status/1910289114777149464
	
	;== Only if you use this settings in your Twitter processing config. It should be scalable to other site as long as it uses similar system. Just need to change the template and source variable
	; "directory": ["twitter", "{author[name]}"],
	; "postprocessors": ["content"],
	varGalleryDLClipboard := StrReplace(A_Clipboard, "`\", "`/")
	varGalleryDLOutputPath := "C:/Users/Illith/Downloads/Gallery-DL" ; replace backslash with frontslash as it may throw error in the IF check
	
	varGalleryDLTemplate := "https://x.com/(USER)/status/(NUMBER)"
	varGalleryDLSource := "twitter"
	If (varGalleryDLClipboard ~= varGalleryDLOutputPath ".*" varGalleryDLSource) {
		usernameSource := StrReplace(varGalleryDLClipboard, varGalleryDLOutputPath "/" varGalleryDLSource "/") ; remove most string to the last two word between slash
		varIdentifier := StrSplit(usernameSource, "/") ; take the 2 word between slash into an array
		
		cleanSource := SubStr(varIdentifier[2], 1, StrLen(usernameSource) - 4) ; remove last 4 characters which is the file format
		cleanSource := RegExReplace(cleanSource, "_.*") ; remove _1, usually from multi post
		
		finalLink := StrReplace(varGalleryDLTemplate, "(USER)", varIdentifier[1])
		A_Clipboard := StrReplace(finalLink, "(NUMBER)", cleanSource)
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