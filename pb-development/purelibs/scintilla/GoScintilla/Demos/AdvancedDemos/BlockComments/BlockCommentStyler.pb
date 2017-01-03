;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla 2***
;*===================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Block comment demo (C syntax).
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../../"
XIncludeFile "GoScintilla.pbi"


Declare.i myLineStyler(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
Declare.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER)


;Initialise the Scintilla library for Windows.
  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
    InitScintilla()
  CompilerEndIf

If OpenWindow(0, 100, 200, 600, 600, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_MaximizeGadget | #PB_Window_ScreenCentered | #PB_Window_SizeGadget | #PB_Window_Invisible)
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
        #STYLES_COMPILER
        #STYLES_LITERALSTRINGS
        #STYLES_NUMBERS
        #STYLES_FUNCTIONS
        #STYLES_FIELDS
      EndEnumeration

    ;Set individual styles for commands.
      GOSCI_SetStyleFont(1, #STYLES_COMMANDS, "", -1, #PB_Font_Bold)
      GOSCI_SetStyleColors(1, #STYLES_COMMANDS, $800000)  ;We have omitted the optional back color.

    ;Set individual styles for comments.
      GOSCI_SetStyleFont(1, #STYLES_COMMENTS, "", -1, #PB_Font_Italic)
      GOSCI_SetStyleColors(1, #STYLES_COMMENTS, $006400)  ;We have omitted the optional back color.

    ;Set individual styles for compiler directives etc..
      GOSCI_SetStyleColors(1, #STYLES_COMPILER, $2193DE)  ;We have omitted the optional back color.

    ;Set individual styles for literal strings.
      GOSCI_SetStyleColors(1, #STYLES_LITERALSTRINGS, #Gray)  ;We have omitted the optional back color.

    ;Set individual styles for numbers.
      GOSCI_SetStyleColors(1, #STYLES_NUMBERS, #Red)  ;We have omitted the optional back color.

    ;Set individual styles for functions.
      GOSCI_SetStyleColors(1, #STYLES_FUNCTIONS, #Blue)  ;We have omitted the optional back color.

    ;Set individual styles for fields.
      GOSCI_SetStyleColors(1, #STYLES_FIELDS, $2730D8)  ;We have omitted the optional back color.

  ;Set delimiters and keywords for our syntax highlighting.
  ;========================================================
    ;First some commands.
      GOSCI_AddKeywords(1, "auto bool break bstr case char const continue date default do double else enum", #STYLES_COMMANDS)
      GOSCI_AddKeywords(1, "extern float for goto hresult if int long lpwstr lpvoid register return short signed", #STYLES_COMMANDS)
      GOSCI_AddKeywords(1, "sizeof static struct switch typedef ulong union unsigned variant vartype void volatile while", #STYLES_COMMANDS)
    ;Delimiters.
      GOSCI_AddDelimiter(1, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
    ;Now set up a # symbol to denote a compiler directive.
      GOSCI_AddDelimiter(1, "#", "", #GOSCI_LEFTDELIMITWITHOUTWHITESPACE, #STYLES_COMPILER)
    ;Now set up a ( symbol to denote a function.
      GOSCI_AddDelimiter(1, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
    ;We arrange for a ) symbol to match the coloring of the ( symbol.
      GOSCI_AddDelimiter(1, ")", "", 0, #STYLES_FUNCTIONS)
    ;Now set up a . symbol to delimit structure members.
      GOSCI_AddDelimiter(1, ".", "", #GOSCI_LEFTDELIMITWITHWHITESPACE|#GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FIELDS)

    ;Add some folding keywords.
      GOSCI_AddKeywords(1, "{", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
      GOSCI_AddKeywords(1, "}", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD)


  ;Additional lexer options.
  ;=========================
    ;The lexer needs to know what separator characters we are using.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%[],{}&;|!>()")
    ;We can also set a style for numbers.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)


  ;Set our user-defined line styling function.
  ;===========================================
    GOSCI_SetLineStylingFunction(1, @MyLineStyler())
  
  
  ;Set some initial text. We load a c source file from disc.
  ;======================
    If ReadFile(1, "exampleSource.c")
      While Eof(1) = #False
        text$ = ReadString(1)
        GOSCI_InsertLineOfText(1, -1, text$, #False) ;#False means that only the visible lines will be styled (more or less!)
      Wend
      CloseFile(1)
    EndIf

  GOSCI_SetState(1, #GOSCI_RESTYLEDOCUMENT)

  HideWindow(0, 0)


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
      If numUtf8Bytes > 0
        ;We are now outside of a comment block. We now search for an opening /* comment marker on a symbol by symbol basis.
        ;All other symbols will be passed back to GoScintilla for styling.
          While numUtf8Bytes > 0
            *ptrAscii = *utf8Buffer
            If *ptrAscii\a = '/' And numUtf8Bytes > 1
              *ptrAscii + 1
              If *ptrAscii\a = '*' ;Open comment found.
                ;Apply the comment style to the /* symbol so as not to confuse our comment styler utility function below.
                  ScintillaSendMessage(id, #SCI_SETSTYLING, 2, #STYLES_COMMENTS)
                  numUtf8Bytes - 2
                  *utf8Buffer + 2
                blnIsEndOfPreviousLineCommented = #True ;Mark that, at this point, the end of the current line will be commented.
                Break
              EndIf
            EndIf
            numBytesStyled = GOSCI_StyleNextSymbol(id, *utf8Buffer, numUtf8Bytes)
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
Procedure.i myStylerUtility_StyleCommentPart(id, *utf8Buffer.ASCII, numUtf8Bytes, *ptrCommented.INTEGER)
  Protected numBytesToStyle, *ptrAscii.ASCII
  *ptrAscii = *utf8Buffer
  While numBytesToStyle < numUtf8Bytes
    numBytesToStyle + 1
    If *ptrAscii\a = '*' And numBytesToStyle < numUtf8Bytes
      *ptrAscii + 1
      If *ptrAscii\a = '/'
        numBytesToStyle + 1
        *ptrCommented\i = #False 
        Break
      EndIf
    Else
      *ptrAscii + 1      
    EndIf
  Wend
  If numBytesToStyle
    ;Do not apply the comment style to EOL characters. This will cause Scintilla to force us to restyle the entire document.
    ;Instead we will leave myLineStyler() to invoke the GOSCI_StyleNextSymbol() function in order to apply the default style.
      *ptrAscii-1
      While *ptrAscii\a = #LF Or *ptrAscii\a = #CR
        numBytesToStyle - 1
        *ptrAscii-1
        If numBytesToStyle = 0
          Break
        EndIf
      Wend
      If numBytesToStyle
        ScintillaSendMessage(id, #SCI_SETSTYLING, numBytesToStyle, #STYLES_COMMENTS)
      EndIf
  EndIf
  ProcedureReturn numBytesToStyle
EndProcedure
;/////////////////////////////////////////////////////////////////////////////////

; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 126
; FirstLine = 111
; Folding = -
; EnableUnicode
; EnableThread
; EnableXP
; Executable = d.exe.dll.exe.dll