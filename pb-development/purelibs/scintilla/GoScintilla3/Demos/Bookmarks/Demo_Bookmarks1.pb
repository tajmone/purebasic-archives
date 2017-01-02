;/////////////////////////////////////////////////////////////////////////////////
;***Go-Scintilla 2***
;*===================
;*
;*©nxSoftWare (www.nxSoftware.com) 2010.
;*======================================
;*    
;*  Bookmarks demo program.
;/////////////////////////////////////////////////////////////////////////////////

;/////////////////////////////////////////////////////////////////////////////////
;*NOTE that bookmark symbols share the #GOSCI_MARGINNONFOLDINGSYMBOLS margin with error symbols and which has a default width of 0.
;*If using bookmarks and errors together you must set the width of this margin to non-zero else the bookmarks and errors will both try to
;*set the back color of afflicted lines!
;/////////////////////////////////////////////////////////////////////////////////


IncludePath "../../"
XIncludeFile "GoScintilla.pbi"

Enumeration ;Menu item ID's
  #menu_AddRemoveMarker
  #menu_JumpToMarker
  #menu_ClearMarkers
EndEnumeration


;Initialise the Scintilla library for Windows.
  CompilerIf  #PB_Compiler_OS = #PB_OS_Windows 
    InitScintilla()
  CompilerEndIf

