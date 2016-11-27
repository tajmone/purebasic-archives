; ----------------------------------------------------------------------- ;
;  -- PureBasic Header Generator                                      --  ;
;  -- Copyright � 00laboratories 2013-2016                            --  ;
;  -- http://00laboratories.com/                                      --  ;
;  -- License: Creative Commons Attribution 4.0 International License --  ;
; ----------------------------------------------------------------------- ;
;XIncludeFile #PB_Compiler_File + "i" ;- PBHGEN

;XIncludeFile "Test.pb"

Structure ProgramData
  SourceFileName$         ; the name of the source file being read.
  HeaderFileName$         ; the name of the header file being written.
  SourceFileHandle.l      ; the file read handle of the source file.
  HeaderFileHandle.l      ; the file write handle of the header file.
  
  CurrentLineNumber.l     ; the line number of the line currently parsing.
  CurrentLine$            ; the line text currently being parsed.
  
  CurrentState.a          ; global state flag to identify where we are in syntax.
  
  ModuleName$             ; the name of the module when parsing a module.
  IsSpiderBasic.a         ; whether the source belongs to spider basic.
EndStructure
Global Program.ProgramData

Enumeration
  #PBHGEN_STATE_GLOBAL
  #PBHGEN_STATE_PROCEDURE
  #PBHGEN_STATE_MACRO
  #PBHGEN_STATE_MODULE_GLOBAL
  #PBHGEN_STATE_MODULE_PROCEDURE
  #PBHGEN_STATE_MODULE_MACRO
EndEnumeration

Program\CurrentLineNumber = 0
Program\CurrentState = #PBHGEN_STATE_GLOBAL

#PBHGEN_VERSION$ = "5.43"






Procedure ExplodeStringArray(Array a$(1), s$, delimeter$)
  Protected count, i
  count = CountString(s$,delimeter$); + 1
  Dim a$(count)
  For i = 1 To count +1
    a$(i - 1) = StringField(s$,i,delimeter$)
  Next
  ProcedureReturn count ;return count of substrings
EndProcedure






; Whenever the line ends with a comma you will want to do this.
Global ContinueNextLine.a = #False
Global Dim CodeLines$(0)
Global CodeLinesCount.l = 0

Procedure.s FilterArguments(Line$)
  NewL$ = ""
  IsInArguments.c = #False
  IsInString.c = #False
  IsAtUnwanted.c = #False
  Skipping.c = #False
  
  CheckDefaultType.c = #False
  FindDefaultType$ = ""
  
  ; Maybe this is line continuation
  If ContinueNextLine = #True
    IsInArguments = #True
  EndIf
  
  ; For each character in the line
  For i=1 To Len(Line$)
    NextChar.s = Mid(Line$, i, 1)
    
    ; Is in the arguments list
    If IsInArguments = #True
      
      If NextChar = Chr(34) ; quote
        If Not IsInString
          IsInString = #True
        Else
          IsInString = #False
        EndIf
      EndIf
      
      If Not IsInString And LCase(Right(NewL$, 5)) = "list "
        IsAtUnwanted = #True
        CheckDefaultType = #True
      EndIf
      
      If Not IsInString And LCase(Right(NewL$, 6)) = "array "
        IsAtUnwanted = #True
        CheckDefaultType = #True
      EndIf
      
      If Not IsInString And LCase(Right(NewL$, 4)) = "map "
        IsAtUnwanted = #True
        CheckDefaultType = #True
      EndIf
      
      If Not IsInString And NextChar = "*"
        IsAtUnwanted = #True
      EndIf
      
      If Not IsInString And NextChar = "." And IsAtUnwanted
        Skipping = #True
      EndIf
      
      If Not IsInString And NextChar = ","
        Skipping = #False
        IsAtUnwanted = #False
      EndIf
      
      If Not IsInString And NextChar = "="
        Skipping = #False
        IsAtUnwanted = #False
      EndIf
      
      If Not IsInString And NextChar = "("
        Skipping = #False
        If CheckDefaultType
          Select LCase(FindDefaultType$)
            Case ".b" : NewL$ + ".b"
            Case ".a" : NewL$ + ".a"
            Case ".c" : NewL$ + ".c"
            Case ".w" : NewL$ + ".w"
            Case ".u" : NewL$ + ".u"
            Case ".c" : NewL$ + ".c"
            Case ".l" : NewL$ + ".l"
            Case ".i" : NewL$ + ".i"
            Case ".f" : NewL$ + ".f"
            Case ".q" : NewL$ + ".q"
            Case ".d" : NewL$ + ".d"
            Case ".s" : NewL$ + ".s"
          EndSelect
          CheckDefaultType = #False
          FindDefaultType$ = ""
        EndIf
      EndIf
      
      If Not IsInString And NextChar = ")"
        Skipping = #False
      EndIf
      
      If Not IsInString And NextChar = ":" ; statement seperator
        Break
      EndIf
      
      If Not IsInString And NextChar = ";" ; comment
        Break
      EndIf
      
      If Not Skipping
        NewL$ + NextChar
      Else
        If CheckDefaultType
          FindDefaultType$ + NextChar
        EndIf
      EndIf
      
    EndIf
    
    ; Did not reach arguments yet
    If Not IsInArguments
      If NextChar = "("
        IsInArguments = #True
      EndIf
  
      NewL$ + NextChar
    EndIf
    
  Next
  
  If NextChar = ","
    ContinueNextLine = #True
  Else
    ContinueNextLine = #False
  EndIf
  
  If ContinueNextLine
    Program\CurrentLineNumber +1
    NewL$ + FilterArguments(CodeLines$(Program\CurrentLineNumber))
  EndIf
  
  ProcedureReturn NewL$
