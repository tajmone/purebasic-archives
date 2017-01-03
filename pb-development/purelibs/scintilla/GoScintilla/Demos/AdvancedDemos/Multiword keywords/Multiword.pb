;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla 2***
;*===================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Multiword keyword demo.
;*  We show how to use a user-defined line styling function to trap 'End Function' as a close-fold 'keyword'.
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../../"
XIncludeFile "GoScintilla.pbi"


Declare.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)


;Initialise the Scintilla library for Windows.
  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
    InitScintilla()
  CompilerEndIf

If OpenWindow(0, 100, 200, 600, 600, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered | #PB_Window_SizeGadget)
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
        #STYLES_LITERALSTRINGS
        #STYLES_NUMBERS
        #STYLES_FUNCTIONS
      EndEnumeration

    ;Set individual styles for commands.
      GOSCI_SetStyleFont(1, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
      GOSCI_SetStyleColors(1, #STYLES_COMMANDS, $800000)  ;We have omitted the optional back color.

    ;Set individual styles for literal strings.
      GOSCI_SetStyleColors(1, #STYLES_LITERALSTRINGS, #Gray)  ;We have omitted the optional back color.

    ;Set individual styles for numbers.
      GOSCI_SetStyleColors(1, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.

    ;Set individual styles for functions.
      GOSCI_SetStyleColors(1, #STYLES_FUNCTIONS, #Blue)  ;We have omitted the optional back color.

  ;Set delimiters and keywords for our syntax highlighting.
  ;========================================================
    ;First some commands.
      GOSCI_AddKeywords(1, "As ByVal End Function Integer", #STYLES_COMMANDS)
    ;Now set up quotes to denote literal strings. Note the space separating the pair of quotes from the pait of ' symbols.
      GOSCI_AddDelimiter(1, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
    ;Now set up a ( symbol to denote a function.
      GOSCI_AddDelimiter(1, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
    ;We arrange for a ) symbol to match the coloring of the ( symbol.
      GOSCI_AddDelimiter(1, ")", "", 0, #STYLES_FUNCTIONS)

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
    text$ + "Function test(ByVal a As Integer, ByVal b As Integer)" + #CRLF$ + #CRLF$
    text$ + "End Function" + #CRLF$
    
    GOSCI_SetText(1, text$)

  Repeat
    eventID = WaitWindowEvent()
    Select eventID
      Case #PB_Event_SizeWindow
        ResizeGadget(1, #PB_Ignore, #PB_Ignore, WindowWidth(0)-20, WindowHeight(0)-20)
      
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
Procedure.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
  Protected result = #GOSCI_STYLELINESASREQUIRED, numBytesStyled, symbolJustStyled$, lastSymbolStyled$
  ;Need to loop through the UTF-8 buffer invoking GoScintilla's styling lexer as appropriate.
    While numUtf8Bytes
      numBytesStyled = GOSCI_StyleNextSymbol(id, *utf8Buffer, numUtf8Bytes)
      numUtf8Bytes - numBytesStyled
      ;Examine the symbol just styled.
        If numBytesStyled
          symbolJustStyled$ = LCase(PeekS(*utf8Buffer, numBytesStyled, #PB_UTF8))
          If symbolJustStyled$ = "function"
            ;Was the previous symbol "end" ? If so, we decrease the current line's fold level as appropriate for a close-fold keyword.
            ;Otherwise, we increment the fold level as appropriate for an open-fold keyword.
              If lastSymbolStyled$ = "end"
                GOSCI_DecFoldLevel(id)
              Else
                GOSCI_IncFoldLevel(id)              
              EndIf      
          EndIf
          ;If the current symbol is not a stream of whitespace characters (space or #TAB) then record it in the lastSymbolStyled$.
            If *utf8Buffer\a <> 32 And *utf8Buffer\a <> 9
              lastSymbolStyled$ = symbolJustStyled$
            EndIf
        EndIf
      *utf8Buffer + numBytesStyled
    Wend
  ProcedureReturn result
EndProcedure
;/////////////////////////////////////////////////////////////////////////////////


; IDE Options = PureBasic 4.61 Beta 1 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 13
; Folding = -
; EnableUnicode
; EnableThread
; EnableXP
; Executable = d.exe.dll.exe.dll