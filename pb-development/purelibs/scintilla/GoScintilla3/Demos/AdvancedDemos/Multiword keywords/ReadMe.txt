GoScintilla 2.
============

"REM" demo.


This demo is primarily intended to demonstrate the use of a 'user-defined line styling function' in order to supplement GoScintilla 2's lexer to add functionality which the lexer does not natively support.

In this case we show how to extend the lexer so that it can recognise that a REM statement denotes a comment and style the remainder of the line appropriately.
This kind of thing would normally by achieved through a #GOSCI_DELIMITTOENDOFLINE delimiter, but such delimiters are restricted to single characters only.

It really is intended for 'advanced users' only. Those users very comfortable with Purebasic.



Background.
-----------
GoScintilla 2's lexer natively supports single-character delimiters and separators only and thus, in terms of syntax styling, can not recognise statements such as 'REM' as denoting a lexical entity requiring the remainder of the underlying line to be styled accordingly.



This demo, uses a very simple user-defined line styling function in order to circumvent this limitation.



Algorithm.
----------
First, our demo sets up our custom styles, keyword lists and lexer options as appropriate. We use a very limited set of keywords just to keep things simple in this demo and to thus not detract from the main task of demonstrating the user-defined line styling functions etc.

Note that we necessarily add "Rem" to a keyword list because we require GoScintilla 2 to recognise this symbol.

Next, we use the GOSCI_SetLineStylingFunction() function to register our user defined line styling function which we have named myLineStyler().

Note the parameters taken by this function; id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine.

The final 3 parameters are for information only.

Our line styling function is of course invoked by GoScintilla 2 in response to it being notified by the Scintilla library that a range of text requires restyling. Our function is called once for each line to be styled.
 Once we have finished with an individual line, we return control back to GoScintilla with one of two codes : #GOSCI_STYLELINESASREQUIRED or #GOSCI_STYLENEXTLINEREGARDLESS as appropriate.

When called, our line styling function immediately enters a loop in which each 'symbol' within the line being styled is passed to GoScintilla's lexer for styling. We are interested only in occurrences of the 'Rem' keyword and so why not let GoScintilla 2's lexer handle the styling?

After each symbol has been styled, we take a closer look at it to see if it is the word "rem"? If so, we then take over (albeit temporarily) and style the remainder of the line 
(excluding any #LF or #CR characters) to match the comment styling.

And that is basically it!


Regards.


