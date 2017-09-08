GoScintilla History
===================

**GoScintilla** was created by Stephen Rodriguez (aka [**@srod**](http://www.purebasic.fr/english/memberlist.php?mode=viewprofile&u=678) and **nxSoftWare**). **GoScintilla** license terms are:

> **License**
>
> License, what license? Do as you like with this code; use it, study it, laugh at it, eat it… so many choices! :)

**GoScintilla 3** is maintained by Tristano Ajmone at **The PureBASIC Archives** on GitHub:

-   <https://github.com/tajmone/purebasic-archives>

It was released under the **WTFPL** (Do What the Fuck You Want to Public License) license terms:

-   <http://www.wtfpl.net/>

------------------------------------------------------------------------

<!-- #toc -->
-   [GoScintilla v3](#goscintilla-v3)
    -   [v3.0.1 (2017-09-08)](#v301-2017-09-08)
    -   [v3.0 (2017-01-02)](#v30-2017-01-02)
-   [GoScintilla v2](#goscintilla-v2)
    -   [v2.7 (2012-08-11)](#v27-2012-08-11)
    -   [v2.6 (2012-06-16)](#v26-2012-06-16)
    -   [v2.5 (2012-05-05)](#v25-2012-05-05)
    -   [v2.4 (2012-05-03)](#v24-2012-05-03)
    -   [v2.3 (2011-04-04)](#v23-2011-04-04)
    -   [v2.2 (2010-09-07)](#v22-2010-09-07)
    -   [v2.1 (2010-07-22)](#v21-2010-07-22)
    -   [v2.0 beta 5 (2010-06-13)](#v20-beta-5-2010-06-13)
    -   [v2.0 beta 4 (2010-05-18)](#v20-beta-4-2010-05-18)
    -   [v2.0 (beta 3)](#v20-beta-3)
    -   [v2.0 (beta 2)](#v20-beta-2)
-   [GoScintilla v1](#goscintilla-v1)
    -   [v1.0 (2010-01-07)](#v10-2010-01-07)
    -   [v1.0 beta 5 (2009-12-01)](#v10-beta-5-2009-12-01)
    -   [v1.0 beta 4 (2009-11-30)](#v10-beta-4-2009-11-30)
    -   [v1.0 beta 3 (2009-11-28)](#v10-beta-3-2009-11-28)
    -   [v1.0 beta 2 (2009-11-27)](#v10-beta-2-2009-11-27)

<!-- /toc -->

------------------------------------------------------------------------

GoScintilla v3
==============

Forked by Tristano Ajmone.

v3.0.1 (2017-09-08)
-------------------

-   BUGFIX: **@srod** fixed a bug in `GOSCI_Free()` that caused crashes on Windows — see [Issue \#1](https://github.com/tajmone/purebasic-archives/issues/1) (thanks to [@MikeHart66](https://github.com/MikeHart66) for pointing it out!).

v3.0 (2017-01-02)
-----------------

**GoScintilla** version 3.0, 2nd Jan 2017.

by Tristano Ajmone.

-   `GoScintilla.pbi` source was slightly readapted to work with PureBasic 5.5x (it didn’t compile due to a pointer being assigned a native type, and a PB constant having been renamed since).

-   These changes make **GoScintilla** compatible with PB &gt;= 5.10.

-   Version moved to 3.0 because these changes — small as they are — will break backward compatibility with version of PureBasic &lt; 5.10.

-   Tristano Ajmone takes on maintainance of **GoScintilla 3** at [**The PureBASIC Archives**](https://github.com/tajmone/purebasic-archives) on GitHub.

-   Having contacted Stephen Rodriguez about permissions for this project, and having got further confirmation that I could “do what I wanted with it”, a license is assigned to this new project, in order to satisfy GitHub’s legal requirements regarding reuse 3rd party code. Therefore, in line with the original license statement “Do as you like with this code”, **GoScintilla 3** is released under the terms of the **WTFPL** (Do What the Fuck You Want to Public License):

    -   <http://www.wtfpl.net/>

    This license is the closest I could find to the original license terms statement of Rodriguez, and is 100% compatible with its intents, at the same time allowing to retain the author copyright statement and being a widely reckognized software license.

-   Comments in source files have been changed to reflect new version number, project and repository info, and **WTFPL** license terms.

> **NOTE**: No other code changes done so far, but there might be some more optimizations to carry out in the future since PureBasic &gt;= 5.5x no longer supports ASCII mode for internal PureBasic string representation.

GoScintilla v2
==============

v2.7 (2012-08-11)
-----------------

**GoScintilla** version 2.7, 11th Aug 2012.

-   Added a search facility via a new function: `GOSCI_Search()`.

    USe one of the constants `#GOSCI_SEARCHBACKWARDS` or `#GOSCI_SEARCHFORWARDS` to specify the direction of the search.

-   Added a facility for marking ‘errors’ in a given line by setting the line’s back color (much like the PB editor does).

    Functions:

    -   `GOSCI_SetLineError()`.

    Constants:

    -   `#GOSCI_MARGINERROR` — an alias for `#GOSCI_MARGINBOOKMARK`s which is an alias for `#GOSCI_MARGINNONFOLDINGSYMBOLS`.
    -   `#GOSCI_ERRORBACKCOLOR` — for use with `GOSCI_SetColor()`.
    -   `#GOSCI_CLEARERRORS` — for use with `GOSCI_SetState()`.

    New demo added to show how to use these error markers.

v2.6 (2012-06-16)
-----------------

**GoScintilla** version 2.6, 16th June 2012.

-   More problems with code folding has led to some alterations of the GoScintilla lexer.

v2.5 (2012-05-05)
-----------------

**GoScintilla** version 2.5, 5th May 2012.

-   Added an optional parameter (`restyle` = `#True`) to certain functions which can be used to stop GoScintilla redrawing a control’s contents

    whilst we set/reset individual style parameters. Useful if you are altering styles after loading text into a control, otherwise every single alteration will result in the entire document being restyled which can result in some serious delays if there is a lot of text loaded into the control.

    You can of course use the `GOSCI_SetState()` function to restyle the entire document when you are done making alterations.

    No existing code will be broken by these changes.

    The help manual has been updated.

    Thanks to Tenaja.

v2.4 (2012-05-03)
-----------------

**GoScintilla** version 2.4, 3rd May 2012.

-   Major bug fixed with code folding.

v2.3 (2011-04-04)
-----------------

**GoScintilla** version 2.3, 4th April 2011.

-   Bug fixed with `GOSCI_InsertLineOfText()`. Thanks Dobro.

v2.2 (2010-09-07)
-----------------

**GoScintilla** version 2.2, 7th September 2010.

-   Added a new keyword flag:

    `#GOSCI_OPENFOLDKEYWORDNOPRECEDING`

    This marks the keyword as an open-fold keyword with the proviso that it will only open a new fold on any given line if this symbol is not preceded by any other open-fold keyword

v2.1 (2010-07-22)
-----------------

**GoScintilla** version 2.1, 22nd July 2010.

-   Fixed a couple of bugs with call-tips and with the `GOSCI_InsertLineOfText()` function.

-   New function added:

    `GOSCI_CopyLexerFromExistingControl()`

    See the user manual for a description of this function.

v2.0 beta 5 (2010-06-13)
------------------------

**GoScintilla** version 2.0 beta 5, 13th June 2010.

-   Added a new state option:

    `#GOSCI_RESTYLEDOCUMEN`T which can be used with `GOSCI_SetState()` to force a restyling of the document being edited.

    NOTE that many operations (such as setting document text) automatically restyle the document anyhow.

v2.0 beta 4 (2010-05-18)
------------------------

**GoScintilla** version 2.0 (beta 4), 18th May 2010.

-   Added a new lexer state bit:

    `#GOSCI_LEXERSTATE_ENABLECLICKANYWHERECODEFOLDING`

v2.0 (beta 3)
-------------

**GoScintilla** version 2.0 (beta 3).

-   Fixed a code folding bug.

v2.0 (beta 2)
-------------

**GoScintilla** version 2.0 (beta 2). Major update.

Will run with versions of Purebasic from 4.5 onwards.

-   New constant `#GOSCI_MARGINBOOKMARKS` is simply an alias for `#GOSCI_MARGINNONFOLDINGSYMBOLS`.

    If GoScintilla’s bookmarks are used (GoScintilla 2) then do not use this margin for any other markers etc. Use one of the two user margins.

-   Renamed the structure `GoScintillaKeywords` to `GoScintillaKeyword` and updated the structure fields.

-   Removed the function `GOSCI_GotoLine()`.

    Use `GOSCI_SetState(id, #GOSCI_CURRENTLINE, lineNumber)` instead (see below).

-   Removed the function `GOSCI_IsEmpty()`.

    Use `GOSCI_GetState(id, #GOSCI_ISEMPTY) instead`.

-   New functions:

    `GOSCI_GetState(id, stateType)` and `GOSCI_SetState(id, stateType, value=0)`

    Use these to retrieve or set various control states as directed by the following constants :

    ``` nohighlight
     #GOSCI_CURRENTLINE          Get/Set
     #GOSCI_ISMODIFIED           Get
     #GOSCI_DOCUMENTSAVED        Set
    (#GOSCI_CLEARMODIFIEDSTATE = #GOSCI_DOCUMENTSAVEDSTATE)
     #GOSCI_EMPTYUNDOBUFFER      Set
     #GOSCI_ISREADYTOREDO        Get
     #GOSCI_ISREADYTOUNDO        Get
     #GOSCI_ISEMPTY              Get
     #GOSCI_CLEARALLBOOKMARKS    Set
    ```

-   New functions (bookmarks):

    -   `GOSCI_GetLineBookmark(id, lineIndex)`
    -   `GOSCI_SetLineBookmark(id, lineIndex, flag=#True)`
    -   `GOSCI_FindBookmarkedLine(id, startLine, direction=1)`

-   Removed the creation flag:

    `#GOSCI_ALLOWCODEFOLDING`

    Instead, a new set of ‘lexer state’ flags (see below) have been added and code folding (amongst other things) can now be turned on or off dynamically.

-   New lexer state flags :

    ``` nohighlight
    #GOSCI_LEXERSTATE_ENABLESYNTAXSTYLING   (set by default)
    #GOSCI_LEXERSTATE_ENABLECODECOMPLETION  (new)
    #GOSCI_LEXERSTATE_ENABLECODEFOLDING (new, set by default)
    #GOSCI_LEXERSTATE_ENABLECALLTIPS    (new)
    #GOSCI_LEXERSTATE_ENABLEAUTOINDENTATION (new)
    ```

    for use with `GOSCI_GetLexerState()` and `GOSCI_SetLexerState()`.

    These allow for dynamically setting/removing of the various lexer options. For example, you can temporarily remove code folding etc.

-   New lexer function:

    `GOSCI_RemoveKeywords(id, keyWords$)` which is used to remove a list of (space separated) keywords/delimiters from the specified Scintilla control.

-   New lexer function:

    `GOSCI_AddDelimiter(id, delimiter$, closeDelimiter$, delimiterFlags, styleIndex=#STYLE_DEFAULT)`

    Use this function to add delimiters (and set a style index for the delimiter). DO NOT use the `GOSCI_AddKeywords()` function for this purpose.

    Valid delimiter types :

    ``` nohighlight
    #GOSCI_DELIMITBETWEEN 
    #GOSCI_DELIMITTOENDOFLINE
    #GOSCI_LEFTDELIMITWITHWHITESPACE
    #GOSCI_LEFTDELIMITWITHOUTWHITESPACE
    #GOSCI_RIGHTDELIMITWITHWHITESPACE
    #GOSCI_RIGHTDELIMITWITHOUTWHITESPACE
    #GOSCI_NONSEPARATINGDELIMITER.
    ```

    You can combine one left delimiter with one right delimiter if required.

-   Altered the `GOSCI_AddKeywords()` function so that it now has the following prototype:

    `GOSCI_AddKeywords(id, keyWords$, styleIndex=#STYLE_DEFAULT, keywordflags=0, blnSortKeywords=#False)`

    THis function can no longer be used to add delimiters. Use `GOSCI_AddDelimiter()` for that.

    1.  `keyWordFlags` can be a combination of the (new) keyword flags:

        ``` nohighlight
        #GOSCI_OPENFOLDKEYWORD
        #GOSCI_CLOSEFOLDKEYWORD
        #GOSCI_ADDTOCODECOMPLETION  
        ```

    2.  Set `blnSortKeywords` to `#True` only if code completion is being used and you wish keywords to be listed in alphabetical order (when code completion lists are displayed). Use only if keywords have not been added in alphabetical order.

        The obvious advice is to set this parameter to `#True` only with the final use of this function (where possible).

-   Added a new lexer function:

    `GOSCI_AddKeywordsEx()` which is for use when adding keywords having associated call-tips.

    This function allows us to add a list of keywords together with an (optional) list of call-tips.

    It has the prototype:

    `GOSCI_AddKeywordsEx(id, numKeywords, *ptrKeywords.STRING, *ptrCallTips.STRING=0, openCallTipSeparators$ = "", closeCallTipSeparators$="", styleIndex=#STYLE_DEFAULT, keywordFlags=0, blnSortKeywords=#False)`

    `*ptrKeywords` and `*ptrCallTips` (if provided) point to string arrays with numKeywords elements.

    If `*ptrCallTips` is non-zero then `openCallTipSeparators$` and `closeCallTipSeparators$` hold non-empty lists of call-tip separators for use with the keywords. Every open call-tip separator must have an accompanying close call-tip separator. A space character used as part of the `openCallTipSeparators$` means that any symbol will result in the call-tip being displayed.

    In addition to the keyword flags listed above, you can also use: `#GOSCI_ALLOWWHITESPACEPRECEEDINGOPENCALLTIP`.

    This new function otherwise operates in a similar way to `GOSCI_AddKeywords()` except that it does not use a space separated list of keywords.

-   Added a new lexer function:

    `GOSCI_AddGlobalCalltipSeparators(id, openCallTipSeparators$, closeCallTipSeparators$, flags)`

    This function adds additional call-tip separators not tied to any individual keyword and instead assume global significance. The choices are a null call-tip or a terminal call-tip through the flags parameter and the following constants:

    ``` nohighlight
    #GOSCI_NULLCALLTIP
    #GOSCI_TERMINALCALLTIP
    ```

    Null call-tip separators are useful to ensure that certain lexical elements register as call-tips even though they do not display a call-tip. For example, in “`Abs(xxx())`” where `Abs()` has a call-tip, but `xxx()` does not, then we would register `()` as null call-tip separators. This ensures that the first close paranthesis does not close the `Abs()` call-tip.

    Terminal call-tip separators cancel all preceeding call-tips regardless of how many call-tips are currently nested. Useful for symbols (such as Purebasic’s: symbol) which break lines.

-   The `#GOSCI_LEXEROPTION_SEPARATORSYMBOLS` lexer option must be set BEFORE any use of `GOSCI_AddKeywordsEx()` or `GOSCI_AddGlobalCalltipSeparators()` to set call-tipped keywords. Any subsequent setting of this lexer option will destroy call-tips and so you will have to add the underlying keywords again.

-   New attribute:

    `#GOSCI_CODECOMPLETIONCHARS` which can be retrieved with `GOSCI_GetAttribute()` and set with `GOSCI_SetAttribute()`.

    This attribute governs how many characters are required to be typed before a code completion listbox is displayed etc.

    The default value is `#GOSCI_DEFAULTCODECOMPLETIONCHARS` (main source file).

-   New attribute:

    `#GOSCI_BOOKMARKSYMBOL` for use with `GOSCI_SetAttribute()` only.

    Use one of Scintilla’s marker symbols constants: `SC_MARK_CIRCLE`, `SC_MARK_ROUNDRECT`,… etc. Default is `#SC_MARK_SHORTARROW`.

-   New color constants for use with `GOSCI_GetColor()` and `GOSCI_SetColor()`:

    ``` nohighlight
    #GSCI_CALLTIPBACKCOLOR      - get/set   
    #GSCI_CALLTIPFORECOLOR      - get/set
    #GOSCI_CALLTIPFOREHLTCOLOR  - set
    #GOSCI_BOOKMARKBACKCOLOR    - set
    #GOSCI_BOOKMARKFORECOLOR    - set.
    ```

GoScintilla v1
==============

v1.0 (2010-01-07)
-----------------

**GoScintilla** version 1.0, 7th Jan 2010.

-   Fixed a bug with the Lexer and added a second version of the ‘Block comments’ advanced demo.

v1.0 beta 5 (2009-12-01)
------------------------

**GoScintilla** version 1.0 beta 5, 1st Dec 2009.

-   Added function:

    `GOSCI_GetNextSymbolByteLength(id, *bytePtr.ASCII, numBytesRemaining)`

    Use this function from within a user-defined line styling function in order to determine the number of bytes in the ‘symbol’ pointed to by the `*bytePtr` parameter.

v1.0 beta 4 (2009-11-30)
------------------------

**GoScintilla** version 1.0 beta 4, 30th Nov 2009.

This update has been motivated by a desire to allow for automatic code folding of multi-word keywords such as “Function” and “End Function” etc.

GoScintilla’s lexer will only work with single word keywords and thus cannot natively support combinations such as “End Function” as representing a close-fold terminal.

Extending GoScintilla’s lexer to allow this is not an option as it will slow things down (in my judgement) too much. Instead, we can make use of a user-defined line styling function to supplement the lexer’s capabilities.

-   Added functions:

    `GOSCI_DecFoldLevel(id)` and `GOSCI_IncFoldLevel(id)` to be used within a user-defined line styling function only.

-   Added an additional demo program “**Multiword**” to demonstrate how to use a very simple user-defined line styling function together with the new functions to implement code folding on the aforementioned “Function” and “End Function” etc.

v1.0 beta 3 (2009-11-28)
------------------------

**GoScintilla** version 1.0 beta 3, 28th Nov 2009.

-   Added functions:

    `GOSCI_GetLexerState(id)` and `GOSCI_SetLexerState(id, state)`

    At present these can be used to disable/enable syntax styling only.

v1.0 beta 2 (2009-11-27)
------------------------

**GoScintilla** version 1.0 beta 2, 27th Nov 2009.

-   Fixed a bug with `GOSCI_Create()` (it wasn’t returning any value!)

-   Added function:

    `GOSCI_ReplaceSelectedText(id, text$, blnScrollCaretIntoView=#False)`

-   Modified the `GOSCI_SetText()` function by the addition of an optional parameter; clearUndoStack (default `#False`).

    Set to non-zero to have the undo stack cleared so that this operation cannot be undone.

-   Added a new get/set attribute:

    `#GOSCI_WRAPLINES`

    Turn wrapping lines on/off.

-   Added a new get/set attribute:

    `#GOSCI_WRAPLINESVISUALMARKER`

    Give wrapped lines a visual marker.

-   By default, all delimiter characters are also regarded as separators. This can now be over-ruled when adding deleimiter keywords by using the new `#GOSCI_NONSEPARATINGDELIMITER` flag.

    This was added to allow one type of delimiter to be styled as part of another delimiter (e.g. \#Constant$ in which both \# and $ are delimiters and the styling attributed to \# is to be applied to the entire symbol. This will require $ to be marked as a non-separating delimiter).


