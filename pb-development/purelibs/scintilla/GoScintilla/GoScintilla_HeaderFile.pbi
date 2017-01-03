;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla***
;*=================
;*
;*'Header' file for public use.
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;-CONSTANTS.

  ;Creation flags.  Use a combination of the following.
    Enumeration
      #GOSCI_AUTOSIZELINENUMBERSMARGIN    = 1
      #GOSCI_KEYWORDSCASESENSITIVE        = 2   ;Use if the keywords lists (syntax highlighting etc.) are case sensitive.
    EndEnumeration

  ;Margins.
    Enumeration 
      #GOSCI_MARGINLINENUMBERS
      #GOSCI_MARGINNONFOLDINGSYMBOLS
        #GOSCI_MARGINBOOKMARKS  = #GOSCI_MARGINNONFOLDINGSYMBOLS ;Alias.
        #GOSCI_MARGINERROR      = #GOSCI_MARGINNONFOLDINGSYMBOLS ;Alias.
      #GOSCI_MARGINFOLDINGSYMBOLS
      #GOSCI_MARGINUSER1
      #GOSCI_MARGINUSER2
    EndEnumeration

  ;Colors. Used when setting colors for the entire control (not individual styles).
  ;Some (but not all) of the colors can be retrieved with GOSCI_GetColor().
    Enumeration 1
      #GOSCI_BACKCOLOR                    ;Get/Set.
      #GOSCI_FORECOLOR                    ;Get/Set.
      #GOSCI_SELECTIONBACKCOLOR           ;Set.
      #GOSCI_SELECTIONFORECOLOR           ;Set.
      #GOSCI_LINENUMBERBACKCOLOR          ;Get/Set.
      #GOSCI_LINENUMBERFORECOLOR          ;Get/Set.
      #GOSCI_CARETLINEBACKCOLOR           ;Get/Set. Set color to -1 to remove the visible line.
      #GOSCI_CARETFORECOLOR               ;Get/Set.
      #GSCI_CALLTIPBACKCOLOR              ;Get/Set.
      #GSCI_CALLTIPFORECOLOR              ;Get/Set.
      #GOSCI_CALLTIPFOREHLTCOLOR          ;Set. Call-tip highlight color.
      #GOSCI_BOOKMARKBACKCOLOR            ;Set.
      #GOSCI_BOOKMARKFORECOLOR            ;Set.
      #GOSCI_ERRORBACKCOLOR               ;Set.
        ;The following colors require #SC_MASK_FOLDERS mask bits to be set for the symbol margin. Set by default for margin #GOSCI_MARGINFOLDINGSYMBOLS.
          #GOSCI_FOLDMARGINLOBACKCOLOR    ;Set.
          #GOSCI_FOLDMARGINHIBACKCOLOR    ;Set.
          #GOSCI_FOLDMARKERSBACKCOLOR     ;Set.
          #GOSCI_FOLDMARKERSFORECOLOR     ;Set.
    EndEnumeration
    
  ;Attributes.  All can be set, some can be retrieved as well.
  ;Use with GOSCI_SetAttribute() and GOSCI_GetAttribute() as appropriate.
    Enumeration 1
      #GOSCI_READONLY                     ;Get/Set.
      #GOSCI_LINENUMBERAUTOSIZEPADDING    ;Get/Set.
                                          ;Added to the calculated line-number margin width when the #GOSCI_AUTOSIZELINENUMBERSMARGIN creation flag is used.
      #GOSCI_CANUNDO                      ;Get/Set.
      #GOSCI_WRAPLINES                    ;Get/Set.
      #GOSCI_WRAPLINESVISUALMARKER        ;Get/Set.
                                          ;Value = 0 for no marker, 1 for marker at the end of the subline, 2 for beginning of subline.
      #GOSCI_CODECOMPLETIONCHARS          ;Get/Set. Default value = #GOSCI_DEFAULTCODECOMPLETIONCHARS. 
                                          ;The number of characters required before a code completion list is shown.
      #GOSCI_BOOKMARKSYMBOL               ;Set.
    EndEnumeration

  ;States.
  ;Use with GOSCI_SetState() and GOSCI_GetState() as approptiate.
    Enumeration 1
      #GOSCI_CLEARALLBOOKMARKS            ;Set.
      #GOSCI_CLEARALLERRORS                  ;Set.
      #GOSCI_CURRENTLINE                  ;Get/Set.    
      #GOSCI_DOCUMENTSAVED                ;Set. Set this after saving the contents. Of use only if undo/redo operations are permitted.
      #GOSCI_CLEARMODIFIEDSTATE = #GOSCI_DOCUMENTSAVED
                                          ;An alias.
      #GOSCI_EMPTYUNDOBUFFER              ;Set.
      #GOSCI_ISEMPTY                      ;Get.
      #GOSCI_ISMODIFIED                   ;Get. Returns #True if the document has been modified since the last time the #GOSCI_DOCUMENTSAVED state was set.
                                          ;Only works if undo/redo operations are permitted.
      #GOSCI_ISREADYTOREDO                ;Get.
      #GOSCI_ISREADYTOUNDO                ;Get.
      #GOSCI_RESTYLEDOCUMENT              ;Set. Force a restyling of the document. Many operations (such as setting document text) automatically
                                          ;restyle the document.
    EndEnumeration

  ;Delimiter flags.  
    Enumeration
      #GOSCI_DELIMITBETWEEN                           = $1  ;Ex. 1, set a keyword to "" (a pair of quotes) to have everything between quotes treated as a single keyword.
                                                            ;Ex. 2, set a keyword to [] to have everything within square paranthesis treated as a single keyword.
                                                            ;The first symbol in such a pairing will be regarded AS AN ADDITIONAL SEPARATOR.
      #GOSCI_DELIMITTOENDOFLINE                       = $2  ;Ex.1 set a keyword to ; to have everything from this symbol to the end of a line treated as a single keyword.
                                                            ;Such symbols will be regarded AS ADDITIONAL SEPARATORS.
      #GOSCI_LEFTDELIMITWITHWHITESPACE                = $4  ;Ex. set a keyword to # to have every symbol (e.g. #Test, #   test) beginning with this character treated as a keyword.
      #GOSCI_LEFTDELIMITWITHOUTWHITESPACE             = $8  ;Same as above, but does not count symbols such as '#   test' (those with white space).
      #GOSCI_RIGHTDELIMITWITHWHITESPACE               = $10 ;Ex. set a keyword to [ to have every symbol (e.g. test[, test   [) ending with this character treated as a keyword.
      #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE            = $20 ;Same as above, but does not count symbols such as 'test   [' (those with white space).

      ;Add the following to have the delimiter not behave like a separator.
        #GOSCI_NONSEPARATINGDELIMITER                 = $00010000
    EndEnumeration

  ;Keywords flags.
    Enumeration
      #GOSCI_OPENFOLDKEYWORD                          = $00100000
      #GOSCI_OPENFOLDKEYWORDNOPRECEDING               = $00200000   ;Keyword will open a fold only if no other open-fold keyword precedes this one on the underlying line.
      #GOSCI_CLOSEFOLDKEYWORD                         = $00400000
      #GOSCI_ADDTOCODECOMPLETION                      = $00800000
      ;For use with GOSCI_AddKeywordsEx() only.
        #GOSCI_ALLOWWHITESPACEPRECEEDINGOPENCALLTIP   = $01000000
    EndEnumeration
  
  ;Global call-tip separators.
    Enumeration
      #GOSCI_NULLCALLTIP          = $10000000
      #GOSCI_TERMINALCALLTIP      = $20000000
    EndEnumeration

  ;Lexer options.
  ;Use with GOSCI_GetLexerOption()/GOSCI_SetLexerOption().
    Enumeration 1
      #GOSCI_LEXEROPTION_SEPARATORSYMBOLS   ;E.g. "+-*/,()". Used by the default Lexer to separate lexical entities when coloring lines.
                                            ;For GOSCI_SetLexerOption(), set value to the address of a character buffer containing the separator symbols.
                                            ;GOSCI_GetLexerOption() returns the address of the character buffer etc. Use PeekS() to get the string.
                                            ;Non-ascii separators are not supported by our default lexer.
                                            ;Always set the separator symbols BEFORE adding call-tipped keywords.
      #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX  ;For GOSCI_SetLexerOption(), set value to a style index. Default is #STYLE_DEFAULT.
    EndEnumeration

  ;Lexer states. Use a combination of values.
  ;Use with GOSCI_GetLexerState()/GOSCI_SetLexerState().
    Enumeration
      #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING             = 1   ;Set by default.
      #GOSCI_LEXERSTATE_ENABLECODECOMPLETION            = 2
      #GOSCI_LEXERSTATE_ENABLECODEFOLDING               = 4   ;Set by default.
      #GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING  = 8
      #GOSCI_LEXERSTATE_ENABLECALLTIPS                  = 16
      #GOSCI_LEXERSTATE_ENABLEAUTOINDENTATION           = 32
    EndEnumeration

