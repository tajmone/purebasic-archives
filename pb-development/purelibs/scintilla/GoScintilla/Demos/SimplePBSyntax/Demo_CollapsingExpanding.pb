;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla***
;*=================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Collapsing/expanding items through code.
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../"
XIncludeFile "GoScintilla.pbi"


  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows
    InitScintilla()
  CompilerEndIf

If OpenWindow(0, 100, 200, 600, 600, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  RemoveKeyboardShortcut(0, #PB_Shortcut_Tab) ;Required for the tab key to function correctly when the Scintilla control has the focus.

    GOSCI_Create(1, 10, 40, 580, 550, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
    ButtonGadget(10, 0, 10, 150, 20, "COLLAPSE ALL ITEMS!")
    ButtonGadget(11, 180, 10, 150, 20, "EXPAND ALL ITEMS!")

    GOSCI_SetAttribute(1, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)

    GOSCI_SetMarginWidth(1, #GOSCI_MARGINFOLDINGSYMBOLS, 24)

    GOSCI_SetColor(1, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)

    GOSCI_SetFont(1, "Courier New", 10)

    GOSCI_SetTabs(1, 2)

  ;Set styles for our syntax highlighting.
  ;=======================================
      Enumeration
        #STYLES_COMMANDS = 1
        #STYLES_COMMENTS
        #STYLES_LITERALSTRINGS
        #STYLES_NUMBERS
        #STYLES_CONSTANTS
        #STYLES_FUNCTIONS
      EndEnumeration

    ;Set individual styles for commands.
      GOSCI_SetStyleFont(1, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
      GOSCI_SetStyleColors(1, #STYLES_COMMANDS, $800000)  ;We have omitted the optional back color.

    ;Set individual styles for comments.
      GOSCI_SetStyleFont(1, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
      GOSCI_SetStyleColors(1, #STYLES_COMMENTS, $006400)  ;We have omitted the optional back color.

    ;Set individual styles for literal strings.
      GOSCI_SetStyleColors(1, #STYLES_LITERALSTRINGS, #Gray)  ;We have omitted the optional back color.

    ;Set individual styles for numbers.
      GOSCI_SetStyleColors(1, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.

    ;Set individual styles for constants.
      GOSCI_SetStyleColors(1, #STYLES_CONSTANTS, $2193DE)  ;We have omitted the optional back color.

    ;Set individual styles for functions.
      GOSCI_SetStyleColors(1, #STYLES_FUNCTIONS, #Blue)  ;We have omitted the optional back color.

  ;Set delimiters and keywords for our syntax highlighting.
  ;========================================================
    GOSCI_AddDelimiter(1, ";", "", #GOSCI_DELIMITTOENDOFLINE, #STYLES_COMMENTS)
    GOSCI_AddDelimiter(1, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
    GOSCI_AddDelimiter(1, "#", "", #GOSCI_LEFTDELIMITWITHOUTWHITESPACE, #STYLES_CONSTANTS)
    GOSCI_AddDelimiter(1, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
    GOSCI_AddDelimiter(1, ")", "", 0, #STYLES_FUNCTIONS)

    GOSCI_AddKeywords(1, "Debug End If ElseIf Else EndIf For To Next Step Protected ProcedureReturn", #STYLES_COMMANDS)

    ;Add some folding keywords.
      GOSCI_AddKeywords(1, "Procedure Macro", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
      GOSCI_AddKeywords(1, "EndProcedure EndMacro", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD)

  ;Additional lexer options.
  ;=========================
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)

  ;Set some initial text.
  ;======================
    text$ = "; GoScintilla." + #CRLF$
    text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
    text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
    text$ + #TAB$ + "Protected result" + #CRLF$
    text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
    text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
    text$ + "EndProcedure" + #CRLF$ + #CRLF$
    text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
    text$ + "End" + #CRLF$
    text$ + "; GoScintilla." + #CRLF$
    text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
    text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
    text$ + #TAB$ + "Protected result" + #CRLF$
    text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
    text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
    text$ + "EndProcedure" + #CRLF$ + #CRLF$
    text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
    text$ + "End" + #CRLF$
    text$ + "; GoScintilla." + #CRLF$
    text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
    text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
    text$ + #TAB$ + "Protected result" + #CRLF$
    text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
    text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
    text$ + "EndProcedure" + #CRLF$ + #CRLF$
    text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
    text$ + "End" + #CRLF$
    text$ + "; GoScintilla." + #CRLF$
    text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
    text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
    text$ + #TAB$ + "Protected result" + #CRLF$
    text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
    text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
    text$ + "EndProcedure" + #CRLF$ + #CRLF$
    text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
    text$ + "End" + #CRLF$
   
    GOSCI_SetText(1, text$)

  Repeat
    eventID = WaitWindowEvent()
    Select eventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 10 ;Collapse all items.
            For I=0 To ScintillaSendMessage(1, #SCI_GETLINECOUNT)-1
              If ScintillaSendMessage(1, #SCI_GETFOLDLEVEL, I) & #SC_FOLDLEVELHEADERFLAG
                If ScintillaSendMessage(1, #SCI_GETFOLDEXPANDED, I)
                  ScintillaSendMessage(1, #SCI_TOGGLEFOLD, I)
                EndIf
              EndIf
            Next
          Case 11 ;Expand all items.
            For I=0 To ScintillaSendMessage(1, #SCI_GETLINECOUNT)-1
              If ScintillaSendMessage(1, #SCI_GETFOLDLEVEL, I) & #SC_FOLDLEVELHEADERFLAG
                If ScintillaSendMessage(1, #SCI_GETFOLDEXPANDED, I) = 0
                  ScintillaSendMessage(1, #SCI_TOGGLEFOLD, I)
                EndIf
              EndIf
            Next
        EndSelect
    EndSelect
  Until eventID = #PB_Event_CloseWindow

  ;Free the Scintilla gadget.
    GOSCI_Free(1)
EndIf
; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 133
; FirstLine = 114
; EnableUnicode
; EnableThread
; EnableXP
; Executable = t.exe