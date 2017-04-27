; ******************************************************************************
; *                                                                            *
; *                         Extract PureBASIC Keywords                         *
; *                                                                            *
; *                      from SDK’s SyntaxHilighting.dll                       *
; *                                                                            *
;{******************************************************************************
; "parse-highlighting-dll.pb" v1.0 (2017-04-27) -- PureBASIC 5.60
; ------------------------------------------------------------------------------
; Parse a "SyntaxHilighting.dll" file (found in PureBASIC for Windows x64 SDK)
; and extract all the syntax tokens (PureBASIC types and pseudotypes, PureBASIC
; keywords, ASM keywords) and write them to file.
; ------------------------------------------------------------------------------
; Created by Tristano Ajmone (2017-04-27) for "The PureBASIC Archives" project:
;
;  -- https://github.com/tajmone/purebasic-archives
;
; LICENSE: Released into the public domain according to the Unlicense terms:
;
;  -- http://unlicense.org/
;}

; ==============================================================================
;                                  INTRODUCTION                                 
;{==============================================================================
; This application was designed to help maintainers of PureBASIC language
; definitions for syntax highlighters. The DLL that ships with PureBASIC's SDK
; is the only (known) means to get a full list of all the PB and ASM keywords for
; any given version PureBASIC.
;   This app will parse the DLL in a (more or less) smart way, and extract all
; the tokens found therin and write them to file. The final list will contain
; some duplicate keywords and a few garbage strings. The purpose of this tool
; is not to create a ready to use list of tokens: the purpose is to pass the
; lists to some diffing tool in order to see what has changed between different
; PureBASIC releases. This would allow a quick way to see if new tokens have been
; added, or if tokens were removed, allowing maintainers of language definitions
; to manually adjust their lists (after all, keywords changes are not frequent).
;   Bare in mind that the tokens list will not contain the built-in commands:
; PureBASIC IDE highlights user-created procedures and built-in functions in the
; same manner. For a full list of the built-in commands, refer to the Commands
; Index page of the documentation.
;}
; ==============================================================================
;                                     USAGE                                     
;{==============================================================================
; Just run the application (no need to compiler it). You'll be presented with
; a file-requester dialog: select the desired version of "SyntaxHilighting.dll".
;   The app expects that the DLL be taken from the x64 version of PB for Win, it
; wasn't tested with the x86 and it might not work with it.
;   The app will check the filename: if it contains reference to a possible
; PureBASIC version (eg: "5.50", "542") it will assume it's the PureBASIC
; version the DLL was taken from. This is because most likely you'll be working
; with copies of the original DLLs, renamed according to version number.
;   If the DLL filename doesn't contain references to a PB version, you'll be
; asked to type it manually.
;   The app will then load and parse the DLL, extract the tokens and write them
; to a text file in its working folder, named "tokens-list-PBXXX.txt" (where XXX
; will be the PureBASIC version, eg: 540)
;}

Declare FindStringInMemory(*BufferID, targetStr.s)

; ==============================================================================
;                    Ask User to Select Syntax Higlighter DLL                   
; ==============================================================================

StandardFile$ = #PB_Compiler_FilePath + "SyntaxHilighting.dll"    ; set initial file+path to display


Pattern$ = "DLL (*.dll)|*.dll"
Pattern = 0    ; use the first of the three possible patterns as standard
File$ = OpenFileRequester("Please choose file to load", StandardFile$, Pattern$, Pattern)