;Search direction.
  Enumeration
    #GOSCI_SEARCHBACKWARDS
    #GOSCI_SEARCHFORWARDS
  EndEnumeration
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;-User defined line styling function.

  ;GoScintilla allows the user to declare an additional (and optional) line styling function which is invoked whenever a line requires
  ;re-styling. This function can call on GoScintilla to style parts of the line as appropriate.
  ;The return value from this function determines whether additional lines are to be styled beyond those originally marked for styling etc.
  ;(Typically, a few lines are 'marked' for styling at any given time.)

  ;The user-defined line styling function must follow the prototype given :
    Prototype.i GOSCI_proto_StyleLine(id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine)
  ;where *utf8Buffer points to a character buffer containing the bytes to style and numUtf8Bytes gives the number of UTF-8 bytes (not characters)
  ;in the line to style. This will include any EOL bytes (typically #CRLF$).
  ;The remaining parameters are provided for information only.
  ;Your function must return one of the following values as appropriate :
    Enumeration
      #GOSCI_STYLELINESASREQUIRED       ;Continue styling lines as directed by the Scintilla library. Stop once the lines originally marked for
                                        ;restyling have been styled.
      #GOSCI_STYLENEXTLINEREGARDLESS    ;Style the next line regardless of whether it is one of the lines originally marked for styling.
    EndEnumeration  
;/////////////////////////////////////////////////////////////////////////////////


;/////////////////////////////////////////////////////////////////////////////////
;-STRUCTURES.

  ;The following is held in a PB map and contains information on individual keywords and delimiters.
  ;Use the GOSCI_GetKeywordInfo() function to retrieve this info for any given keyword. Only really useful for those apps which decide to
  ;user their own customised lexer etc.
    Structure GoScintillaKeyword
      keyWord$
      styleIndex.i              ;0-based index of the style to apply.
      flags.i                   ;Set with the GOSCI_AddKeywords() function. A combination of the delimiter and keyword constants listed above.
      closeDelimiter.a          ;Used only for delimiters of type #GOSCI_DELIMITBETWEEN to record the character used as the close delimiter.
      ;The following fields are for those keywords having associated call-tips.
        openCallTipSeparators$
        closeCalltipSeparators$ 
        callTip$                ;Must be of the form : line1$ + #LF$ + line2$ + ...
                                ;The first line will be highlighted.
    EndStructure
;/////////////////////////////////////////////////////////////////////////////////


; IDE Options = PureBasic 4.61 (Windows - x86)
; ExecutableFormat = Shared Dll
; CursorPosition = 71
; FirstLine = 54
; EnableUnicode
; EnableThread
; Executable = d.exe.dll.exe.dll