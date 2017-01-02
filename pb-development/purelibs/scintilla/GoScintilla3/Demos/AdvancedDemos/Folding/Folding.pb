;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla 2***
;*===================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Folding demo.
;*  We show how to use a user-defined line styling function to enable a ' symbol to be recognised as a comment (similar to a #GOSCI_DELIMITTOENDOFLINE delimiter)
;*  and to also utilise '{ and '} as open/close folding keywords as well. 
;*  GoScintilla 2 cannot deal with this without our assistance because marking ' as a delimiter subsequently prevents '{ being
;*  recognised as a keyword because the ' symbol will act as a separator.
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../../"
XIncludeFile "GoScintilla.pbi"


Declare.i myLineStyler(id, *utf8Buffer.UNICODE, numUtf8Bytes, currentLine, startLine, originalEndLine)


;Initialise the Scintilla library for Windows.
  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
    InitScintilla()
  CompilerEndIf

If OpenWindow(0, 100, 200, 600, 600, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  RemoveKeyboardShortcut(0, #PB_Shortcut_Tab) ;Required for the tab key to function correctly when the Scintilla control has the focus.
  ;Create our Scintilla control. Note that we do not specify a callback; this is optional for GoSctintilla.
    GOSCI_Create(1, 10, 10, 580, 580, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)

  ;Set the padding added to the width of the line-number margin.
    GOSCI_SetAttribute(1, #GOSCI_LINENUMBERAUTOSIZEPADDING, 10)

  ;Set folding symbols margin width.
    GOSCI_SetMarginWidth(1, #GOSCI_MARGINFOLDINGSYMBOLS, 24)

  ;Set the back color of the line containing the caret.
    GOSCI_SetColor(1, #GOSCI_CARETLINEBACKCOLOR, $B4FFFF)

  ;Set font.
    GOSCI_SetFont(1, "Courier New", 10)

  ;Set tabs. Here we use a 'hard' tab in which a tab character is physically inserted. Set the 3rd (optional) parameter to 1 to use soft-tabs.
    GOSCI_SetTabs(1, 2)

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
    ;First set up a ' symbol to denote a comment. Note the use of #GOSCI_DELIMITTOENDOFLINE.
    ;Note also that this symbol will act as an additional separator.
      GOSCI_AddDelimiter(1, "'", "", #GOSCI_DELIMITTOENDOFLINE, #STYLES_COMMENTS)
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
      GOSCI_AddKeywords(1, "Debug End If ElseIf Else EndIf EndProcedure For To Next Repeat Step Procedure Protected ProcedureReturn Until", #STYLES_COMMANDS)

  ;Additional lexer options.
  ;=========================
    ;The lexer needs to know what separator characters we are using.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%()[],.") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
    ;We can also set a style for numbers.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)

  ;Set our user-defined line styling function.
  ;===========================================
    GOSCI_SetLineStylingFunction(1, @MyLineStyler())
    
    ;Set some initial text.
  ;======================
    text$ = "' GoScintilla 2.0." + #CRLF$
    text$ + "If OpenWindow(0, 100, 200, 195, 260, " + Chr(34) + "PureBasic Window" + Chr(34) + ", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget)" + #CRLF$
    text$ + "'{" + #CRLF$
    text$ + #TAB$ + "Repeat" + #CRLF$ 
    text$ + #TAB$ + #TAB$ + "eventID = WaitWindowEvent()" + #CRLF$
    text$ + #TAB$ + "Until eventID = #PB_Event_CloseWindow" + #CRLF$
    text$ + "'}" + #CRLF$ + #CRLF$
    text$ + "EndIf" + #CRLF$
    text$ + "End" + #CRLF$
    
    GOSCI_SetText(1, text$)

  Repeat
    eventID = WaitWindowEvent()
    Select eventID
      Case #PB_Event_Gadget
        Select EventGadget()
        EndSelect
    EndSelect
  Until eventID = #PB_Event_CloseWindow 

  ;Free the Scintilla gadget.
  ;This needs explicitly calling in order to free resources used by GoScintilla.
    GOSCI_Free(1)
EndIf


;/////////////////////////////////////////////////////////////////////////////////
;The following is our user-defined line-styling function, called whenever GoScintilla is called upon to style lines.
Procedure.i myLineStyler(id, *utf8Buffer.UNICODE, numUtf8Bytes, currentLine, startLine, originalEndLine)
  Protected result = #GOSCI_STYLELINESASREQUIRED, numBytesStyled, symbolJustStyled$, left$
  ;Need to loop through the UTF-8 buffer invoking GoScintilla's styling lexer as appropriate.
    While numUtf8Bytes
      numBytesStyled = GOSCI_StyleNextSymbol(id, *utf8Buffer, numUtf8Bytes)
      numUtf8Bytes - numBytesStyled
      ;Examine the symbol just styled.
        If numBytesStyled >= 2
          If *utf8Buffer\u = $7B27        ;'{
            GOSCI_IncFoldLevel(id)
          ElseIf *utf8Buffer\u = $7D27    ;'}
            GOSCI_DecFoldLevel(id)
          EndIf
        EndIf
      *utf8Buffer + numBytesStyled
    Wend
  ProcedureReturn result
EndProcedure
;/////////////////////////////////////////////////////////////////////////////////


; IDE Options = PureBasic 4.61 Beta 1 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 16
; Folding = -
; EnableThread
; EnableXP
; Executable = d.exe.dll.exe.dll