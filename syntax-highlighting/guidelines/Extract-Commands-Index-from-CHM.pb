; ==============================================================================
;                  Extract Commands-Index Page from PureBasic.chm                  
; ==============================================================================
; "Extract-Commands-Index-from-CHM.pb" v1.0 (2017-04-28)
; Extract "commandindex.html" from PureBASIC's "PureBasic.chm" documentation.

; by Marc56us (2017-04-27)
; License: Unrestricted usage permission.
; Feel free to use, modify, ameliorate, simplify as you want

; Topic from Tristano, http://www.purebasic.fr/english/viewtopic.php?13&p=506269

; Note a .CHM can be open with 7zip (not with LZMA PB internal function)
; Download 7zip (http://www.7-zip.org/) and copy 7zG.exe in folder or modify path

HelpFile.s = OpenFileRequester("", "PureBasic.chm", "*.chm", 0, 0)

If FileSize(HelpFile) < 1
  Debug "No File or Cancel. Quit"
  End
EndIf

Debug "Open"

; Use 7z.exe or 7zG.exe (Prefere 7zG (graphic) because of graphic error message
If RunProgram("7zG.exe", "e " + HelpFile + " Reference\commandindex.html", "", #PB_Program_Wait)
  Debug "Extract OK :-)"
  RunProgram("commandindex.html")
Else
  Debug "Extract KO :-("
EndIf