EndProcedure

; -----------------------------------------------------------------------------
; Output a string to the header file.
; -----------------------------------------------------------------------------
Procedure WriteHeader(Str$)
  WriteString(Program\HeaderFileHandle, Str$)
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this line is a comment otherwise false.
; -----------------------------------------------------------------------------
Procedure IsComment(Line$)
  If Len(Line$) > 0
    If Mid(Line$, 1, 1) = ";"
      ProcedureReturn #True
    EndIf
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is an empty line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsEmpty(Line$)
  If Len(Line$) = 0
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is a procedure statement line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsBeginProcedure(Line$)
  If Not Len(Line$) >= 10 : ProcedureReturn #False : EndIf ; don't bother when it's too small, speed!
  If LCase(Left(Line$, 10)) = "procedure " ; without return type
    ProcedureReturn #True
  EndIf
  If LCase(Left(Line$, 10)) = "procedure." ; with return type (whatever it may be)
    ProcedureReturn #True
  EndIf
  
  If LCase(Left(Line$, 11)) = "procedurec " ; without return type
    ProcedureReturn #True
  EndIf
  If LCase(Left(Line$, 11)) = "procedurec." ; with return type (whatever it may be)
    ProcedureReturn #True
  EndIf
  
  If LCase(Left(Line$, 13)) = "proceduredll " ; without return type
    ProcedureReturn #True
  EndIf
  If LCase(Left(Line$, 13)) = "proceduredll." ; with return type (whatever it may be)
    ProcedureReturn #True
  EndIf
  
  If LCase(Left(Line$, 14)) = "procedurecdll " ; without return type
    ProcedureReturn #True
  EndIf
  If LCase(Left(Line$, 14)) = "procedurecdll." ; with return type (whatever it may be)
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is an endprocedure statement line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsEndProcedure(Line$)
  If LCase(Left(Line$, 12)) = "endprocedure"
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is a module statement line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsBeginModule(Line$)
  If Not Len(Line$) >= 6 : ProcedureReturn #False : EndIf ; don't bother when it's too small, speed!
  If LCase(Left(Line$, 7)) = "module "
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is an endmodule statement line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsEndModule(Line$)
  If LCase(Left(Line$, 9)) = "endmodule"
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is a macro statement line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsBeginMacro(Line$)
  If Not Len(Line$) >= 6 : ProcedureReturn #False : EndIf ; don't bother when it's too small, speed!
  If LCase(Left(Line$, 6)) = "macro "
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Returns true when this is an endmacro statement line otherwise false.
; -----------------------------------------------------------------------------
Procedure IsEndMacro(Line$)
  If LCase(Left(Line$, 8)) = "endmacro"
    ProcedureReturn #True
  EndIf
  ProcedureReturn #False
