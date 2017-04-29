; ==============================================================================
;                             Commands Index Parser                             
; ==============================================================================
; "Commands-Index-Web-Parser.pb" v1.0 (2017-04-23) — PureBASIC 5.60
; License: Unrestricted usage permission.

; Written by Marc56us, Apr 23, 2017.
; Slightly readapted by Tristano Ajmone.

; Taken from:
; -- http://www.purebasic.fr/english/viewtopic.php?13&p=506269

DestURL.s = "http://www.purebasic.com/documentation/reference/commandindex.html"
RegEx.s   = ">(.+)</a><br>"

; To extract the list of PureBasic Constants, uncomment the following lines:

; DestURL.s = "http://www.purebasic.com/documentation/reference/pbconstants.html"
; RegEx.s   = "(#PB_[\w\d]+)"


InitNetwork()

*Buffer = ReceiveHTTPMemory(DestURL)
If *Buffer
  Taille = MemorySize(*Buffer)
  All_Functions.s = PeekS(*Buffer, Taille, #PB_UTF8|#PB_ByteLength)
  FreeMemory(*Buffer)
Else
  Debug "Download failed"
  End
EndIf

CreateRegularExpression(0, RegEx) 

If ExamineRegularExpression(0, All_Functions)
  While NextRegularExpressionMatch(0)
    Debug RegularExpressionGroup(0, 1)
  Wend 
EndIf