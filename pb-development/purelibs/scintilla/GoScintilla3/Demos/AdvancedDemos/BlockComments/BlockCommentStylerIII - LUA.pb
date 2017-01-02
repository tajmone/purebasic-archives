;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla 2***
;*===================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Block comment III demo (very basic LUA block comment and string syntax).
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../../"
XIncludeFile "GoScintilla.pbi"


;First define some constants to identify our various styles.
;You can name these as we wish.
  Enumeration
    #STYLES_COMMENTS = 1
    #STYLES_LITERALSTRINGS
    #STYLES_NUMBERS
  EndEnumeration

Declare.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
Declare.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER=0, styleToUse = #STYLES_COMMENTS)


Structure _readData
  StructureUnion
    a.a
    u.u  
    l.l
  EndStructureUnion
EndStructure

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
    ;Set individual styles for comments.
      GOSCI_SetStyleFont(1, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
      GOSCI_SetStyleColors(1, #STYLES_COMMENTS, $006400)  ;We have omitted the optional back color.

    ;Set individual styles for literal strings.
      GOSCI_SetStyleColors(1, #STYLES_LITERALSTRINGS, #Blue)  ;We have omitted the optional back color.

    ;Set individual styles for numbers.
      GOSCI_SetStyleColors(1, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.

  ;Additional lexer options.
  ;=========================
    ;The lexer needs to know what separator characters we are using.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/[]") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
    ;We can also set a style for numbers.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)

  ;Set our user-defined line styling function.
  ;===========================================
    GOSCI_SetLineStylingFunction(1, @MyLineStyler())

  ;Set some initial text.
  ;======================
    text$ = "--[[ A simple demo utilising a user-defined line styling function." + #CRLF$
    text$ + "Shows how to trap various LUA constructs!]]" + #CRLF$ + #CRLF$
    text$ + "Let x$ = [[Heyho!]] --A simple assignment." + #CRLF$
    
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
  Protected result = #GOSCI_STYLELINESASREQUIRED, blnIsEndOfPreviousLineCommented, numBytesToStyle, numBytesStyled, *ptrAscii.ASCII
  Protected blnLastSymbolAValidStarter = #True, *ptrData._readData
  ;Is the end of the previous line commented? (We store a flag to indicate this in the line data.)
    If currentLine > 0
      blnIsEndOfPreviousLineCommented = GOSCI_GetLineData(id, currentLine-1)
    EndIf
  ;Need to loop through the UTF-8 buffer, alternating between styling comments and invoking GoScintilla's styling lexer as appropriate.
    While numUtf8Bytes
      If blnIsEndOfPreviousLineCommented
        numBytesStyled = myStylerUtility_StyleCommentPart(id, *utf8Buffer, numUtf8Bytes, @blnIsEndOfPreviousLineCommented)
        numUtf8Bytes - numBytesStyled
        *utf8Buffer + numBytesStyled
      EndIf
      blnLastSymbolAValidStarter = #True
      If numUtf8Bytes > 0
        ;We are now outside of a comment block. We now search for an opening comment block marker on a symbol by symbol basis.
        ;All other symbols will be passed back to GoScintilla for styling.
          While numUtf8Bytes > 0
            numBytesStyled = 0
            *ptrData = *utf8Buffer
            If numUtf8Bytes >= 4 And *ptrData\l = $5B5B2D2D ;'--[['
              ;Apply the comment style to the --[[ symbol so as not to confuse our comment styler utility function below.
                ScintillaSendMessage(id, #SCI_SETSTYLING, 4, #STYLES_COMMENTS)
                numUtf8Bytes - 4
                *utf8Buffer + 4
                blnIsEndOfPreviousLineCommented = #True ;Mark that, at this point, the end of the current line will be commented.
                Break
            ElseIf numUtf8Bytes >=2
              If *ptrData\u = $2D2D ;'--'
                numBytesStyled = numUtf8Bytes
                ;Do not apply the comment style to EOL characters as this can cause problems.
                  *ptrData + numUtf8Bytes - 1
                  While *ptrData\a = #LF Or *ptrData\a = #CR
                    *ptrData - 1
                    numBytesStyled - 1
                  Wend
                  ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesStyled, #STYLES_COMMENTS)
              ElseIf *ptrData\u = $5B5B ;'[['
                numBytesStyled = myStylerUtility_StyleCommentPart(id, *utf8Buffer, numUtf8Bytes, 0, #STYLES_LITERALSTRINGS)
              EndIf
            EndIf
            If numBytesStyled = 0
              If *ptrData\a = 9 Or *ptrData\a = 32
                blnLastSymbolAValidStarter = #True
              Else
                blnLastSymbolAValidStarter = #False
              EndIf
              numBytesStyled = GOSCI_StyleNextSymbol(id, *utf8Buffer, numUtf8Bytes)    
            EndIf
            numUtf8Bytes - numBytesStyled
            *utf8Buffer + numBytesStyled
          Wend
      EndIf
    Wend
  ;Mark the current line as appropriate, depending upon whether it is an open ended comment.
    If GOSCI_GetLineData(id, currentLine) <> blnIsEndOfPreviousLineCommented
      GOSCI_SetLineData(id, currentLine, blnIsEndOfPreviousLineCommented)
      result = #GOSCI_STYLENEXTLINEREGARDLESS
    EndIf
  ProcedureReturn result
EndProcedure
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;A utility function called by our main line styler above to apply the comment style to any part of a line which is commented.
;Returns the number of bytes styled.
Procedure.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER=0, styleToUse = #STYLES_COMMENTS)
  Protected numBytesToStyle, *ptrData._readData
  *ptrData = *utf8Buffer
  While numBytesToStyle < numUtf8Bytes
    numBytesToStyle + 1
    If numBytesToStyle < numUtf8Bytes And *ptrData\u = $5D5D ;']]'
      numBytesToStyle + 1
      If *ptrCommented
        *ptrCommented\i = #False 
      EndIf
      Break
    Else
      *ptrData + 1      
    EndIf
  Wend
  If numBytesToStyle
    ;Do not apply the comment style to EOL characters. This will cause Scintilla to force us to restyle the entire document.
    ;Instead we will leave myLineStyler() to invoke the GOSCI_StyleNextSymbol() function in order to apply the default style.
      *ptrData-1
      While *ptrData\a = #LF Or *ptrData\a = #CR
        numBytesToStyle - 1
        *ptrData-1
        If numBytesToStyle = 0
          Break
        EndIf
      Wend
      If numBytesToStyle
        ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesToStyle, styleToUse)
      EndIf
  EndIf
  ProcedureReturn numBytesToStyle
EndProcedure
;/////////////////////////////////////////////////////////////////////////////////

; IDE Options = PureBasic 4.61 Beta 1 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 12
; Folding = -
; EnableUnicode
; EnableThread
; EnableXP
; Executable = d.exe.dll.exe.dll