EndProcedure

; -----------------------------------------------------------------------------
; Transforms procedure statement into appropriate declare statement.
; -----------------------------------------------------------------------------
Procedure.s ParseProcedure(Line$)
  If LCase(Left(Line$, 9)) = "procedure"
    ProcedureReturn "Declare" + Mid(Line$, 10)
  EndIf
  
  If LCase(Left(Line$, 10)) = "procedurec"
    ProcedureReturn "DeclareC" + Mid(Line$, 11)
  EndIf
  
  If LCase(Left(Line$, 12)) = "proceduredll"
    ProcedureReturn "DeclareDLL" + Mid(Line$, 13)
  EndIf
  
  If LCase(Left(Line$, 13)) = "procedurecdll"
    ProcedureReturn "DeclareCDLL" + Mid(Line$, 14)
  EndIf
  
  ProcedureReturn "ERROR" ; this can never happen I believe.
EndProcedure

; -----------------------------------------------------------------------------
; Returns the name of the module.
; -----------------------------------------------------------------------------
Procedure.s ParseModuleName(Line$)
  ProcedureReturn Trim(Mid(Line$, 7))
EndProcedure

; -----------------------------------------------------------------------------
; Parse the next line of the source file and output to the header file.
; -----------------------------------------------------------------------------
Procedure ParseLine(Line$)
  ; Line 0: Create header information.
  If Program\CurrentLineNumber = 0
    WriteHeader(";- PBHGEN V" + #PBHGEN_VERSION$ + " [http://00laboratories.com/]" + #CRLF$)
    WriteHeader(";- '" + GetFilePart(Program\SourceFileName$) + "' header, generated at " + FormatDate("%hh:%ii:%ss %dd.%mm.%yyyy", Date()) + "." + #CRLF$)
    WriteHeader(#CRLF$)
    WriteHeader("CompilerIf #PB_Compiler_Module = " + #DQUOTE$ + #DQUOTE$ + #CRLF$)
  Else
    ; Leave out empty lines regardless.
    If Not IsEmpty(Line$)
      
      ;WriteHeader("; RAW: " + Line$ + #CRLF$)
      Select Program\CurrentState
          
        Case #PBHGEN_STATE_GLOBAL
          ; Global -> Procedure
          If IsBeginProcedure(Line$)
            Program\CurrentState = #PBHGEN_STATE_PROCEDURE
            Line$ = ParseProcedure(Line$)
            Line$ = FilterArguments(Line$)
            WriteHeader(Line$ + #CRLF$)
          EndIf
          ; Global -> Module
          If IsBeginModule(Line$)
            Program\CurrentState = #PBHGEN_STATE_MODULE_GLOBAL
            Program\ModuleName$ = ParseModuleName(Line$)
            WriteHeader("CompilerEndIf" + #CRLF$ + "CompilerIf #PB_Compiler_Module = " + #DQUOTE$ + Program\ModuleName$ + #DQUOTE$ + #CRLF$)
          EndIf
          ; Global -> Macro
          If IsBeginMacro(Line$)
            Program\CurrentState = #PBHGEN_STATE_MACRO
          EndIf
          
        Case #PBHGEN_STATE_MACRO
          ; Global Macro -> EndMacro
          If IsEndMacro(Line$)
            Program\CurrentState = #PBHGEN_STATE_GLOBAL
          EndIf
          
        Case #PBHGEN_STATE_PROCEDURE
          ; Global Procedure -> EndProcedure
          If IsEndProcedure(Line$)
            Program\CurrentState = #PBHGEN_STATE_GLOBAL
          EndIf
          
        Case #PBHGEN_STATE_MODULE_GLOBAL
          ; Module -> Procedure
          If IsBeginProcedure(Line$)
            Program\CurrentState = #PBHGEN_STATE_MODULE_PROCEDURE
            Line$ = ParseProcedure(Line$)
            Line$ = FilterArguments(Line$)
            WriteHeader(Line$ + #CRLF$)
          EndIf
          ; Module -> EndModule
          If IsEndModule(Line$)
            Program\CurrentState = #PBHGEN_STATE_GLOBAL
            WriteHeader("CompilerEndIf" + #CRLF$ + "CompilerIf #PB_Compiler_Module = " + #DQUOTE$ + #DQUOTE$ + #CRLF$)
          EndIf
          ; Module -> Macro
          If IsBeginMacro(Line$)
            Program\CurrentState = #PBHGEN_STATE_MODULE_MACRO
          EndIf
          
        Case #PBHGEN_STATE_MODULE_MACRO
          ; Module -> EndMacro
          If IsEndMacro(Line$)
            Program\CurrentState = #PBHGEN_STATE_MODULE_GLOBAL
          EndIf
          
        Case #PBHGEN_STATE_MODULE_PROCEDURE
          ; Module -> EndProcedure
          If IsEndProcedure(Line$)
            Program\CurrentState = #PBHGEN_STATE_MODULE_GLOBAL
          EndIf
          
      EndSelect
      
    EndIf
    
  EndIf
  
  Program\CurrentLineNumber + 1
EndProcedure






; -----------------------------------------------------------------------------
If CountProgramParameters() = 1
  Program\SourceFileName$ = ProgramParameter(0)
Else
  Program\SourceFileName$ = ProgramParameter(0)
  For i=1 To CountProgramParameters() -1
    Program\SourceFileName$ + " " + ProgramParameter(i)
  Next
EndIf

If GetExtensionPart(Program\SourceFileName$) = "pb"
  Program\IsSpiderBasic = #False
ElseIf GetExtensionPart(Program\SourceFileName$) = "sb"
  Program\IsSpiderBasic = #True
Else
  End
EndIf

Program\HeaderFileName$ = Program\SourceFileName$ + "i"
; -----------------------------------------------------------------------------
Program\SourceFileHandle = ReadFile(#PB_Any, Program\SourceFileName$)
Program\HeaderFileHandle = CreateFile(#PB_Any, Program\HeaderFileName$)

If Program\SourceFileHandle And Program\HeaderFileHandle
  
  While Not Eof(Program\SourceFileHandle)
    Program\CurrentLine$ = ReadString(Program\SourceFileHandle)
    ; STOP: First we will seperate on colons to parse every "line" of code properly:
    Dim CodeChunks$(0)
    ExplodeStringArray(CodeChunks$(), Program\CurrentLine$, ":")
    
    ; While iterating below, if we encounter a comment then after each colon a semicolon must be added to keep it a comment.
    Define CommentDetected.a = #False
    
    ; Iterate through all new colon seperated lines:
    For i = 0 To ArraySize(CodeChunks$())
      ; Add line to collection:
      ReDim CodeLines$(CodeLinesCount)
      CodeLines$(CodeLinesCount) = Trim(CodeChunks$(i)) ; Trim whitespace from beginning / end of line.
      
      ; Remove "Runtime" keyword as it's not important.
      If LCase(Left(CodeChunks$(i), 8)) = "runtime "
        CodeLines$(CodeLinesCount) = Trim(Mid(CodeChunks$(i), 8)) ; Trim whitespace from beginning / end of line.
      EndIf
      
      ; Handle comments after a colon was detected.
      If IsComment(CodeLines$(CodeLinesCount))
        CommentDetected = #True
      EndIf
      If CommentDetected
        CodeLines$(CodeLinesCount) = ";" + CodeLines$(CodeLinesCount)
      EndIf
      
      CodeLinesCount +1
    Next
  Wend
  
  CloseFile(Program\SourceFileHandle)
  
  For i = 0 To CodeLinesCount -1
    ParseLine(CodeLines$(i))
  Next
  
  WriteHeader("CompilerEndIf")
  
  CloseFile(Program\HeaderFileHandle)
Else
  End ; Unable to access the files required.
EndIf
; IDE Options = PureBasic 5.43 LTS (Windows - x64)
; CursorPosition = 38
; Folding = ---
; EnableXP
; UseIcon = ..\_Resources [R]\Icons\headers.ico
; Executable = PBHGEN.exe
; Compiler = PureBasic 4.60 (Windows - x86)
; IncludeVersionInfo
; VersionField2 = 00laboratories
; VersionField3 = PB Header Generator
; VersionField6 = Generate PB Header
; VersionField9 = copyright ÃƒÆ’Ã¢â‚¬Å¡Ãƒâ€šÃ‚Â© 00laboratories 2013