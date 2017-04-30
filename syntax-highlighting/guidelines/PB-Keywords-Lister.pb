; ==============================================================================
;                           PureBASIC Keywords Lister                           
; ==============================================================================
; List all Functions and Constants from PB html help 
; (Not basic keywords for the moment)

; "PB-Keywords-Lister.pb" v1.0 (2017-04-23) — PureBASIC 5.60
; License: Unrestricted usage permission.

; Written by Marc56us, 2017-04-25
; Feel free to use, modify, ameliorate, simplify as you want
; Topic from Tristano, http://www.purebasic.fr/english/viewtopic.php?13&p=506269

InitNetwork()

Repeat
  Read.s Info_Type.s
  If Info_Type = "END"
    Debug "OK All Done."
    End
  EndIf
  
  Debug "--- Extract: " + Info_Type.s + "..."    
  
  Read.s Info_URL.s
  *Buffer = ReceiveHTTPMemory(Info_URL)
  
  If *Buffer
    Taille = MemorySize(*Buffer)
    All_Functions.s = PeekS(*Buffer, Taille, #PB_UTF8|#PB_ByteLength)
    FreeMemory(*Buffer)
  Else
    Debug "Download Fail (" + Info_URL + ")"
    End
  EndIf
  
  Read.s Info_RegEx.s
  If Not CreateRegularExpression(0, Info_RegEx) 
    Debug "Can't create regular expression " + Info_RegEx
    End
  EndIf
  
  Output_FileName.s = GetTemporaryDirectory() + "PB_" + Info_Type + ".txt"
  If Not OpenFile(0, Output_FileName)
    Debug "Can't create output file for: " + Info_Type
    End
  EndIf
  
  If ExamineRegularExpression(0, All_Functions)
    While NextRegularExpressionMatch(0)
      ; Debug RegularExpressionGroup(0, 1)
      WriteString(0, RegularExpressionGroup(0, 1) + #CRLF$)
    Wend 
  EndIf
  CloseFile(0)
  RunProgram(Output_FileName)
  Debug "    Done. " + #CRLF$ + "    FileName: " + Output_FileName + #CRLF$
  FreeRegularExpression(0)
ForEver


DataSection
  ; Name, URL, Regular expression needed
  Data.s "Functions", "http://www.purebasic.com/documentation/reference/commandindex.html", ">(.+)</a><br>",
         "Constants", "http://www.purebasic.com/documentation/reference/pbconstants.html", "(#PB_[\w\d]+)",     
         "END"
EndDataSection