If OpenWindow(0, 100, 200, 700, 600, "GoScintilla demo!", #PB_Window_SystemMenu | #PB_Window_MinimizeGadget | #PB_Window_ScreenCentered)
  RemoveKeyboardShortcut(0, #PB_Shortcut_Tab) ;Required for the tab key to function correctly when the Scintilla control has the focus.

  ;Create a menu to allow the user to add bookmarks etc.
    If CreateMenu(0, WindowID(0))
      MenuTitle("Edit")
      MenuItem(#menu_AddRemoveMarker, "Add/Remove Marker" + #TAB$ + "Ctrl+F2")
      MenuItem(#menu_JumpToMarker, "Jump to Marker" + #TAB$ + "F2")
      MenuItem(#menu_ClearMarkers, "Clear Markers")
    EndIf
    AddKeyboardShortcut(0, #PB_Shortcut_Control|#PB_Shortcut_F2, #menu_AddRemoveMarker)
    AddKeyboardShortcut(0, #PB_Shortcut_F2, #menu_JumpToMarker)

  ;Create our Scintilla control. Note that we do not specify a callback; this is optional for GoScintilla.
    GOSCI_Create(1, 10, 10, 680, 580, 0, #GOSCI_AUTOSIZELINENUMBERSMARGIN)

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
    ;First some commands. For this we simply use the old GOSCI_AddKeywords() function.
      GOSCI_AddKeywords(1, "Debug End If ElseIf Else EndIf For To Next Step Protected ProcedureReturn", #STYLES_COMMANDS)
    ;Now set up a ; symbol to denote a comment. Note the use of #GOSCI_DELIMITTOENDOFLINE.
    ;Note also that this symbol will act as an additional separator.
      GOSCI_AddDelimiter(1, ";", "", #GOSCI_DELIMITTOENDOFLINE, #STYLES_COMMENTS)
    ;Now set up quotes to denote literal strings.
      GOSCI_AddDelimiter(1, Chr(34), Chr(34), #GOSCI_DELIMITBETWEEN, #STYLES_LITERALSTRINGS)
    ;Now set up a # symbol to denote a constant. Note the use of #GOSCI_LEFTDELIMITWITHOUTWHITESPACE.
      GOSCI_AddDelimiter(1, "#", "", #GOSCI_LEFTDELIMITWITHOUTWHITESPACE, #STYLES_CONSTANTS)
    ;Now set up a ( symbol to denote a function. Note the use of #GOSCI_RIGHTDELIMITWITHWHITESPACE.
      GOSCI_AddDelimiter(1, "(", "", #GOSCI_RIGHTDELIMITWITHWHITESPACE, #STYLES_FUNCTIONS)
    ;We arrange for a ) symbol to match the coloring of the ( symbol. We have to add this as a separator later on.
      GOSCI_AddDelimiter(1, ")", "", 0, #STYLES_FUNCTIONS)

    ;Add some folding keywords.
      GOSCI_AddKeywords(1, "Procedure Macro", #STYLES_COMMANDS, #GOSCI_OPENFOLDKEYWORD)
      ;Note the final parameter (optional) which we set to #True in order to have the keywords sorted into alphabetic order.
      ;We do this for code-completion and the fact that we have not added the keywords ourselves in alphabetic order etc.
      GOSCI_AddKeywords(1, "EndProcedure EndMacro", #STYLES_COMMANDS, #GOSCI_CLOSEFOLDKEYWORD)

  ;Additional lexer options.
  ;=========================
      ;Note that we do not need to include the ( and ) separators in this case as we have marked them as delimiters (above) which
      ;automatically default to separators.
        GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_SEPARATORSYMBOLS, @"=+-*/%[],.#)") ;You would use GOSCI_AddKeywords() to set a style for some of these if required.
      GOSCI_SetLexerOption(1, #GOSCI_LEXEROPTION_NUMBERSSTYLEINDEX, #STYLES_NUMBERS)

  ;Bookmarks.
  ;==========
    ;First set the bookmark margin's width. If you don't do this then bookmarked line will be highlighted in the bookmark
    ;back color.
      GOSCI_SetMarginWidth(1, #GOSCI_MARGINBOOKMARKS, 20)  ;N.B. #GOSCI_MARGINBOOKMARKS equates to the non folding symbols margin.
    ;Let's set a bookmark fore color.
      GOSCI_SetColor(1, #GOSCI_BOOKMARKFORECOLOR, #Gray)
    ;The default bookmark symbol is a short arrow. Let's change that.
      GOSCI_SetAttribute(1, #GOSCI_BOOKMARKSYMBOL, #SC_MARK_ARROWS)

  ;Set some initial text.
  ;======================
    text$ = "; GoScintilla 2.0." + #CRLF$
    text$ + "; Try out the new bookmarks! Go ahead, use the menu!" + #CRLF$ + #CRLF$
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
      Case #PB_Event_Menu
        Select EventMenu()
          Case #menu_AddRemoveMarker
            currentLine = GOSCI_GetState(1, #GOSCI_CURRENTLINE)
            currentBookmark = GOSCI_GetLineBookmark(1, currentLine)
            If currentBookmark
              GOSCI_SetLineBookmark(1, currentLine, #False) ;Remove existing bookmark.
            Else
              GOSCI_SetLineBookmark(1, currentLine) ;Add a new bookmark.
            EndIf
          Case #menu_JumpToMarker
            ;Here we search for the next marker. If none are found we begin again at the beginning of the document.
              currentLine = GOSCI_GetState(1, #GOSCI_CURRENTLINE)
              newLine = GOSCI_FindBookmarkedLine(1, currentLine+1)
              If newLine = -1
                newLine = GOSCI_FindBookmarkedLine(1, 0)
              EndIf
              If newLine <> -1 And newLine <> currentLine
                GOSCI_SetState(1, #GOSCI_CURRENTLINE, newLine)
              EndIf
          Case #menu_ClearMarkers
            GOSCI_SetState(1, #GOSCI_CLEARALLBOOKMARKS)
        EndSelect
    EndSelect
  Until eventID = #PB_Event_CloseWindow 

  ;Free the Scintilla gadget.
  ;This needs explicitly calling in order to free resources used by GoScintilla.
    GOSCI_Free(1)
EndIf


; IDE Options = PureBasic 4.61 (Windows - x86)
; CursorPosition = 14
; EnableUnicode
; EnableThread
; EnableXP
; Executable = t.exe