If File$ = #Null$
  ; We don't propose another File Requester, we just abort
  ; (otherwise the user can't quit the program)
  MessageRequester("Error", "You must select a syntax highlighter DLL file!", #PB_MessageRequester_Error)
  End 1 ; Exit with error
EndIf
; ------------------------------------------------------------------------------
;                             Check That File Exists                            
; ------------------------------------------------------------------------------
; Check that file exists (OpenFileRequester doesn't do any checks) ...
If FileSize(File$) <= -1
  MessageRequester("Error", "The selected file doesn't seem to exist!", #PB_MessageRequester_Error)
  End 1 ; Exit with error
EndIf

; ==============================================================================
;                     Try Guessing PB Ver from DLL Filename                     
; ==============================================================================
; In case user as renamed "SyntaxHilighting.dll" to contain PB version

Filename$ = GetFilePart(File$, #PB_FileSystem_NoExtension)
Debug "Source DLL: "+ File$ ; DBG Filename

CreateRegularExpression(0, ".*5\.?(\d{2})")
If MatchRegularExpression(0, Filename$)
  ExamineRegularExpression(0, Filename$)
  NextRegularExpressionMatch(0)
  PBVersion$ = "5." + RegularExpressionGroup(0, 1)
  PBVersion  = Val("5"+RegularExpressionGroup(0, 1))
  Debug "PureBASIC Version (inferred): "+PBVersion$ +" ("+ Str(PBVersion) +")" ; DBG PB ver inferred
Else
  ; ------------------------------------------------------------------------------
  ;                            Couldn't Guess: Ask User                           
  ; ------------------------------------------------------------------------------
  CreateRegularExpression(1, "5\.?(\d{2})$")
  PROMPT_USER:
  UserResponse$ = InputRequester("PureBASIC Version",
                                 "PB Version number the DLL was taken from:",
                                 "560")
  If MatchRegularExpression(1, UserResponse$)
    ExamineRegularExpression(1, UserResponse$)
    NextRegularExpressionMatch(1)
    PBVersion$ = "5." + RegularExpressionGroup(1, 1)
    PBVersion  = Val("5"+RegularExpressionGroup(1, 1))
    Debug "PureBASIC Version (user input): "+PBVersion$ +" ("+ Str(PBVersion) +")" ; DBG PB ver user input
    FreeRegularExpression(1)
  Else
    ; String provided by User doesn't match a version number....
    ; ------------------------------------------------------------------------------
    MessageRequester("ERROR", ~"Wrong format. Please type the PB version only (eg: \"5.40\")", #PB_MessageRequester_Error)
    Goto PROMPT_USER
  EndIf
EndIf
FreeRegularExpression(0)

; ==============================================================================
;                          Load DLL Contents in Memory                          
; ==============================================================================

If Not ReadFile(0, File$)
  MessageRequester("ERROR", ~"Something went wrong while attempting to open the file:\n\""+ File$ +~"\"", #PB_MessageRequester_Error)
  End 1 ; Abort with Error Exit Code
EndIf

fileLen = Lof(0)
*BuffDLL = AllocateMemory(fileLen)
If *BuffDLL
  bytes = ReadData(0, *BuffDLL, fileLen)
EndIf
CloseFile(0)

; ==============================================================================
;                                Find Data Offset                               
; ==============================================================================
; Now with must parse the DLL's PE header to find the ".data" section, which is
; where the tokens are stored ...
; ------------------------------------------------------------------------------
; Find the offset of the ".data" string...
dataSectionTable_offset = FindStringInMemory(*BuffDLL, ".data")
If Not dataSectionTable_offset
  MessageRequester("ERROR", "Failed to find required data while parsing the DLL.", #PB_MessageRequester_Error)
  End 1
EndIf

; Let's get the offset of the relevant Table entries ...
SizeOfRawData_offset    = dataSectionTable_offset + 16
PointerToRawData_offset = dataSectionTable_offset + 20

; Now let's get the offset of the actual data...
RawData_offset = PeekL(*BuffDLL + PointerToRawData_offset)

; And the actual data lenght ...
SizeOfRawData = PeekL(*BuffDLL + SizeOfRawData_offset)

; ------------------------------------------------------------------------------
;                              Debug PE Header Info                             
; ------------------------------------------------------------------------------
; The user might want this info for inspecting the DLL with an hex editor.

#PAD = 25 ; <-- for debugging alignment
Debug ">> "+ LSet("'.data' Section offset", #PAD, ".") +
      "0x" + RSet(Hex(dataSectionTable_offset), 8, "0") ; DBG .data Section
Debug ">> "+ LSet("RawData offset",         #PAD, ".") +
      "0x" + RSet(Hex(RawData_offset),          8, "0") ; DBG RawData_offset
Debug ">> "+ LSet("SizeOfRawData",          #PAD, ".") +
      "0x" + RSet(Hex(SizeOfRawData),           8, "0") +" ("+ SizeOfRawData +" bytes)" ; DBG SizeOfRawData


; ==============================================================================
;                                 Extract Tokens                                
; ==============================================================================

; Create a List to store the tokens.
NewList tokens.s()

; From PureBASIC v5.50 onward the DLL stores string in Unicode (UCS2 LE)!
If PBVersion >= 550
  StrMode = #PB_Unicode
Else
  StrMode = #PB_Ascii
EndIf

; Create a RegEx for checking valid candidates for a tokens first letter
; (note: the "%" character is a valid ASM token, "-" is found in pseudotypes)
CreateRegularExpression(0, "[a-zA-Z%-]")

*memPos = *BuffDLL + RawData_offset ; <- Just a convenient shortcut pointer

For i = 0 To SizeOfRawData
  currChar = PeekA(*memPos + i)
  If MatchRegularExpression(0, Chr(currChar))
    ; ---------------------------------------------
    ; Current char is a valid candidate for a token
    ; ---------------------------------------------
    token$ = PeekS(*memPos + i, -1, StrMode)
    AddElement(tokens())
    tokens() = token$
    ; Debug to user the offset of the found token and the token string:
    Debug "0x"+ RSet(Hex(RawData_offset + i), 8, "0")+ " > "+ token$ ; DBG found token
    ; ---------------------------------------------------
    ; Adjust the counter to jump after matched string ...
    ; ---------------------------------------------------
    tokenLen = Len(token$)
    If StrMode = #PB_Unicode
      tokenLen * 2
    EndIf
    i + tokenLen - 1 ; <- "-1" because the coming "Next" will raise counter!
    ; ---------------------------------------------------------------
    ; We expect ASM's "XOR" token to be the last token in the DLL ...
    ; (after that we'd find unrelated strings and garbage)
    ; ---------------------------------------------------------------
    If token$ = "XOR"
      Break ; Exit the parsing loop ...
    EndIf
    
  EndIf 
Next ; <- i

FreeRegularExpression(0)

; ==============================================================================
;                              Write Tokens to File                             
; ==============================================================================

destFileName$ = "tokens-list-PB" + Str(PBVersion) + ".txt"

If Not CreateFile(0, destFileName$)
  MessageRequester("ERROR",
                   ~"Couldn't create the output file:\n"+ destFileName$,
                   #PB_MessageRequester_Error)
  End 1 ; Abort with Error Exit Code
EndIf

ForEach tokens()
  WriteStringN(0, tokens())
Next

CloseFile(0) 

; <== Main program ends here.

; ******************************************************************************
; *                                                                            *
; *                                 PROCEDURES                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
;                             Find String In Memory                             
; ==============================================================================
Procedure FindStringInMemory(*BufferID, targetStr.s)
  targetLen = Len(targetStr)
  bufferSize = MemorySize(*BufferID)
  ;---------------------------------
  ; Convert target string into Array
  ;---------------------------------
  Dim target.b(targetLen-1)
  For i = 0 To targetLen-1
    target(i) = Asc(Mid(targetStr, i+1, 1))
  Next
  ; -----------
  ; Search loop
  ; -----------
  For i = 0 To bufferSize
    currChar = PeekA(*BufferID + i)
    If currChar = target(0)
      ; ------------------------------------------------
      ; First char match found, let's check the rest ...
      ; ------------------------------------------------
      For j = 1 To targetLen-1
        nextChar = PeekA(*BufferID + i + j)
        If nextChar <> target(j)
          ; One of the following chars doesn't match ...
          Break ; <- Stop the inner comparing loop
        EndIf
      Next
      ; ----------------------------------------------------------------------
      ; If the j counter made it to full lenght of targetStr we have our match
      ; ----------------------------------------------------------------------
      If j = targetLen
        offset = i
        Break ; <- Stop searching
      EndIf
    EndIf
  Next
  ; If not match was found offset will be = 0
  ProcedureReturn offset
EndProcedure

