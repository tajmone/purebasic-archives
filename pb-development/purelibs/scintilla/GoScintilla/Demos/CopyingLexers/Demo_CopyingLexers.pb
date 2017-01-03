;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla 2***
;*=================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Copying a lexer demo program.

;*This demo shows how to copy 'all' lexer settings from one control to another.
;*Simply use the GOSCI_CopyLexerFromExistingControl(ID, sourceID) function to have all lexer related settings copied
;*from sourceID to ID. 
;*
;*Note that marker information is not copied. This means, for example, that folding symbols' colors are not copied.
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../"
XIncludeFile "GoScintilla.pbi"


;Initialise the Scintilla library for Windows.
  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
    InitScintilla()
  CompilerEndIf


If OpenWindow(0, 100, 200, 600, 640, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  RemoveKeyboardShortcut(0, #PB_Shortcut_Tab) ;Required for the tab key to function correctly when the Scintilla control has the focus.
  ButtonGadget(0, 10, 10, 80, 20, "Clone lexer...")
  ;Create our Scintilla control. Note that we do not specify a callback; this is optional for GoSctintilla.
    GOSCI_Create(1, 10, 40, 580, 285, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
    GOSCI_Create(2, 10, 345, 580, 285, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)
  ;Set the padding added to the width of the line-number margin.
    GOSCI_SetAttribute(1, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)
    GOSCI_SetAttribute(2, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)

  ;Set folding symbols margin width.
    GOSCI_SetMarginWidth(1, #GOSCI_MARGINFOLDINGSYMBOLS, 24)
    GOSCI_SetMarginWidth(2, #GOSCI_MARGINFOLDINGSYMBOLS, 24)

  ;Set the back color of the line containing the caret.
    GOSCI_SetColor(1, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)
    GOSCI_SetColor(2, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)

  ;Set font.
    GOSCI_SetFont(1, "Courier New", 10)
    GOSCI_SetFont(2, "Courier New", 10)

  ;Set tabs. Here we use a 'hard' tab in which a tab character is physically inserted. Set the 3rd (optional) parameter to 1 to use soft-tabs.
    GOSCI_SetTabs(1, 2)
    GOSCI_SetTabs(2, 2)

  ;Set styles for our syntax highlighting.
  ;=======================================
    ;First define some constants to identify our various styles.
    ;You can name these as we wish.
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
    ;Delimiters.
    ;First set up a ; symbol to denote a comment. Note the use of #GOSCI_DELIMITTOENDOFLINE.
    ;Note also that this symbol will act as an additional separator.
      GOSCI_AddDelimiter(1, ";", "", #GOSCI_DELIMITTOENDOFLINE, #STYLES_COMMENTS)
    ;Now set up quotes to denote literal strings.
    ;We do this by passing the beginning and end delimiting characters; in this case both are quotation marks. Note the use of #GOSCI_DELIMITBETWEEN.
    ;Note also that a quote will subsequently act as an additional separator.
      GOSCI_AddDelimiter(1, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
    ;Now set up a # symbol to denote a constant. Note the use of #GOSCI_LEFTDELIMITWITHOUTWHITESPACE.
      GOSCI_AddDelimiter(1, "#", "", #GOSCI_LEFTDELIMITWITHOUTWHITESPACE, #STYLES_CONSTANTS)
    ;Now set up a ( symbol to denote a function. Note the use of #GOSCI_RIGHTDELIMITWITHWHITESPACE.
      GOSCI_AddDelimiter(1, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
    ;We arrange for a ) symbol to match the coloring of the ( symbol.
      GOSCI_AddDelimiter(1, ")", "", 0, #STYLES_FUNCTIONS)

    ;Basic command keywords.
      GOSCI_AddKeywords(1, "Debug End If ElseIf Else EndIf For To Next Step Protected ProcedureReturn", #STYLES_COMMANDS)

    ;Add some folding keywords.
      GOSCI_AddKeywords(1, "Procedure Macro", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
      GOSCI_AddKeywords(1, "EndProcedure EndMacro", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD)

  ;Additional lexer options.
  ;=========================
    ;The lexer needs to know what separator characters we are using.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
    ;We can also set a style for numbers.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)
      
  ;Set some initial text.
  ;======================
    text$ = "; GoScintilla 2.0." + #CRLF$
    text$ + "#MyConstant$ = " + Chr(34) + "Version = 1.0" + Chr(34) + #CRLF$ + #CRLF$
    text$ + "Procedure.i AddIntegers(a, b)" + #CRLF$
    text$ + #TAB$ + "Protected result" + #CRLF$
    text$ + #TAB$ + "result = a + b  ; Calculate the sum of the 2 integers." + #CRLF$
    text$ + #TAB$ + "ProcedureReturn result" + #CRLF$
    text$ + "EndProcedure" + #CRLF$ + #CRLF$
    text$ + "Debug " + Chr(34) + "The sum of 10 and 20 is " + Chr(34) + " + Str(AddIntegers(10, 20))" + #CRLF$ + #CRLF$
    text$ + "End" + #CRLF$
    
    GOSCI_SetText(1, text$)
    GOSCI_SetText(2, text$)

  Repeat
    eventID = WaitWindowEvent()
    Select eventID
      Case #PB_Event_Gadget
        Select EventGadget()
          Case 0
            ;Copy the lexer settings from control 1 to control 2.
            GOSCI_CopyLexerFromExistingControl(2, 1)
        EndSelect
    EndSelect
  Until eventID = #PB_Event_CloseWindow 

  ;Free the Scintilla gadgets.
  ;This needs explicitly calling in order to free resources used by GoScintilla.
    GOSCI_Free(1)
    GOSCI_Free(2)
EndIf


; IDE Options = PureBasic 4.61 Beta 1 (Windows - x86)
; CursorPosition = 18
; EnableXP
; Executable = t.exe