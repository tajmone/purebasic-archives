EnableExplicit
CompilerIf Defined(INCLUDE_GOSCINTILLA, #PB_Constant)=0
  #INCLUDE_GOSCINTILLA=1
  ;/////////////////////////////////////////////////////////////////////////////////
  ; ==============================================================================
  ;                                GoScintilla 3.0.1                                
  ; ==============================================================================
  ; Minimum version of Purebasic required: 5.10
  ; ------------------------------------------------------------------------------
  ; © nxSoftWare (www.nxSoftware.com) 2010.
  ; Released under the *WTFPL (Do What the Fuck You Want to Public License) license terms:
  ; - http://www.wtfpl.net/
  ; ------------------------------------------------------------------------------
  ; GoScintilla 3 is maintained by Tristano Ajmone on GitHub:
  ; - https://github.com/tajmone/purebasic-archives
  ; ------------------------------------------------------------------------------
  ;*  Thanks to ts-soft for his ScintillaHelper library upon which this is, in some part, based.
  ;*  Thanks also to Peyman for examples on implementing code-completion and call-tips.
  ;*  Thanks to Tenaja for making the adjustments for version 2.5.
  ;*
  ;*  Originally created with Purebasic 4.61 for Windows.
  ;*
  ;*  Platforms:  All (though code completion and call-tips probably will not work on MacOSX).
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;*NOTES.
  ;
  ; i)      This helper-library allows easy access to syntax highlighting, code-completion etc.
  ;
  ; ii)     Uses Purebasic's Scintilla library, which, under Windows, requires initialising with InitScintilla().
  ;
  ; iii)    Individual Scintilla gadgets created with this library should not be accessed by multiple-threads at the same time. Not without mutex protection anyhow.
  ;
  ; iv)     This uses the #SC_CP_UTF8 (UTF-8) code-page.
  ;
  ; v)      Do not use Get/SetGadgetData() with Scintilla gadgets created through this library.
  ;         Use GOSCI_Get/GOSCI_SetUseData() instead.
  ;
  ; vi)     All 'keywords' (used by the syntax lexer) must contain only Ascii characters. Unicode characters can appear in comments and literal strings only.
  ;
  ; vii)    Use the GOSCI_SetLineStylingFunction() function to use your own lexer/styler. See the default function for details on how to construct
  ;         your own function.
  ;
  ;         If using your own function to style individual lines then you will need to use certain Scintilla functions to style the
  ;         different lexical entities making up the line.
  ;
  ; viii)   Margin #GOSCI_MARGINNONFOLDINGSYMBOLS and marker index 0 is used for bookmarks.
  ;         If you wish to use additional markers then use numbers 1 to 31 with one of the user margins : #GOSCI_MARGINUSER1 or #GOSCI_MARGINUSER2.
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-INCLUDES.
  
  XIncludeFile "GoScintilla_HeaderFile.pbi"
  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-CONSTANTS.
  
  #GOSCI_DEFAULTCODECOMPLETIONCHARS = 3
  #GOSCI_BOOKMARKMARKERNUM          = 0
  #GOSCI_ERRORMARKERNUM             = 1
  
  ;Used to separate the delimiter constants from the folding ones.
  #GOSCI_KEYWORDDELIMITERMASK = $FFFFF
  
  #GOSCI_NUMNESTEDCALLTIPS = 100  ;Gives the upper bound of an array of keyword pointers.
  
  CompilerIf #PB_Compiler_OS = #PB_OS_Linux
    #White = 16777215
    #Gray = 8421504
    #Red = 255
    #Blue = 16711680
  CompilerEndIf
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-PROTOTYPES.
  Prototype GOSCI_proto_Callback(id, *scinotify.SCNotification)
  
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-STRUCTURES.
  
  ;The following structure holds information (such as syntax highlighting info) on individual Scintilla controls.
  Structure _GoScintilla
    ;Creation fields.
    id.i
    callback.GOSCI_proto_Callback
    flags.i
    state.i
    ;Custom line styling function.
    stylingFunction.GOSCI_proto_StyleLine
    ;Additional user-supplied data.
    userData.i
    lineNumberAutoSizePadding.i
    lexerSeparators$
    lexerNumbersStyleIndex.i
    ;Lists/maps.
    List keywords.GoScintillaKeyword()
    Map keywordPtr.i()
    ;Code folding.
    blnLineCodeFoldOption.i     ;0 = no code folding, 1 = open fold, 2 = close fold.
    foldLevel.i
    ;Styling.
    previouslyRecordedStyle.i   ;Used for left delimiters (separators).
    *bytePointer                ;Used for left delimiters (separators).
                                ;Code completion.
    codeCompletionChars.i       ;Number of characters required to instigate code completion.
                                ;Call-tips.
    lastStartPos.i
    callTipLine.i
    lastCallTipIndex.i
    ;Miscellaneous.
    blnSpaceAdded.i
  EndStructure
  
  ;The following structure is used to deal with call-tips.
  Structure _GoScintillaCallTips
    *keyword.GoScintillaKeyword
    charPos.i
    previousCloseCalltipSeparator.a
  EndStructure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;-DECLARES.
  
  Declare.i GOSCI_IsSeparatorXXX(*this._GoScintilla, symbol.a, *keyword.INTEGER)
  Declare.i GOSCI_GetKeywordInfo(id, keyWord$)
  Declare.i GOSCI_StyleNextSymbolXXX(*this._GoScintilla, *bytePtr.ASCII, numBytesRemaining, blnDoNotApplyStyle=#False, *keywordBuffer.INTEGER=0, *PtrIsWhiteSpace.INTEGER=0)
  Declare GOSCI_SetStyleFont(id, styleIndex, fontName$, fontSize=-1, fontStyle=-1)
  Declare GOSCI_SetState(id, stateType, value=0)
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  
  ;-INTERNAL FUNCTIONS.
  ;-=====================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following internal function adjusts the line number margin in the case that the #GOSCI_AUTOSIZELINENUMBERSMARGIN creation flag was set.
  Procedure GOSCI_AutosizeLineNumberMarginXXX(id)
    Protected *this._GoScintilla, numLines, numChars, t1, utf8Buffer
    *this = GetGadgetData(id)
    If *this And *this\flags & #GOSCI_AUTOSIZELINENUMBERSMARGIN
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      numChars = Len(Str(numLines))
      ;Fill a UTF-8 buffer with the appropriate number of '9' 's.
      utf8Buffer = AllocateMemory(numChars+1)
      If utf8Buffer
        FillMemory(utf8Buffer, numChars, '9')
        t1 = ScintillaSendMessage(id, #SCI_TEXTWIDTH, #STYLE_LINENUMBER, utf8Buffer) + *this\lineNumberAutoSizePadding + 10
        ScintillaSendMessage(id, #SCI_SETMARGINWIDTHN, #GOSCI_MARGINLINENUMBERS, t1)
        FreeMemory(utf8Buffer)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-INTERNAL FUNCTIONS - Default lexer functions.
  ;-========================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following routine is called by both GOSCI_AddKeywords() and GOSCI_AddKeywordsEx() for the common functionality.
  ;Set styleIndex = -1 to leave any existing style index unaltered.
  ;Returns the number of keywords successfully added.
  Procedure.i GOSCI_AddKeywordsXXX(id, keyWords$, styleIndex=#STYLE_DEFAULT, flags=0)
    Protected result, *this._GoScintilla, wordCount, i, t1$, blnProceed, keyWord$, *ptrKeyword.GoScintillaKeyword
    keyWords$ = Trim(keyWords$)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And keyWords$
      *this = GetGadgetData(id)
      If *this
        wordCount = CountString(keyWords$, " ") + 1
        For i = 1 To wordCount
          keyWord$ = StringField(keyWords$, i, " ")
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            t1$ = LCase(keyWord$)
          Else
            t1$ = keyWord$
          EndIf
          ;Check if we already have an entry for this keyword. If not, we make a new one.
          If FindMapElement(*this\keywordPtr(), t1$) = 0
            LastElement(*this\Keywords())
            *ptrKeyword = AddElement(*this\Keywords())
            If *ptrKeyword
              If AddMapElement(*this\keywordPtr(), t1$)
                *this\keywordPtr() = *ptrKeyword
              Else
                DeleteElement(*this\Keywords())
                *ptrKeyword = 0
              EndIf
            EndIf
          Else
            *ptrKeyword = *this\keywordPtr()
          EndIf
          If *ptrKeyword
            *ptrKeyword\keyWord$ = keyWord$
            If styleIndex <> -1
              *ptrKeyword\styleIndex = styleIndex
            EndIf
            *ptrKeyword\flags | flags
            result + 1
          EndIf
        Next
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is used by the default line styler to determine if the next symbol is a valid number?
  ;Returns the total number of bytes in the number string (so zero if not a valid number). In the case of the symbol being a number, the number of digits is placed into the specified buffer.
  Procedure.i GOSCI_IsNumberXXX(*this._GoScintilla, *bytePtr.ASCII, numBytesRemaining, *numDigits.INTEGER)
    Protected numBytesInNumber, numDecimalPoints, numDigits, t1
    While numBytesInNumber < numBytesRemaining
      If *bytePtr\a = '.'
        If numDecimalPoints
          numBytesInNumber = 0
          Break
        EndIf
        numDecimalPoints + 1
      ElseIf *bytePtr\a >= '0' And *bytePtr\a <= '9'
        numDigits + 1
      ElseIf *bytePtr\a = 9 Or *bytePtr\a = 32 Or GOSCI_IsSeparatorXXX(*this, *bytePtr\a, @t1)
        Break
      Else
        numBytesInNumber = 0
        Break
      EndIf
      *bytePtr + 1
      numBytesInNumber + 1
    Wend
    If numBytesInNumber
      *numDigits\i = numDigits
    EndIf
    ProcedureReturn numBytesInNumber
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is used by the default line styler to determine if the given symbol represents a separator character or not?
  ;Returns #True or #False as appropriate. In the case of the symbol being a separator, it also fills the *keyword buffer with any associated keyword info.
  Procedure.i GOSCI_IsSeparatorXXX(*this._GoScintilla, symbol.a, *keyword.INTEGER)
    Protected result = #False, *ptrChar.CHARACTER, *ptrKeyword.GoScintillaKeyword
    ;First check the list of separators.
    *ptrChar = @*this\lexerSeparators$  ;External Lexer's should use GOSCI_GetLexerOption() to retrieve this address.
    If symbol = #LF Or symbol = #CR
      result = #True
    Else
      While *ptrChar\c
        If *ptrChar\c = symbol
          result = #True
          Break
        EndIf
        *ptrChar + SizeOf(CHARACTER)
      Wend
    EndIf
    ;Retrieve any associated keyword info.
    *ptrKeyword = GOSCI_GetKeywordInfo(*this\id, Chr(symbol))
    ;If symbol not identified as an explicit separator then we check if it is a delimiter.
    If result = #False
      If *ptrKeyword 
        If *ptrKeyword\flags&#GOSCI_KEYWORDDELIMITERMASK And *ptrKeyword\flags&#GOSCI_NONSEPARATINGDELIMITER=0
          result = #True
        EndIf
      EndIf
    EndIf
    If result = #True
      *keyword\i = *ptrKeyword
    Else
      *keyword\i = 0
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is called by our main Scintilla callback (#SCN_CHARADDED and #SCN_MODIFIED) to process, and possibly display, a code
  ;completion list or a call-tip. This function will not be called if code completion and call-tips have been disabled.
  ;It has to carefully examine the current line and pull out all lexical entities up to the current character (GoScintilla's lexer is used for this).
  ;Only then can a code completion list be constructed etc.
  Procedure GOSCI_ProcessCodeCompletionCalltipsXXX(*this._GoScintilla)
    Protected i, caretPos, *utf8Buffer.ASCII, bufferPtr, numUtf8Bytes, numBytesStyled, bytePos, word$, lenWord, *ptrKeyword.GoScintillaKeyword
    Protected t1, t1$, codeList$, blnProceedWithCallTip, *keyword.GoScintillaKeyword, nPos
    Protected Dim keywords._GoScintillaCallTips(#GOSCI_NUMNESTEDCALLTIPS), styleFlags, callTipIndex
    Protected *currentCalltipKeyword.GoScintillaKeyword, anticipatedCalltipCloseSeparator.a, newCalltipCloseSeparator.a, blnPush
    numUtf8Bytes = ScintillaSendMessage(*this\id, #SCI_GETCURLINE, 0, 0) - 1 ;Includes the null, hence the -1.
    If numUtf8Bytes
      bufferPtr = AllocateMemory(numUtf8Bytes+1)
      If bufferPtr
        If *this\state & #GOSCI_LEXERSTATE_ENABLECALLTIPS
          blnProceedWithCallTip = #True
        EndIf
        *utf8Buffer = bufferPtr
        caretPos = ScintillaSendMessage(*this\id, #SCI_GETCURLINE, numUtf8Bytes+1, *utf8Buffer)
        While numUtf8Bytes > 0
          styleFlags = 0
          numBytesStyled = GOSCI_StyleNextSymbolXXX(*this, *utf8Buffer, numUtf8Bytes, #True, @*keyword, @styleFlags)
          word$ = PeekS(*utf8Buffer, numBytesStyled, #PB_UTF8)
          blnPush = #False
          ;Do we have a terminal keyword?
          If *keyword And *keyword\flags & #GOSCI_TERMINALCALLTIP
            callTipIndex=0
            anticipatedCalltipCloseSeparator = 0
            *currentCalltipKeyword = 0
          Else
            ;Do we have a call-tipped keyword under investigation?
            If *currentCalltipKeyword
              If styleFlags&1 ;White-space encountered.
                nPos = FindString(*currentCalltipKeyword\openCallTipSeparators$, " ", 1)
                If nPos
                  Goto GOSCI_ProcessCodeCompletionCalltipsXXX_L4
                EndIf
                If *currentCalltipKeyword\flags & #GOSCI_ALLOWWHITESPACEPRECEEDINGOPENCALLTIP = 0
                  *currentCalltipKeyword = 0
                EndIf
              Else
                ;Do we have a valid open calltip separator for this keyword?
                nPos = FindString(*currentCalltipKeyword\openCallTipSeparators$, " ", 1)
                t1$ = Left(word$, 1)
                If nPos
                  If t1$ = Mid(*currentCalltipKeyword\closeCallTipSeparators$, nPos, 1)
                    nPos = 0
                  EndIf
                Else
                  nPos = FindString(*currentCalltipKeyword\openCallTipSeparators$, t1$, 1)
                EndIf
                GOSCI_ProcessCodeCompletionCalltipsXXX_L4:
                If nPos ;Yes we have a valid open calltip separator for this keyword.
                  newCalltipCloseSeparator = Asc(Mid(*currentCalltipKeyword\closeCallTipSeparators$, nPos, 1))
                  If *keyword And *keyword\flags & #GOSCI_DELIMITBETWEEN
                    If styleFlags & 2 = 0 Or caretPos < bytePos + numBytesStyled ;No delimit between terminator found. 
                      blnPush = #True
                    Else
                      ;Check that the keyword's close delimiter does not match the call-tipped keywords close calltip separator.
                      If *keyword\closeDelimiter <> newCalltipCloseSeparator
                        blnPush = #True
                      EndIf
                    EndIf  
                  Else
                    blnPush = #True                  
                  EndIf
                  If blnPush
                    GOSCI_ProcessCodeCompletionXXX_L2:
                    If callTipIndex <= #GOSCI_NUMNESTEDCALLTIPS
                      keywords(callTipIndex)\keyword = *currentCalltipKeyword
                      keywords(callTipIndex)\charPos = bytePos
                      keywords(callTipIndex)\previousCloseCalltipSeparator = anticipatedCalltipCloseSeparator
                      anticipatedCalltipCloseSeparator = newCalltipCloseSeparator
                      callTipIndex + 1
                    Else
                      blnProceedWithCallTip = #False
                    EndIf
                  EndIf
                  *currentCalltipKeyword = 0
                Else
                  If *keyword And *keyword\openCallTipSeparators$
                    *currentCalltipKeyword = *keyword
                    If *keyword\flags & #GOSCI_NULLCALLTIP
                      blnPush = #True
                      newCalltipCloseSeparator = Asc(*keyword\closeCallTipSeparators$)
                      Goto GOSCI_ProcessCodeCompletionXXX_L2
                    EndIf
                  Else
                    *currentCalltipKeyword = 0
                  EndIf
                EndIf
              EndIf
            EndIf
            ;In the case that we haven't pushed a call-tipped keyword and no white space was encountered we check if the anticipated
            ;call-tip close separator has been encountered.
            If blnPush = #False And styleFlags&1 = 0
              ;Are we looking for a close calltip separator?
              If anticipatedCalltipCloseSeparator And Chr(anticipatedCalltipCloseSeparator) = word$
                callTipIndex-1
                anticipatedCalltipCloseSeparator = keywords(callTipIndex)\previousCloseCalltipSeparator
                *currentCalltipKeyword = 0
              Else
                If *keyword And *keyword\openCallTipSeparators$
                  *currentCalltipKeyword = *keyword
                  If *keyword\flags & #GOSCI_NULLCALLTIP
                    blnPush = #True
                    newCalltipCloseSeparator = Asc(*keyword\closeCallTipSeparators$)
                    Goto GOSCI_ProcessCodeCompletionXXX_L2
                  EndIf
                Else
                  *currentCalltipKeyword = 0
                EndIf
              EndIf
            EndIf
          EndIf
          bytePos + numBytesStyled
          If caretPos <= bytePos
            Break
          EndIf
          numUtf8Bytes - numBytesStyled
          *utf8Buffer + numBytesStyled
        Wend
        FreeMemory(bufferPtr)
        lenWord = Len(word$)
        If lenWord >= *this\codeCompletionChars And *this\state & #GOSCI_LEXERSTATE_ENABLECODECOMPLETION
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            word$ = LCase(word$)
          EndIf
          ;Build the code completion list.
          ForEach *this\keywords()
            *ptrKeyword = *this\keywords()
            t1$ = *ptrKeyword\keyWord$
            If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
              t1$ = LCase(t1$)
            EndIf
            If Left(t1$, lenWord) = word$
              If *ptrKeyword\flags & #GOSCI_ADDTOCODECOMPLETION
                If codeList$
                  codeList$ + " " + *ptrKeyword\keyWord$
                Else
                  codeList$ = *ptrKeyword\keyWord$
                EndIf
              EndIf
            EndIf
          Next
          ;Show the list.
          t1$ = codeList$
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            t1$ = LCase(t1$)
          EndIf
          If codeList$ And t1$ <> word$
            ;Convert to utf-8.
            bufferPtr = AllocateMemory(StringByteLength(codeList$, #PB_UTF8)+1)
            If bufferPtr 
              PokeS(bufferPtr, codeList$, -1, #PB_UTF8)
              ScintillaSendMessage(*this\id, #SCI_AUTOCSHOW, numBytesStyled, bufferPtr)
              FreeMemory(bufferPtr)
              blnProceedWithCallTip = #False
            Else
              Goto GOSCI_ProcessCodeCompletionXXX_L1
            EndIf
          Else
            Goto GOSCI_ProcessCodeCompletionXXX_L1
          EndIf
        Else
          Goto GOSCI_ProcessCodeCompletionXXX_L1
        EndIf
      Else
        Goto GOSCI_ProcessCodeCompletionXXX_L1
      EndIf
    Else
      GOSCI_ProcessCodeCompletionXXX_L1:
      If ScintillaSendMessage(*this\id, #SCI_AUTOCACTIVE)
        ScintillaSendMessage(*this\id, #SCI_AUTOCCANCEL)
      EndIf
    EndIf
    ;Sort out any call-tips as appropriate.
    If blnProceedWithCallTip And callTipIndex > 0
      callTipIndex - 1
      While keywords(callTipIndex)\keyword\flags & #GOSCI_NULLCALLTIP
        If callTipIndex = 0
          Break
        EndIf
        callTipIndex - 1
      Wend
      If keywords(callTipIndex)\keyword\flags & #GOSCI_NULLCALLTIP = 0
        If (*this\lastCallTipIndex <> callTipIndex Or *this\lastStartPos <> ScintillaSendMessage(*this\id, #SCI_CALLTIPPOSSTART))
          bufferPtr = AllocateMemory(StringByteLength(keywords(callTipIndex)\keyword\callTip$, #PB_UTF8)+1)
          If bufferPtr 
            PokeS(bufferPtr, keywords(callTipIndex)\keyword\callTip$, -1, #PB_UTF8)
            nPos = ScintillaSendMessage(*this\id, #SCI_GETCURRENTPOS)
            *this\callTipLine = ScintillaSendMessage(*this\id, #SCI_LINEFROMPOSITION, nPos)
            t1$ = StringField(keywords(callTipIndex)\keyword\callTip$, 1, #LF$)
            t1 = StringByteLength(t1$, #PB_UTF8)
            nPos = ScintillaSendMessage(*this\id, #SCI_POSITIONFROMLINE, *this\callTipLine) + keywords(callTipIndex)\charPos + 1 - StringByteLength(keywords(callTipIndex)\keyword\keyWord$, #PB_UTF8)
            ScintillaSendMessage(*this\id, #SCI_CALLTIPSHOW, nPos, bufferPtr)
            ScintillaSendMessage(*this\id, #SCI_CALLTIPSETHLT, 0, t1)
            FreeMemory(bufferPtr)
            *this\lastStartPos = ScintillaSendMessage(*this\id, #SCI_CALLTIPPOSSTART)
            *this\lastCallTipIndex = callTipIndex
          Else
            Goto GOSCI_ProcessCodeCompletionCalltipsXXX_L3
          EndIf
        EndIf  
      Else
        Goto GOSCI_ProcessCodeCompletionCalltipsXXX_L3
      EndIf
    Else
      GOSCI_ProcessCodeCompletionCalltipsXXX_L3:
      *this\lastStartPos = -1
      *this\callTipLine = -1
      *this\lastCallTipIndex = -1
      ScintillaSendMessage(*this\id, #SCI_CALLTIPCANCEL) 
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is called by our default line-styling function to style individual symbols.
  ;The optional blnDoNotApplyStyle parameter will prevent all styling / code folding being applied to the symbol in question. Intended for
  ;use by user-defined line styling functions which may need to look ahead at additional symbols before styling them.
  ;The optional *styleFlags parameter is used for call-tip processing via the GOSCI_ProcessCodeCompletionCalltipsXXX() function.
  ;Bit 0 is set if whitespace was encountered. Bit 1 is set if we are styling a #GOSCI_DELIMITBETWEEN delimiter and the close delimiter was encountered.
  ;Returns the number of bytes styled.
  Procedure.i GOSCI_StyleNextSymbolXXX(*this._GoScintilla, *bytePtr.ASCII, numBytesRemaining, blnDoNotApplyStyle=#False, *keywordBuffer.INTEGER=0, *styleFlags.INTEGER=0)
    Protected numBytesToStyle, styleToUse, *ptrBytes.ASCII, *ptrBytes2.ASCII, *keyword.GoScintillaKeyword, *keywordNext.GoScintillaKeyword
    Protected text$, t1, t2, openDelimeter.a, numSpaces, symbolType, blnIsWhiteSpace
    *ptrBytes = *bytePtr
    styleToUse = *this\previouslyRecordedStyle
    ;Have we white space?
    If *ptrBytes\a = 32 Or *ptrBytes\a = 9
      While numBytesToStyle < numBytesRemaining And (*ptrBytes\a = 32 Or *ptrBytes\a = 9)
        numBytesToStyle + 1
        *ptrBytes+1
      Wend
      blnIsWhiteSpace = #True
      ;Else, have we a separator?
    ElseIf GOSCI_IsSeparatorXXX(*this, *ptrBytes\a, @*keyword)
      If blnDoNotApplyStyle = #False
        *this\previouslyRecordedStyle = #STYLE_DEFAULT
      EndIf
      numBytesToStyle = 1
      styleToUse = #STYLE_DEFAULT
      If *keyword
        styleToUse = *keyword\styleIndex
      EndIf
      ;Is the separator a '.' character?
      If *ptrBytes\a = '.'
        numBytesToStyle = GOSCI_IsNumberXXX(*this, *ptrBytes, numBytesRemaining, @t1)
        If t1
          styleToUse = *this\lexerNumbersStyleIndex
          Goto GOSCI_StyleNextSymbolXXX_ApplyStyle
        Else
          numBytesToStyle = 1
        EndIf
      EndIf
      If numBytesToStyle < numBytesRemaining
        If *keyword
          If *keyword\flags & #GOSCI_DELIMITBETWEEN
            openDelimeter = *ptrBytes\a
            ;We need to track down the close delimiter. Skipping additional open delimiters as we proceed.
            *ptrBytes + 1
            t1 = 1 ; A temporary count of how many 'open' delimiters we have encountered.
            While numBytesToStyle < numBytesRemaining And t1 > 0
              numBytesToStyle + 1
              If *ptrBytes\a = *keyword\closeDelimiter
                t1 - 1
                If t1 = 0
                  If *styleFlags
                    *styleFlags\i = 2
                  EndIf
                  Break
                EndIf
              ElseIf *ptrBytes\a = openDelimeter
                t1 + 1
              ElseIf *ptrBytes\a = #LF Or *ptrBytes\a = 13 ;We style these separately with the default style.
                numBytesToStyle - 1
                Break
              EndIf
              *ptrBytes+1
            Wend
          ElseIf *keyword\flags & #GOSCI_DELIMITTOENDOFLINE
            numBytesToStyle = numBytesRemaining
            ;Need to avoid applying the style to the EOL characters which instead must receive the default style.
            ;This is to avoid Scintilla then instructing us to style the whole document needlessly!
            *ptrBytes + numBytesRemaining - 1
            While *ptrBytes\a = #LF Or *ptrBytes\a = #CR
              numBytesToStyle - 1
              *ptrBytes - 1
            Wend          
          ElseIf *keyword\flags & (#GOSCI_LEFTDELIMITWITHWHITESPACE | #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
            *ptrBytes + 1
            If (*ptrBytes\a <> 9 And *ptrBytes\a <> 32) Or *keyword\flags & #GOSCI_LEFTDELIMITWITHWHITESPACE
              If blnDoNotApplyStyle = #False
                *this\previouslyRecordedStyle = styleToUse
              EndIf
            EndIf
          EndIf
        EndIf    
      EndIf
    Else ;A keyword or unknown symbol.
         ;First check for a number.
      t2 = GOSCI_IsNumberXXX(*this, *ptrBytes, numBytesRemaining, @t1)
      If t2
        If blnDoNotApplyStyle = #False
          *this\previouslyRecordedStyle = #STYLE_DEFAULT
        EndIf
        numBytesToStyle = t2
        styleToUse = *this\lexerNumbersStyleIndex
      Else
        ;Retrieve all bytes up to the next whitespace / separator.
        numBytesToStyle = 1
        *ptrBytes + 1
        While numBytesToStyle < numBytesRemaining
          If GOSCI_IsSeparatorXXX(*this, *ptrBytes\a, @*keywordNext) Or *ptrBytes\a = 32 Or *ptrBytes\a = 9
            Break
          EndIf
          numBytesToStyle + 1
          *ptrBytes + 1
        Wend
        text$ = PeekS(*bytePtr, numBytesToStyle, #PB_UTF8)
        ;Is this a registered keyword?
        *keyword = GOSCI_GetKeywordInfo(*this\id, text$)
        If *this\previouslyRecordedStyle <> #STYLE_DEFAULT ;A left delimiter was previously encountered.
          If blnDoNotApplyStyle = #False
            *this\previouslyRecordedStyle = #STYLE_DEFAULT
          EndIf
        ElseIf *keyword
          If blnDoNotApplyStyle = #False
            *this\previouslyRecordedStyle = #STYLE_DEFAULT
          EndIf
          styleToUse = *keyword\styleIndex
        Else
          ;Perhaps the first character is a non-separating left delimiter?
          *keyword = GOSCI_GetKeywordInfo(*this\id, Chr(*bytePtr\a))
          If *keyword
            If *keyword\flags & (#GOSCI_LEFTDELIMITWITHWHITESPACE | #GOSCI_LEFTDELIMITWITHOUTWHITESPACE)
              If blnDoNotApplyStyle = #False
                *this\previouslyRecordedStyle = #STYLE_DEFAULT
              EndIf
              styleToUse = *keyword\styleIndex
            EndIf
            *keyword = 0 ;Do not allow code-folding for a non-separating delimiter.
          Else
            ;Perhaps the last character is a non-separating right delimiter?
            *ptrBytes2 = *ptrBytes-1
            *keyword = GOSCI_GetKeywordInfo(*this\id, Chr(*ptrBytes2\a))
            If *keyword
              If *keyword\flags & (#GOSCI_RIGHTDELIMITWITHWHITESPACE | #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE)
                If blnDoNotApplyStyle = #False
                  *this\previouslyRecordedStyle = #STYLE_DEFAULT
                EndIf
                styleToUse = *keyword\styleIndex
              EndIf
              *keyword = 0 ;Do not allow code-folding for a non-separating delimiter.
            Else
              ;We check if the next non-space character (if any) following this symbol is a right delimiter. Need to also record if space characters were located.
              If *keywordNext = 0
                While numBytesToStyle + numSpaces < numBytesRemaining
                  If *ptrBytes\a <> 9 And *ptrBytes\a <> 32
                    GOSCI_IsSeparatorXXX(*this, *ptrBytes\a, @*keywordNext)
                    Break
                  EndIf
                  numSpaces + 1
                  *ptrBytes + 1
                Wend
              EndIf
              If *keyWordNext
                If *keyWordNext\flags & (#GOSCI_RIGHTDELIMITWITHWHITESPACE | #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE)
                  If *keyWordNext\flags & #GOSCI_RIGHTDELIMITWITHWHITESPACE Or numSpaces = 0
                    numBytesToStyle + numSpaces
                    styleToUse = *keyWordNext\styleIndex 
                  EndIf
                EndIf
              EndIf
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
    GOSCI_StyleNextSymbolXXX_ApplyStyle:
    If blnDoNotApplyStyle = #False
      ;Apply the appropriate style.
      If *this\state & #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING = 0
        styleToUse = #STYLE_DEFAULT
      EndIf
      ScintillaSendMessage(*this\id, #SCI_SETSTYLING, numBytesToStyle, styleToUse)
      ;Was the symbol a folding symbol?
      If *keyword
        If *keyword\flags & #GOSCI_OPENFOLDKEYWORD Or (*keyword\flags & #GOSCI_OPENFOLDKEYWORDNOPRECEDING And *this\blnLineCodeFoldOption=0)
          *this\blnLineCodeFoldOption + 1
        EndIf
        If *keyword\flags & #GOSCI_CLOSEFOLDKEYWORD And (*this\foldLevel > #SC_FOLDLEVELBASE Or *this\blnLineCodeFoldOption)
          *this\blnLineCodeFoldOption - 1
        EndIf
      EndIf
    EndIf
    If *keywordBuffer
      *keywordBuffer\i = *keyword
    EndIf
    If *styleFlags
      *styleFlags\i =  *styleFlags\i&$FFFFFFFE | blnIsWhiteSpace
    EndIf
    ProcedureReturn numBytesToStyle
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is the default line-styling function. numUtf8Bytes is guaranteed to be > 0 and does not include the terminating null in the count.
  Procedure GOSCI_StyleLineXXX(id, *utf8Buffer.ASCII, numUtf8Bytes)
    Protected *this._GoScintilla, numBytesStyled
    Protected ascii.a
    *this = GetGadgetData(id)
    While numUtf8Bytes > 0
      numBytesStyled = GOSCI_StyleNextSymbolXXX(*this, *utf8Buffer, numUtf8Bytes)
      numUtf8Bytes - numBytesStyled
      *utf8Buffer + numBytesStyled
    Wend
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following internal function is called in order to force a restyling of a range of lines.
  ;The #SCI_COLOURISE message doesn't appear to work! Set 'endLine' to -1 to restyle up to the end of the document.
  ;No return.
  Procedure GOSCI_RestyleLinesXXX(id, startLine, endLine, finalByteToStyle = -1)
    Protected i, lineLength, utf8Buffer, startPos, *this._GoScintilla, blnApplyCodeFolding, t1
    Protected resultFromUserLineStylingFunction, numLines, originalEndLine, numBytesToStyle
    *this = GetGadgetData(id)
    numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
    If endLine = -1 Or endLine >= numLines
      endLine = numLines - 1
    EndIf
    originalEndLine = endLine
    If startLine < 0 
      startLine = 0
    EndIf
    If startLine = 0
      *this\foldLevel = #SC_FOLDLEVELBASE    
    Else
      ;We begin the styling at the previous line as it's fold level will be exact and not subject to change.
      ;It may, however, dictate the fold level of subsequent lines (e.g. in the case of a close-fold keyword).
      startLine - 1
      *this\foldLevel = ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, startLine)&#SC_FOLDLEVELNUMBERMASK
    EndIf
    startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, startLine)
    numBytesToStyle = finalByteToStyle - startPos
    ScintillaSendMessage(id, #SCI_STARTSTYLING, startpos, $1f)
    ;Debug "Startline = " + Str(startLine) + ", Endline = " + Str(endline) + ", Startpos = " + Str(startPos) + ", Endpos = " + Str(finalByteToStyle)
    For i = startLine To endLine
      *this\bytePointer = 0
      *this\previouslyRecordedStyle = #STYLE_DEFAULT
      *this\blnLineCodeFoldOption = 0 ;No code folding.
      lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, i)
      ;The final line being styled may need truncating else we will inevitably be styling more bytes than required. This can impact upon code folding.
      If resultFromUserLineStylingFunction = #GOSCI_STYLELINESASREQUIRED And finalByteToStyle <> -1 And lineLength > numBytesToStyle
        lineLength = numBytesToStyle
      EndIf
      numBytesToStyle - lineLength
      If lineLength > 0
        utf8Buffer = AllocateMemory(lineLength + 1)
        If utf8Buffer
          If ScintillaSendMessage(id, #SCI_GETLINE, i, utf8Buffer)
            ;Call the user-defined line styling function, if present.
            If *this\stylingFunction
              resultFromUserLineStylingFunction = *this\stylingFunction(id, utf8Buffer, lineLength, i, startLine, originalEndLine)
              If resultFromUserLineStylingFunction = #GOSCI_STYLENEXTLINEREGARDLESS
                endLine = numLines - 1
              Else
                endLine = originalEndLine
              EndIf
            Else
              GOSCI_StyleLineXXX(id, utf8Buffer, lineLength)
            EndIf
          EndIf
          FreeMemory(utf8Buffer)
        EndIf
      EndIf
      ;Sort out the fold level.
      If lineLength > 0 Or i = numLines-1
        If *this\state & (#GOSCI_LEXERSTATE_ENABLECODEFOLDING|#GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING)
          t1 = 0
          If *this\blnLineCodeFoldOption >= 1 ;Open fold.
            t1 = #SC_FOLDLEVELHEADERFLAG
          EndIf
          ScintillaSendMessage(id, #SCI_SETFOLDLEVEL, i, t1|*this\foldLevel)
          *this\foldLevel + *this\blnLineCodeFoldOption
          If *this\foldLevel < #SC_FOLDLEVELBASE
            *this\foldLevel = #SC_FOLDLEVELBASE
          EndIf
        Else
          ScintillaSendMessage(id, #SCI_SETFOLDLEVEL, i, 0)
        EndIf
      EndIf
    Next
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-INTERNAL FUNCTIONS - Scintilla callback.
  ;-===================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following is the internal Scintilla callback. From here, if appropriate, we call the user's callback.
  ProcedureDLL GOSCI_ScintillaCallBackXXX(id, *scinotify.SCNotification)
    Protected *this._GoScintilla, startLine, endLine, lineLength, utf8Buffer, i, level, newLevel, startPos, nPos, t1
    *this = GetGadgetData(id)
    If *this
      If ScintillaSendMessage(id, #SCI_CALLTIPACTIVE) = 0
        *this\lastStartPos = -1
        *this\callTipLine = -1
        *this\lastCallTipIndex = -1
      Else
        nPos = ScintillaSendMessage(id, #SCI_GETCURRENTPOS)
        If *this\callTipLine<>-1 And *this\callTipLine <> ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, nPos)
          *this\lastStartPos = -1
          *this\callTipLine = -1
          *this\lastCallTipIndex = -1
          ScintillaSendMessage(id, #SCI_CALLTIPCANCEL) 
        EndIf  
      EndIf
    EndIf
    Select *scinotify\nmhdr\code
      Case #SCN_NEEDSHOWN
        ;Here we arrange for lines which may be collapsed to be expanded in the case that the folded section has been altered by the user.
        startLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position)
        endLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position + *scinotify\length)
        For i = startLine To endLine
          ScintillaSendMessage(id, #SCI_ENSUREVISIBLE, i)
        Next
        If ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, endLine)&#SC_FOLDLEVELHEADERFLAG
          level = ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, endLine) & #SC_FOLDLEVELNUMBERMASK
          newLevel = ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, endLine+1) & #SC_FOLDLEVELNUMBERMASK
          If newLevel > level
            ScintillaSendMessage(id, #SCI_ENSUREVISIBLE, endLine+1)
          EndIf  
        EndIf
      Case #SCN_MARGINCLICK
        Select *scinotify\margin
          Case #GOSCI_MARGINFOLDINGSYMBOLS
            startLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position)
            ;Check it is a header line.
            If *this\state & #GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING Or ScintillaSendMessage(id, #SCI_GETFOLDLEVEL, startLine) & #SC_FOLDLEVELHEADERFLAG
              ScintillaSendMessage(id, #SCI_TOGGLEFOLD, startLine)
            EndIf
        EndSelect
      Case #SCN_MODIFIED
        If *scinotify\linesAdded
          GOSCI_AutosizeLineNumberMarginXXX(id)
        EndIf
        If *this And *scinotify\modificationType & #SC_MOD_DELETETEXT
          If *this\state&(#GOSCI_LEXERSTATE_ENABLECODECOMPLETION | #GOSCI_LEXERSTATE_ENABLECALLTIPS)
            GOSCI_ProcessCodeCompletionCalltipsXXX(*this)
          EndIf
        EndIf
      Case #SCN_STYLENEEDED
        startLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, ScintillaSendMessage(id, #SCI_GETENDSTYLED))  
        startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, startLine)
        endLine = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, *scinotify\position)
        endLine = ScintillaSendMessage(id, #SCI_VISIBLEFROMDOCLINE, endLine)
        ;For some reason, endLine can sometimes be less than startLine (especially after code folding).
        If endLine < startLine
          t1 = startLine
          startLine = endLine
          endLine = t1+1
        EndIf
        GOSCI_RestyleLinesXXX(id, startLine, endLine, *scinotify\position)
      Case #SCN_CHARADDED
        If *scinotify\ch = 10 And *this And *this\state&#GOSCI_LEXERSTATE_ENABLEAUTOINDENTATION
          ;Process auto-indent.
          nPos = ScintillaSendMessage(*this\id, #SCI_GETCURRENTPOS)
          startLine = ScintillaSendMessage(*this\id, #SCI_LINEFROMPOSITION, nPos)-1
          level = ScintillaSendMessage(*this\id, #SCI_GETLINEINDENTATION, startLine)
          If level > 0
            startLine+1
            ScintillaSendMessage(*this\id, #SCI_SETLINEINDENTATION, startLine, level)
            nPos =  ScintillaSendMessage(*this\id, #SCI_GETLINEINDENTPOSITION, startLine)
            ScintillaSendMessage(*this\id, #SCI_GOTOPOS, nPos)
          EndIf
        ElseIf *this And *this\state&(#GOSCI_LEXERSTATE_ENABLECODECOMPLETION | #GOSCI_LEXERSTATE_ENABLECALLTIPS)
          GOSCI_ProcessCodeCompletionCalltipsXXX(*this)
        EndIf
    EndSelect
    
    ;Call the user's Scintilla callback.
    If *this And *this\callback
      *this\callback(id, *scinotify)
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-PUBLIC FUNCTIONS - General functions.
  ;-=================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function clears all text (unless the control is read-only).
  ;No return.
  Procedure GOSCI_Clear(id)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If ScintillaSendMessage(id, #SCI_GETREADONLY) = 0
        ScintillaSendMessage(id, #SCI_CLEARALL)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function creates a Scintilla gadget within the current gadget list and initialises it as appropriate.
  ;Returns either a gadget# or hWnd as per usual.
  Procedure.i GOSCI_Create(id, x, y, Width, Height, callbackAddress=0, flags=0)
    Protected result, *this._GoScintilla
    ;Allocate memory for a _GoScintilla structure.
    *this = AllocateMemory(SizeOf(_GoScintilla))
    If *this
      ;Create the gadget, but redirect the callback to our own one.
      result = ScintillaGadget(id, x, y, Width, Height, @GOSCI_ScintillaCallBackXXX())
      If result
        If id = #PB_Any
          id = result
        EndIf
        With *this
          \id = id
          \callback = callbackAddress
          \flags = flags
          \state = #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING|#GOSCI_LEXERSTATE_ENABLECODEFOLDING
          \lexerSeparators$ = ""
          \lexerNumbersStyleIndex = #STYLE_DEFAULT
          \codeCompletionChars = #GOSCI_DEFAULTCODECOMPLETIONCHARS
        EndWith
        ;Set utf-8 codepage.
        ScintillaSendMessage(id, #SCI_SETCODEPAGE, #SC_CP_UTF8, 0)
        ;Set lexer.
        ScintillaSendMessage(id, #SCI_SETLEXER, #SCLEX_CONTAINER)
        ;Zero all margins.
        ScintillaSendMessage(id, #SCI_SETMARGINWIDTHN, #GOSCI_MARGINNONFOLDINGSYMBOLS, 0)
        ;Set some defaults for the folding  margin for future use.
        ScintillaSendMessage(id, #SCI_SETMARGINSENSITIVEN, #GOSCI_MARGINFOLDINGSYMBOLS, #True)  ;Ensure that #SCN_MARGINCLICK notifications are sent for this margin.
        ScintillaSendMessage(id, #SCI_SETMARGINMASKN, #GOSCI_MARGINFOLDINGSYMBOLS, #SC_MASK_FOLDERS)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPEN, #SC_MARK_BOXMINUS)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, #White)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDER, #SC_MARK_BOXPLUS)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, #White)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERSUB, #SC_MARK_VLINE)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERTAIL, #SC_MARK_LCORNER)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, 0)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEREND, #SC_MARK_BOXPLUSCONNECTED)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, 0)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, #White)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDEROPENMID, #SC_MARK_BOXMINUSCONNECTED)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, 0)
        ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, #White)
        ScintillaSendMessage(id, #SCI_MARKERDEFINE, #SC_MARKNUM_FOLDERMIDTAIL, #SC_MARK_TCORNER)
        ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, 0)
        ;Clear all styles.
        ScintillaSendMessage(id, #SCI_STYLECLEARALL)
        ;Auto size the margin if appropriate.
        GOSCI_AutosizeLineNumberMarginXXX(id)
        ;Set case sensitivity for code completion.
        If flags & #GOSCI_KEYWORDSCASESENSITIVE
          ScintillaSendMessage(*this\id, #SCI_AUTOCSETIGNORECASE, 0)
        Else
          ScintillaSendMessage(*this\id, #SCI_AUTOCSETIGNORECASE, 1)
        EndIf
        ;Call tips.
        *this\lastStartPos = -1
        *this\callTipLine = -1
        *this\lastCallTipIndex = -1
        ;Set style for call-tips.
        ScintillaSendMessage(*this\id, #SCI_CALLTIPUSESTYLE, 0)
        ;Bookmarks.
        ScintillaSendMessage(*this\id, #SCI_SETMARGINMASKN, #GOSCI_MARGINNONFOLDINGSYMBOLS, 3)  ;Only marker numbers 0 and 1 to be allowed.
        ScintillaSendMessage(*this\id, #SCI_MARKERDEFINE, #GOSCI_BOOKMARKMARKERNUM, #SC_MARK_SHORTARROW)
        ;Error lines.
        ScintillaSendMessage(*this\id, #SCI_MARKERDEFINE, #GOSCI_ERRORMARKERNUM, #SC_MARK_BACKGROUND)
        ScintillaSendMessage(*this\id, #SCI_MARKERSETBACK, #GOSCI_ERRORMARKERNUM, RGB($ff, 0, 0))
        InitializeStructure(*this, _GoScintilla)
        ;Record a pointer to our _GoScintilla structure.
        SetGadgetData(id, *this)
      Else
        ClearStructure(*this, _GoScintilla)
        FreeMemory(*this)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function removes the specified line of text.
  ;No return value.
  Procedure GOSCI_DeleteLine(id, lineIndex)
    Protected numLines, lineLength, startPos, endPos, char.a
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If ScintillaSendMessage(id, #SCI_GETLENGTH)
        numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
        If lineIndex >=0 And lineIndex < numLines
          lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, lineIndex)
          startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, lineIndex)
          endPos = startPos + lineLength
          If lineIndex = numLines - 1
            ;We may have to delete the EOL characters in the previous line.
            If lineIndex
              startPos-1
              char = ScintillaSendMessage(id, #SCI_GETCHARAT, startPos)
              While char = 10 Or char = 13
                startPos-1
                char = ScintillaSendMessage(id, #SCI_GETCHARAT, startPos)
              Wend
              startPos+1
            EndIf
          EndIf
          ;We now replace the text with an empty string.
          ScintillaSendMessage(id, #SCI_SETTARGETSTART, startPos)
          ScintillaSendMessage(id, #SCI_SETTARGETEND, endPos)
          ScintillaSendMessage(id, #SCI_REPLACETARGET, -1, @"")
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function searches for a bookmarked line starting from the given line.
  ;Set direction < 0 for a backwards search.
  ;Returns -1 if no bookmark is found.
  Procedure.i GOSCI_FindBookmarkedLine(id, startLine, direction=1)
    Protected result=-1
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If direction < 0
        result = ScintillaSendMessage(id, #SCI_MARKERPREVIOUS, startLine, 1)
      Else
        result = ScintillaSendMessage(id, #SCI_MARKERNEXT, startLine, 1)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function creates a Scintilla gadget within the current gadget list and initialises it as appropriate.
  ;Returns either a gadget# or hWnd as per usual.
  Procedure GOSCI_Free(id)
    Protected *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      FreeGadget(id)
      If *this
        ClearStructure(*this, _GoScintilla)
        FreeMemory(*this)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves control attributes. See header file for more details of which attributes can be retrieved.
  Procedure.i GOSCI_GetAttribute(id, attribute)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select attribute
        Case #GOSCI_READONLY
          result = ScintillaSendMessage(id, #SCI_GETREADONLY)
        Case #GOSCI_LINENUMBERAUTOSIZEPADDING
          *this = GetGadgetData(id)
          If *this
            result = *this\lineNumberAutoSizePadding
          EndIf
        Case #GOSCI_CANUNDO
          result = ScintillaSendMessage(id, #SCI_GETUNDOCOLLECTION)
        Case #GOSCI_WRAPLINES
          result = ScintillaSendMessage(id, #SCI_GETWRAPMODE) 
        Case #GOSCI_WRAPLINESVISUALMARKER
          result = ScintillaSendMessage(id, #SCI_GETWRAPVISUALFLAGS)
        Case #GOSCI_CODECOMPLETIONCHARS
          *this = GetGadgetData(id)
          If *this
            result = *this\codeCompletionChars
          EndIf
      EndSelect
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the specified color for the entire control (not individual styles).
  ;See header file for more details of which color constants can be used here (not all colors can be retrieved).
  Procedure.i GOSCI_GetColor(id, colorType)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select colorType
        Case #GOSCI_BACKCOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETBACK, #STYLE_DEFAULT) 
        Case #GOSCI_FORECOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETFORE, #STYLE_DEFAULT) 
        Case #GOSCI_LINENUMBERBACKCOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETBACK, #STYLE_LINENUMBER)  
        Case #GOSCI_LINENUMBERFORECOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETFORE, #STYLE_LINENUMBER)  
        Case #GOSCI_CARETLINEBACKCOLOR
          result = ScintillaSendMessage(id, #SCI_GETCARETLINEBACK)
        Case #GOSCI_CARETFORECOLOR
          result = ScintillaSendMessage(id, #SCI_GETCARETFORE)
        Case #GSCI_CALLTIPBACKCOLOR
          result = ScintillaSendMessage(id, #SCI_STYLEGETBACK, #STYLE_CALLTIP)
        Case #GSCI_CALLTIPFORECOLOR
          ScintillaSendMessage(id, #SCI_STYLEGETFORE, #STYLE_CALLTIP)
      EndSelect
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns #True if the specified line shows a bookmark.
  Procedure.i GOSCI_GetLineBookmark(id, lineIndex)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_MARKERGET, lineIndex)&1
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves a line's user data value.
  Procedure.i GOSCI_GetLineData(id, lineIndex)
    Protected result, numLines
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        result = ScintillaSendMessage(id, #SCI_GETLINESTATE, lineIndex)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the text (minus any EOL characters) for a given line.
  Procedure.s GOSCI_GetLineText(id, lineIndex)
    Protected text$, numLines, lineLength, utf8Buffer, *ptrAscii.ASCII
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, lineIndex)
        If lineLength
          utf8Buffer = AllocateMemory(lineLength+1)
          If utf8Buffer
            ScintillaSendMessage(id, #SCI_GETLINE, lineIndex, utf8Buffer)
            ;Remove any terminating EOL characters.
            *ptrAscii = utf8Buffer + lineLength - 1
            While (*ptrAscii\a = 10 Or *ptrAscii\a = 13) And lineLength
              lineLength - 1
              *ptrAscii - 1
            Wend
            text$ = PeekS(utf8Buffer, lineLength, #PB_UTF8)
            FreeMemory(utf8Buffer)
          EndIf
        EndIf
      EndIf
    EndIf
    ProcedureReturn text$
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function gets the width of the specified margin.
  Procedure.i GOSCI_GetMarginWidth(id, margin)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_GETMARGINWIDTHN, margin)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns the number of lines of text.
  Procedure.i GOSCI_GetNumberOfLines(id)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns the selected text.
  Procedure.s GOSCI_GetSelectedText(id)
    Protected text$, numBytes, utf8Buffer
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numBytes = ScintillaSendMessage(id, #SCI_GETSELTEXT)
      If numBytes
        utf8Buffer = AllocateMemory(numBytes)
        If utf8Buffer
          ScintillaSendMessage(id, #SCI_GETSELTEXT, 0, utf8Buffer)
          text$ = PeekS(utf8Buffer, -1, #PB_UTF8)
          FreeMemory(utf8Buffer)
        EndIf
      EndIf
    EndIf
    ProcedureReturn text$
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves state information. See header file for more details of which states can be retrieved.
  Procedure.i GOSCI_GetState(id, stateType)
    Protected result, *this._GoScintilla, nPos
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select stateType
        Case #GOSCI_CURRENTLINE
          nPos = ScintillaSendMessage(id, #SCI_GETCURRENTPOS)
          result = ScintillaSendMessage(id, #SCI_LINEFROMPOSITION, nPos)
        Case #GOSCI_ISMODIFIED
          result = ScintillaSendMessage(id, #SCI_GETMODIFY)
        Case #GOSCI_ISREADYTOREDO
          result = ScintillaSendMessage(id, #SCI_CANREDO)
        Case #GOSCI_ISREADYTOUNDO
          result = ScintillaSendMessage(id, #SCI_CANUNDO)
        Case #GOSCI_ISEMPTY
          If ScintillaSendMessage(id, #SCI_GETLENGTH) = 0
            result = #True
          EndIf
      EndSelect
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function returns the tab width.
  Procedure.i GOSCI_GetTabWidth(id)
    Protected result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      result = ScintillaSendMessage(id, #SCI_GETTABWIDTH)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the text for the entire control.
  Procedure.s GOSCI_GetText(id)
    Protected text$, utf8Buffer, numBytes
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numBytes = ScintillaSendMessage(id, #SCI_GETLENGTH)
      If numBytes
        utf8Buffer = AllocateMemory(numBytes+1)
        If utf8Buffer 
          ScintillaSendMessage(id, #SCI_GETTEXT, numBytes + 1, utf8Buffer)
          text$ = PeekS(utf8Buffer, -1, #PB_UTF8)
          FreeMemory(utf8Buffer)
        EndIf
      EndIf
    EndIf
    ProcedureReturn text$
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the control's user data.
  Procedure.i GOSCI_GetUserData(id)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        result = *this\userData
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function inserts a line of text at the specified lineIndex position (o to numLines). Set lineIndex = -1 to append the line.
  Procedure GOSCI_InsertLineOfText(id, lineIndex, text$, restyle = #True)
    Protected numLines, pos, utf8Buffer, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      ;Remove all EOL characters.
      text$ = RemoveString(text$, #LF$)
      text$ = RemoveString(text$, #CR$)
      ;Decide the insertion row.
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If (numLines = 0 Or ScintillaSendMessage(id, #SCI_GETLENGTH) = 0) And *this\blnSpaceAdded = #False
        lineIndex = 0
        If text$ = ""
          *this\blnSpaceAdded = #True
        EndIf
      ElseIf lineIndex < 0 Or lineIndex >= numLines
        lineIndex = numLines
        text$ = #LF$ + text$
      Else
        text$ + #LF$
      EndIf
      ;Determine the insertion pos.
      pos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, lineIndex)
      ;Insert text
      ;Need to convert to utf-8 first.
      utf8Buffer = AllocateMemory(StringByteLength(text$, #PB_UTF8)+1)
      If utf8Buffer 
        PokeS(utf8Buffer, text$, -1, #PB_UTF8)
        ScintillaSendMessage(id, #SCI_INSERTTEXT, pos, utf8Buffer)
        FreeMemory(utf8Buffer)
        If restyle
          GOSCI_RestyleLinesXXX(id, lineIndex, lineIndex)  
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function replaces the current selection with the given text.
  ;No return value.
  Procedure GOSCI_ReplaceSelectedText(id, text$, blnScrollCaretIntoView=#False, restyle = #True)
    Protected startPos, endPos, utf8Buffer, byteLength
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      startPos = ScintillaSendMessage(id, #SCI_GETSELECTIONSTART)
      endPos = ScintillaSendMessage(id, #SCI_GETSELECTIONEND)
      ;Need to convert text to utf-8 first.
      byteLength = StringByteLength(text$, #PB_UTF8)
      utf8Buffer = AllocateMemory(byteLength+1)
      If utf8Buffer 
        PokeS(utf8Buffer, text$, -1, #PB_UTF8)
        ScintillaSendMessage(id, #SCI_SETTARGETSTART, startPos)
        ScintillaSendMessage(id, #SCI_SETTARGETEND, endPos)
        ScintillaSendMessage(id, #SCI_REPLACETARGET, -1, utf8Buffer)
        startPos + byteLength
        ScintillaSendMessage(id, #SCI_SETCURRENTPOS, startpos)
        ScintillaSendMessage(id, #SCI_SETANCHOR, startpos)
        If blnScrollCaretIntoView
          ScintillaSendMessage(id, #SCI_GOTOPOS, startPos)
        EndIf
        FreeMemory(utf8Buffer)
        If restyle
          GOSCI_RestyleLinesXXX(id, 0, -1)  
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  Procedure GOSCI_Search(id, search.s, direction=#GOSCI_SEARCHFORWARDS, flags=0)
    Protected result, *mem, pos, numBytes, byteLen
    Protected selstart, selend
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And search
      numBytes = ScintillaSendMessage(id, #SCI_GETLENGTH)
      If numBytes
        byteLen = StringByteLength(search, #PB_UTF8)
        *mem = AllocateMemory(byteLen+1)
        If *mem
          PokeS(*mem, search, -1, #PB_UTF8)
          ScintillaSendMessage(id, #SCI_SETSEARCHFLAGS, flags)
          If direction = #GOSCI_SEARCHBACKWARDS
            pos = ScintillaSendMessage(id, #SCI_GETSELECTIONSTART)
            ScintillaSendMessage(id, #SCI_SETTARGETSTART, pos)
            ScintillaSendMessage(id, #SCI_SETTARGETEND, 0)
            result = ScintillaSendMessage(id, #SCI_SEARCHINTARGET, byteLen, *mem)
            If result <> -1
              ScintillaSendMessage(id, #SCI_SETSEL, ScintillaSendMessage(id, #SCI_GETTARGETSTART), ScintillaSendMessage(id, #SCI_GETTARGETEND))
            EndIf
          Else
            pos = ScintillaSendMessage(id, #SCI_GETSELECTIONEND)
            ScintillaSendMessage(id, #SCI_SETTARGETSTART, pos)
            ScintillaSendMessage(id, #SCI_SETTARGETEND, numBytes)
            result = ScintillaSendMessage(id, #SCI_SEARCHINTARGET, byteLen, *mem)
            If result <> -1
              ScintillaSendMessage(id, #SCI_SETSEL, ScintillaSendMessage(id, #SCI_GETTARGETSTART), ScintillaSendMessage(id, #SCI_GETTARGETEND))
            EndIf
          EndIf
          FreeMemory(*mem)
        EndIf
      EndIf
      ProcedureReturn result
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets control attributes. See header file for more details.
  ;No return.
  Procedure GOSCI_SetAttribute(id, attribute, value)
    Protected *this._GoScintilla, scinotify.SCNotification
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select attribute
        Case #GOSCI_READONLY
          ScintillaSendMessage(id, #SCI_SETREADONLY, value)
        Case #GOSCI_LINENUMBERAUTOSIZEPADDING
          If value >= 0
            *this = GetGadgetData(id)
            If *this And *this\lineNumberAutoSizePadding <> value
              *this\lineNumberAutoSizePadding = value
              ;Auto size the margin if appropriate.
              GOSCI_AutosizeLineNumberMarginXXX(id)
            EndIf
          EndIf
        Case #GOSCI_CANUNDO
          If value = #False
            ScintillaSendMessage(id, #SCI_EMPTYUNDOBUFFER)
          EndIf
          ScintillaSendMessage(id, #SCI_SETUNDOCOLLECTION, value)
        Case #GOSCI_WRAPLINES
          ScintillaSendMessage(id, #SCI_SETWRAPMODE, value) 
        Case #GOSCI_WRAPLINESVISUALMARKER
          ScintillaSendMessage(id, #SCI_SETWRAPVISUALFLAGS, value)
        Case #GOSCI_CODECOMPLETIONCHARS
          If value > 0
            *this = GetGadgetData(id)
            If *this And *this\codeCompletionChars <> value
              *this\codeCompletionChars = value
            EndIf
          EndIf
        Case #GOSCI_BOOKMARKSYMBOL
          ScintillaSendMessage(id, #SCI_MARKERDEFINE, #GOSCI_BOOKMARKMARKERNUM, value)
      EndSelect
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets colors for the entire control (not individual styles).
  ;See header file for more details.
  ;No return.
  Procedure GOSCI_SetColor(id, colorType, color)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select colorType
        Case #GOSCI_BACKCOLOR
          ScintillaSendMessage(id, #SCI_STYLESETBACK, #STYLE_DEFAULT, color)  
          ScintillaSendMessage(id, #SCI_STYLECLEARALL)
        Case #GOSCI_FORECOLOR
          ScintillaSendMessage(id, #SCI_STYLESETFORE, #STYLE_DEFAULT, color)  
          ScintillaSendMessage(id, #SCI_STYLECLEARALL)
        Case #GOSCI_SELECTIONBACKCOLOR
          ScintillaSendMessage(id, #SCI_SETSELBACK, #True, color)  
        Case #GOSCI_SELECTIONFORECOLOR
          ScintillaSendMessage(id, #SCI_SETSELFORE, #True, color)  
        Case #GOSCI_LINENUMBERBACKCOLOR
          ScintillaSendMessage(id, #SCI_STYLESETBACK, #STYLE_LINENUMBER, color)  
        Case #GOSCI_LINENUMBERFORECOLOR
          ScintillaSendMessage(id, #SCI_STYLESETFORE, #STYLE_LINENUMBER, color)  
        Case #GOSCI_CARETLINEBACKCOLOR
          If color = -1
            ScintillaSendMessage(id, #SCI_SETCARETLINEVISIBLE, #False)
          Else
            ScintillaSendMessage(id, #SCI_SETCARETLINEBACK, color)
            ScintillaSendMessage(id, #SCI_SETCARETLINEVISIBLE, #True)
          EndIf
        Case #GOSCI_CARETFORECOLOR
          ScintillaSendMessage(id, #SCI_SETCARETFORE, color)
        Case #GSCI_CALLTIPBACKCOLOR
          ScintillaSendMessage(id, #SCI_STYLESETBACK, #STYLE_CALLTIP, color)
        Case #GSCI_CALLTIPFORECOLOR
          ScintillaSendMessage(id, #SCI_STYLESETFORE, #STYLE_CALLTIP, color)
        Case #GOSCI_CALLTIPFOREHLTCOLOR
          ScintillaSendMessage(id, #SCI_CALLTIPSETFOREHLT, color)
        Case #GOSCI_BOOKMARKBACKCOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #GOSCI_BOOKMARKMARKERNUM, color)
        Case #GOSCI_BOOKMARKFORECOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #GOSCI_BOOKMARKMARKERNUM, color)
        Case #GOSCI_ERRORBACKCOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #GOSCI_ERRORMARKERNUM, color)
        Case #GOSCI_FOLDMARGINLOBACKCOLOR
          ScintillaSendMessage(id, #SCI_SETFOLDMARGINCOLOUR, 1, color)
        Case #GOSCI_FOLDMARGINHIBACKCOLOR
          ScintillaSendMessage(id, #SCI_SETFOLDMARGINHICOLOUR, 1, color)
        Case #GOSCI_FOLDMARKERSBACKCOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPEN, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDER, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERSUB, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERTAIL, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEREND, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDEROPENMID, color)
          ScintillaSendMessage(id, #SCI_MARKERSETBACK, #SC_MARKNUM_FOLDERMIDTAIL, color)
        Case #GOSCI_FOLDMARKERSFORECOLOR
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPEN, color)
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDER, color)
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEREND, color)
          ScintillaSendMessage(id, #SCI_MARKERSETFORE, #SC_MARKNUM_FOLDEROPENMID, color)
      EndSelect
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the main font. Can set bold and italic.
  ;Set fontName$ to "" to skip changing font face. Set fontSize to -1 to skip altering the size. Ditto for fontStyle.
  ;No return value.
  Procedure GOSCI_SetFont(id, fontName$, fontSize=-1, fontStyle=-1)
    GOSCI_SetStyleFont(id, #STYLE_DEFAULT, fontName$, fontSize, fontStyle)
    ScintillaSendMessage(id, #SCI_STYLECLEARALL)
    ;Auto size the margin if appropriate.
    GOSCI_AutosizeLineNumberMarginXXX(id)
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets or clears a bookmark from the given line depending on the flag parameter.
  Procedure GOSCI_SetLineBookmark(id, lineIndex, flag=#True)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If flag
        ScintillaSendMessage(id, #SCI_MARKERADD, lineIndex, #GOSCI_BOOKMARKMARKERNUM)    
      Else
        ScintillaSendMessage(id, #SCI_MARKERDELETE, lineIndex, #GOSCI_BOOKMARKMARKERNUM) 
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets an error at the given line.
  Procedure GOSCI_SetLineError(id, lineIndex)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ScintillaSendMessage(id, #SCI_MARKERADD, lineIndex, #GOSCI_ERRORMARKERNUM)    
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets a line's user data value.
  ;Returns the original value.
  Procedure.i GOSCI_SetLineData(id, lineIndex, value)
    Protected result, numLines
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        result = ScintillaSendMessage(id, #SCI_GETLINESTATE, lineIndex)
        ScintillaSendMessage(id, #SCI_SETLINESTATE, lineIndex, value)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function changes the text for a given line.
  ;No return value.
  Procedure GOSCI_SetLineText(id, lineIndex, text$, restyle = #True)
    Protected numLines, lineLength, startPos, endPos, char.a, utf8Buffer
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      numLines = ScintillaSendMessage(id, #SCI_GETLINECOUNT)
      If lineIndex >=0 And lineIndex < numLines
        ;Remove all EOL characters.
        text$ = RemoveString(text$, #LF$)
        text$ = RemoveString(text$, #CR$)
        ;Find the beginning and the end of the text to replace.
        lineLength = ScintillaSendMessage(id, #SCI_LINELENGTH, lineIndex)
        startPos = ScintillaSendMessage(id, #SCI_POSITIONFROMLINE, lineIndex)
        endPos = startPos + lineLength
        ;We ignore any EOL characters.
        endPos - 1
        char = ScintillaSendMessage(id, #SCI_GETCHARAT, endPos)
        While (char = 10 Or char = 13) And endPos >= startPos
          endPos-1
          char = ScintillaSendMessage(id, #SCI_GETCHARAT, endPos)
        Wend
        endPos + 1
        ;Need to convert text to utf-8 first.
        utf8Buffer = AllocateMemory(StringByteLength(text$, #PB_UTF8)+1)
        If utf8Buffer 
          PokeS(utf8Buffer, text$, -1, #PB_UTF8)
          ScintillaSendMessage(id, #SCI_SETTARGETSTART, startPos)
          ScintillaSendMessage(id, #SCI_SETTARGETEND, endPos)
          ScintillaSendMessage(id, #SCI_REPLACETARGET, -1, utf8Buffer)
          FreeMemory(utf8Buffer)
          If restyle
            GOSCI_RestyleLinesXXX(id, 0, -1)  
          EndIf
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the width of the specified margin.
  ;In the case of the line number margin, this function will fail if the #GOSCI_AUTOSIZELINENUMBERSMARGIN creation flag was set.
  ;No return value.
  Procedure GOSCI_SetMarginWidth(id, margin, width)
    Protected *this._GoScintilla, blnDoNotProceed
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If width < 0
        width = 0
      EndIf
      If margin = #GOSCI_MARGINLINENUMBERS
        *this = GetGadgetData(id)
        If *this
          If *this\flags & #GOSCI_AUTOSIZELINENUMBERSMARGIN
            blnDoNotProceed = #True
          EndIf
        EndIf
      EndIf
      If blnDoNotProceed = #False
        ScintillaSendMessage(id, #SCI_SETMARGINWIDTHN, margin, width)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets a control state. See header file for more details.
  ;No return.
  Procedure GOSCI_SetState(id, stateType, value=0)
    Protected *this._GoScintilla, nPos
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      Select stateType
        Case #GOSCI_CURRENTLINE
          ScintillaSendMessage(id, #SCI_GOTOLINE, value)
          ScintillaSendMessage(id, #SCI_ENSUREVISIBLE, value)
        Case #GOSCI_DOCUMENTSAVED ;Value is ignored.
          ScintillaSendMessage(id, #SCI_SETSAVEPOINT)
        Case #GOSCI_EMPTYUNDOBUFFER ;Value is ignored.
          ScintillaSendMessage(id, #SCI_EMPTYUNDOBUFFER)
        Case #GOSCI_CLEARALLBOOKMARKS ;Value is ignored.
          ScintillaSendMessage(id, #SCI_MARKERDELETEALL, #GOSCI_BOOKMARKMARKERNUM)
        Case #GOSCI_CLEARALLERRORS ;Value is ignored.
          ScintillaSendMessage(id, #SCI_MARKERDELETEALL, #GOSCI_ERRORMARKERNUM)
        Case #GOSCI_RESTYLEDOCUMENT
          GOSCI_RestyleLinesXXX(id, 0, -1)
      EndSelect
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the tab width and whether hard or soft tabs are used. A soft tab inserts spaces.
  ;For this to work, you must remove the default keyboard shortcut for the tab key from the main PB window.
  ;No return value.
  Procedure GOSCI_SetTabs(id, width, blnUseSoftTabs = #False)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ScintillaSendMessage(id, #SCI_SETTABWIDTH, width)
      ScintillaSendMessage(id, #SCI_SETUSETABS, 1-blnUseSoftTabs)
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the text for the entire control.
  ;Set the optional clearUndoStack parameter to non-zero to have the undo stack cleared so that this operation cannot be undone.
  ;No return value.
  Procedure GOSCI_SetText(id, text$, clearUndoStack=#False)
    Protected utf8Buffer
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      ;Need to convert to utf-8 first.
      utf8Buffer = AllocateMemory(StringByteLength(text$, #PB_UTF8)+1)
      If utf8Buffer 
        PokeS(utf8Buffer, text$, -1, #PB_UTF8)
        ScintillaSendMessage(id, #SCI_SETTEXT, 0, utf8Buffer)
        FreeMemory(utf8Buffer)
        If clearUndoStack
          ScintillaSendMessage(id, #SCI_EMPTYUNDOBUFFER)
        EndIf
        GOSCI_RestyleLinesXXX(id, 0, -1)  
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the control's user data.
  ;Returns the original value.
  Procedure.i GOSCI_SetUserData(id, value)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        result = *this\userData
        *this\userData = value
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;-PUBLIC FUNCTIONS - Functions to assist with the syntax highlighting lexer.
  ;-============================================================
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function adds a delimiter (or delimiter pair) to the underlying Scintilla control.
  ;Note that only Ascii characters must be used within each delimiter.
  ;Duplicates are simply replaced.
  ;Set flags to one (or more) of the constants #GOSCI_DELIMITBETWEEN or ... etc.
  ;closeDelimiter$ is only used for delimiters of type #GOSCI_DELIMITBETWEEN and are not added to the list of separators.
  Procedure GOSCI_AddDelimiter(id, delimiter$, closeDelimiter$, delimiterFlags, styleIndex=#STYLE_DEFAULT, restyle = #True)
    Protected *this._GoScintilla, t1$, *keyword.GoScintillaKeyword
    If delimiter$ And (closeDelimiter$ Or delimiterFlags & #GOSCI_DELIMITBETWEEN=0) And GOSCI_AddKeywordsXXX(id, delimiter$, styleIndex, delimiterFlags)
      If delimiterFlags & #GOSCI_DELIMITBETWEEN
        ;We need to record the close delimiter.    
        *this = GetGadgetData(id)
        t1$ = delimiter$
        If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
          t1$ = LCase(t1$)
        EndIf
        If FindMapElement(*this\keywordPtr(), t1$)
          *keyword = *this\keywordPtr()
          *keyword\closeDelimiter = Asc(closeDelimiter$)
        EndIf
      EndIf
      If restyle
        GOSCI_RestyleLinesXXX(id, 0, -1)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function adds additional call-tip separators not tied to any individual keyword and instead assume global significance.
  ;The choices are a null call-tip or a terminal call-tip.
  ;No return value.
  Procedure GOSCI_AddGlobalCalltipSeparators(id, openCallTipSeparators$, closeCallTipSeparators$, flags)
    Protected *this._GoScintilla, *keyword.GoScintillaKeyword
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And openCallTipSeparators$ <>" "
      *this = GetGadgetData(id)  
      If *this
        Select flags
          Case #GOSCI_NULLCALLTIP 
            If closeCallTipSeparators$ = " " Or Len(openCallTipSeparators$) <> 1 Or Len(closeCallTipSeparators$) <> 1
              ProcedureReturn
            EndIf
          Case #GOSCI_TERMINALCALLTIP
            If Len(openCallTipSeparators$) <> 1 Or openCallTipSeparators$ = " "
              ProcedureReturn
            EndIf
          Default 
            ProcedureReturn
        EndSelect
        If GOSCI_AddKeywordsXXX(id, openCallTipSeparators$, -1, flags)
          If FindMapElement(*this\keywordPtr(), openCallTipSeparators$)
            *keyword = *this\keywordPtr()
            *keyword\openCallTipSeparators$ = openCallTipSeparators$
            *keyword\closeCallTipSeparators$ = closeCallTipSeparators$
            If FindString(*this\lexerSeparators$, openCallTipSeparators$, 1) = 0
              *this\lexerSeparators$ + openCallTipSeparators$
            EndIf
            If flags = #GOSCI_NULLCALLTIP And FindString(*this\lexerSeparators$, closeCallTipSeparators$, 1) = 0
              *this\lexerSeparators$ + closeCallTipSeparators$
            EndIf
          EndIf
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function records a list of keywords to use the style specified. The list of words are to be separated by space characters.
  ;Note that only Ascii characters must be used within each keyword.
  ;Duplicates are simply replaced.
  ;Set keywordFlags to one (or more) of the keyword flags #GOSCI_OPENFOLDKEYWORD, #GOSCI_CLOSEFOLDKEYWORD or GOSCI_ADDTOCODECOMPLETION ... etc.
  Procedure GOSCI_AddKeywords(id, keyWords$, styleIndex=#STYLE_DEFAULT, keywordflags=0, blnSortKeywords=#False, restyle = #True)
    Protected *this._GoScintilla, t1
    If GOSCI_AddKeywordsXXX(id, keyWords$, styleIndex, keywordFlags)
      *this = GetGadgetData(id)
      If *this
        If blnSortKeywords
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            t1 = #PB_Sort_NoCase 
          EndIf
          SortStructuredList(*this\Keywords(), #PB_Sort_Ascending|t1, OffsetOf(GoScintillaKeyword\keyWord$), #PB_String)
        EndIf
      EndIf
      If restyle
        GOSCI_RestyleLinesXXX(id, 0, -1)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following extended function records a list of keywords to use the style specified along with an (optional) set of call-tips.
  ;Note that only Ascii characters must be used within each keyword.
  ;Duplicates are simply replaced.
  ;*ptrKeywords and *ptrCallTips point to string arrays with numKeywords elements. A crash will result if one array contains less elemenst than
  ;the other.
  ;openCallTipSeparators$ and closeCallTipSeparators$ hold non-empty lists of call-tip separators for use with the keywords. Every open call-tip
  ;separator must have an accompanying close call-tip separator. A space character used as part of the openCallTipSeparators$ means that
  ;any symbol will result in the call-tip being displayed.
  ;Set keywordFlags to one (or more) of the keyword flags #GOSCI_OPENFOLDKEYWORD, #GOSCI_CLOSEFOLDKEYWORD or GOSCI_ADDTOCODECOMPLETION ... etc.
  Procedure GOSCI_AddKeywordsEx(id, numKeywords, *ptrKeywords.STRING, *ptrCallTips.STRING=0, openCallTipSeparators$ = "", closeCallTipSeparators$="", styleIndex=#STYLE_DEFAULT, keywordFlags=0, blnSortKeywords=#False, restyle = #True)
    Protected *this._GoScintilla, *keyword.GoScintillaKeyword, lenOpen, lenClose, t1, t1$, t2$, i
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And *ptrKeywords
      *this = GetGadgetData(id)
      If *this
        If *ptrCallTips
          ;We must check that we have some separator symbols.
          lenOpen = Len(openCallTipSeparators$)
          lenClose = Len(closeCallTipSeparators$)
          If lenOpen <= 0 Or lenOpen <> lenClose
            ProcedureReturn
          EndIf
          ;Add the separators to the separator list if not already present.
          For i = 1 To lenOpen
            t1$ = Mid(openCallTipSeparators$, i, 1)
            t2$ = Mid(closeCallTipSeparators$, i, 1)
            If t1$ <> " " And FindString(*this\lexerSeparators$, t1$, 1) = 0
              *this\lexerSeparators$ + t1$
            EndIf
            If t2$ <> " " And FindString(*this\lexerSeparators$, t2$, 1) = 0
              *this\lexerSeparators$ + t2$
            EndIf
          Next
        EndIf
        For i = 0 To numKeywords-1
          t1$ = *ptrKeywords\s
          GOSCI_AddKeywordsXXX(id, t1$, styleIndex, keywordFlags)
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            t1$ = LCase(t1$)
          EndIf
          If *ptrCallTips 
            If FindMapElement(*this\keywordPtr(), t1$)
              *keyword = *this\keywordPtr()
              *keyword\callTip$ = *ptrCallTips\s
              *keyword\openCallTipSeparators$ = openCallTipSeparators$
              *keyword\closeCallTipSeparators$ = closeCallTipSeparators$
            EndIf
            *ptrCallTips + SizeOf(STRING)
          EndIf
          *ptrKeywords + SizeOf(STRING)
        Next
        If blnSortKeywords
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            t1 = #PB_Sort_NoCase 
          EndIf
          SortStructuredList(*this\Keywords(), #PB_Sort_Ascending|t1, OffsetOf(GoScintillaKeyword\keyWord$), #PB_String)
        EndIf
        If restyle
          GOSCI_RestyleLinesXXX(id, 0, -1)
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function copies the lexer settings from the source control to the control specified by ID. Any existing lexer settings are lost.
  Procedure GOSCI_CopyLexerFromExistingControl(ID, sourceID)
    Protected result, *this._GoScintilla, *thisSource._GoScintilla, *ptr._GoScintilla, t1$, *x.GoScintillaKeyword, i, t1, font$
    If IsGadget(sourceID) And GadgetType(sourceID) = #PB_GadgetType_Scintilla And IsGadget(ID) And GadgetType(ID) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(ID)
      *thisSource = GetGadgetData(sourceID)
      *ptr = AllocateMemory(SizeOf(_GoScintilla))
      If *ptr
        CopyStructure(*thisSource, *ptr, _GoScintilla)
        ;Manually fill the KeywordPtr() map.
        ClearMap(*ptr\keywordPtr())
        ForEach *ptr\keywords()
          t1$ = *ptr\keywords()\keyWord$
          If *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
            t1$ = LCase(t1$)
          EndIf
          AddMapElement(*ptr\keywordPtr(), t1$)
          *ptr\keywordPtr() = *ptr\keywords()
        Next
        ;Set some additional fields.
        With *ptr
          \id = *this\id
          \callback = *this\callback
          \flags = *this\flags
          \userData = *this\userdata
          \lineNumberAutoSizePadding = *this\lineNumberAutoSizePadding
        EndWith
        ;Set all styles to match the source.
        For i = 1 To #STYLE_LASTPREDEFINED
          ;Style colors.
          ScintillaSendMessage(*ptr\id, #SCI_STYLESETFORE, i, ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETFORE, i))  
          ScintillaSendMessage(*ptr\id, #SCI_STYLESETBACK, i, ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETBACK, i))  
          ;Fonts.
          ;Face-name.
          t1 = ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETFONT, i)
          If t1
            t1 = AllocateMemory(t1+1)
            ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETFONT, i, t1)
            ScintillaSendMessage(*ptr\id, #SCI_STYLESETFONT, i, t1)
            FreeMemory(t1)
          EndIf
          ;Font attributes.
          ScintillaSendMessage(*ptr\id, #SCI_STYLESETSIZE, i, ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETSIZE, i))
          ScintillaSendMessage(*ptr\id, #SCI_STYLESETBOLD, i, ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETBOLD, i))
          ScintillaSendMessage(*ptr\id, #SCI_STYLESETITALIC, i, ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETITALIC, i))
          ScintillaSendMessage(*ptr\id, #SCI_STYLESETUNDERLINE, i, ScintillaSendMessage(*thisSource\id, #SCI_STYLEGETUNDERLINE, i))
        Next
        ;Switch the lexer.
        ClearStructure(*this, _GoScintilla)
        FreeMemory(*this)
        SetGadgetData(ID, *ptr)
        ;Repaint.
        GOSCI_AutosizeLineNumberMarginXXX(id)
        GOSCI_RestyleLinesXXX(ID, 0, -1)
      EndIf
    EndIf
    ProcedureReturn *ptr
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to decrement the current line's fold level
  ;(as in the line currently being styled). DO NOT call this function from outside of a user-defined line styling function!
  ;No return value.
  Procedure GOSCI_DecFoldLevel(id)
    Protected *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this\state & (#GOSCI_LEXERSTATE_ENABLECODEFOLDING|#GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING)
        If *this\foldLevel > #SC_FOLDLEVELBASE Or *this\blnLineCodeFoldOption
          *this\blnLineCodeFoldOption - 1
        EndIf
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves info for the specified keyword in the form of a pointer to it's associated GoScintillaKeywords structure.
  ;Returns 0 if the keyword is not found.
  Procedure.i GOSCI_GetKeywordInfo(id, keyWord$)
    Protected result, *this._GoScintilla
    keyWord$ = Trim(keyWord$)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And keyWord$
      *this = GetGadgetData(id)  
      If *this And *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
        keyWord$ = LCase(keyWord$)
      EndIf
      If FindMapElement(*this\keywordPtr(), keyWord$)
        result = *this\keywordPtr()
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves a Lexer option. See the GoScintilla_HeaderFile.pbi file for a list of possible options.
  Procedure.i GOSCI_GetLexerOption(id, option)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this 
        Select option
          Case #GOSCI_LEXEROPTION_SEPARATORSYMBOLS
            result = @*this\lexerSeparators$
          Case #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX
            result = *this\lexerNumbersStyleIndex
        EndSelect
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function retrieves the lexer state.
  Procedure.i GOSCI_GetLexerState(id)
    Protected *this._GoScintilla, result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        result = *this\state
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to determine the number of bytes in the next 'symbol',
  ;that which would be retrieved by GoScintilla's lexer whilst styling the current line.
  ;DO NOT call this function from outside of a user-defined line styling function!
  Procedure.i GOSCI_GetNextSymbolByteLength(id, *bytePtr.ASCII, numBytesRemaining)
    Protected *this._GoScintilla, result
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And numBytesRemaining
      *this = GetGadgetData(id)  
      result = GOSCI_StyleNextSymbolXXX(*this, *bytePtr, numBytesRemaining, #True)
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to increment the current line's fold level
  ;(as in the line currently being styled). DO NOT call this function from outside of a user-defined line styling function!
  ;No return value.
  Procedure GOSCI_IncFoldLevel(id)
    Protected *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this\state & (#GOSCI_LEXERSTATE_ENABLECODEFOLDING|#GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING)
        *this\blnLineCodeFoldOption + 1
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function removes a list of keywords from the specified Scintilla control. The list of words are to be separated by space characters.
  ;Note that only Ascii characters must be used within each keyword.
  Procedure GOSCI_RemoveKeywords(id, keyWords$, restyle = #True)
    Protected *this._GoScintilla, wordCount, i, t1$, *keyword.GoScintillaKeyword
    keyWords$ = Trim(keyWords$)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And keyWords$
      *this = GetGadgetData(id)  
      If *this And *this\flags & #GOSCI_KEYWORDSCASESENSITIVE = 0
        keyWords$ = LCase(keyWords$)
      EndIf
      wordCount = CountString(keyWords$, " ") + 1
      For i = 1 To wordCount
        t1$ = StringField(keyWords$, i, " ")
        If FindMapElement(*this\keywordPtr(), t1$)
          *keyword = *this\keywordPtr()
          DeleteMapElement(*this\keywordPtr(), t1$)
          ChangeCurrentElement(*this\keywords(), *keyword)
          DeleteElement(*this\keywords())
        EndIf
      Next
      If restyle
        GOSCI_RestyleLinesXXX(id, 0, -1)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets an option for the lexer. See the GoScintilla_HeaderFile.pbi file for a list of possible options.
  Procedure GOSCI_SetLexerOption(id, option, value)
    Protected *this._GoScintilla, text$
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this 
        Select option
          Case #GOSCI_LEXEROPTION_SEPARATORSYMBOLS
            If value
              text$ = PeekS(value)
            EndIf
            If *this\lexerSeparators$ <> text$
              *this\lexerSeparators$ = text$
              GOSCI_RestyleLinesXXX(id, 0, -1)
            EndIf
          Case #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX
            If *this\lexerNumbersStyleIndex <> value
              *this\lexerNumbersStyleIndex = value
              GOSCI_RestyleLinesXXX(id, 0, -1)
            EndIf
        EndSelect
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets various lexer states; e.g. disables syntax styling.
  ;No return value.
  Procedure GOSCI_SetLexerState(id, state)
    Protected *this._GoScintilla, blnNeedRestyle
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)
      If *this
        ;Do we need to restyle the whole document?
        If *this\state & (#GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING|#GOSCI_LEXERSTATE_ENABLECODEFOLDING|#GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING) <> state & (#GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING|#GOSCI_LEXERSTATE_ENABLECODEFOLDING|#GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING)
          blnNeedRestyle = #True
        EndIf
        *this\state = state
        If blnNeedRestyle
          GOSCI_RestyleLinesXXX(id, 0, -1)
        EndIf 
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the colors for the specified style.
  ;Set the various color values to -1 to skip that color.
  ;No return value.
  Procedure GOSCI_SetStyleColors(id, styleIndex, foreColor=-1, backColor=-1)
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If foreColor <> -1
        ScintillaSendMessage(id, #SCI_STYLESETFORE, styleIndex, foreColor)  
      EndIf
      If backColor <> -1
        ScintillaSendMessage(id, #SCI_STYLESETBACK, styleIndex, backColor)  
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the font for the specified style. Can set bold, italic and underline.
  ;Set fontName$ to "" to skip changing font face. Set fontSize to -1 to skip altering the size. Ditto for fontStyle.
  ;No return value.
  Procedure GOSCI_SetStyleFont(id, styleIndex, fontName$, fontSize=-1, fontStyle=-1)
    Protected asciiBuffer, bold, italic, underline
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      If fontName$
        ;Convert the fontName$ to Ascii.
        asciiBuffer = AllocateMemory(Len(fontName$) + 1)
        If asciiBuffer
          PokeS(asciiBuffer, fontName$, -1, #PB_Ascii)
          ScintillaSendMessage(id, #SCI_STYLESETFONT, styleIndex, asciiBuffer)
          FreeMemory(asciiBuffer)    
        EndIf
      EndIf
      If fontSize <> -1
        ScintillaSendMessage(id, #SCI_STYLESETSIZE, styleIndex, fontSize)
      EndIf
      If fontStyle <> -1
        If fontStyle & #PB_Font_Bold
          bold = #True
        EndIf
        ScintillaSendMessage(id, #SCI_STYLESETBOLD, styleIndex, bold)
        If fontStyle & #PB_Font_Italic
          italic = #True
        EndIf
        ScintillaSendMessage(id, #SCI_STYLESETITALIC, styleIndex, italic)
        If fontStyle & #PB_Font_Underline
          underline = #True
        EndIf
        ScintillaSendMessage(id, #SCI_STYLESETUNDERLINE, styleIndex, underline)
      EndIf
      If styleIndex = #STYLE_LINENUMBER
        ;Auto size the margin if appropriate.
        GOSCI_AutosizeLineNumberMarginXXX(id)
      EndIf
    EndIf
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function sets the user-defined line styling function.
  ;Such a function, if present, is called before the default GoScintilla's line styling function and is invoked once for each line to be styled
  ;and it's return value directs GoScintilla as to whether it should style any part of the line etc. (See header file).
  ;Set addressOfFunction to 0 to remove this optional function.
  ;Returns the previous function address.
  Procedure.i GOSCI_SetLineStylingFunction(id, addressOfFunction)
    Protected result, *this._GoScintilla
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla
      *this = GetGadgetData(id)  
      If *this
        result = *this\stylingFunction
        *this\stylingFunction = addressOfFunction
        GOSCI_RestyleLinesXXX(id, 0, -1)
      EndIf
    EndIf
    ProcedureReturn result
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  ;/////////////////////////////////////////////////////////////////////////////////
  ;The following function can be called by a user-defined line styling function in order to invoke GoScintilla's default lexer to style
  ;the next symbol in the line. DO NOT call this function from outside of a user-defined line styling function!
  ;Returns the number of bytes actually styled.
  Procedure.i GOSCI_StyleNextSymbol(id, *bytePtr.ASCII, numBytesRemaining)
    Protected *this._GoScintilla, numBytesStyled
    If IsGadget(id) And GadgetType(id) = #PB_GadgetType_Scintilla And numBytesRemaining
      *this = GetGadgetData(id)  
      ;Reset the left-delimiter previously recorded style if this function is being called out of order.
      If *this\bytePointer <> *bytePtr
        *this\previouslyRecordedStyle = #STYLE_DEFAULT
      EndIf
      numBytesStyled = GOSCI_StyleNextSymbolXXX(*this, *bytePtr, numBytesRemaining)
      *this\bytePointer = *bytePtr + numBytesStyled
    EndIf
    ProcedureReturn numBytesStyled
  EndProcedure
  ;/////////////////////////////////////////////////////////////////////////////////
  
  
  
CompilerEndIf

DisableExplicit
