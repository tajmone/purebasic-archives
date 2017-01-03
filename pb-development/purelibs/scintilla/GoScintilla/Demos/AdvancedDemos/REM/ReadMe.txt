GoScintilla.
============

"Multiword" demo.


This demo is primarily intended to demonstrate the use of a 'user-defined line styling function' in order to supplement GoScintilla's lexer to add functionality which the lexer does not natively support.

In this case we show how to extend the lexer so that it can automatically recognise multi-word folding keywords; in this case "Function" and "End Function" etc.

It really is intended for 'advanced users' only. Those users very comfortable with Purebasic.



Background.
-----------
GoScintilla's lexer natively supports single-word keywords only and thus, in terms of code-folding, can not recognise constructs such as 'End Function' as denoting a close-fold terminal.



This demo, uses a very simple user-defined line styling function in order to circumvent this limitation.



Algorithm.
----------
First, our demo sets up our custom styles, keyword lists and lexer options as appropriate. We use a very limited set of keywords just to keep things simple in this demo and to thus not detract from the main task of demonstrating the user-defined line styling functions etc.

Note that we do not attempt to add either "Function" or "End Function" as folding keywords. We leave that for our own line-styling function.

Next, we use the GOSCI_SetLineStylingFunction() function to register our user defined line styling function which we have named myLineStyler().

Note the parameters taken by this function; id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine.

The final 3 parameters are for information only.

Our line styling function is of course invoked by GoScintilla in response to it being notified by the Scintilla library that a range of text requires restyling. Our function is called once for each line to be styled.
 Once we have finished with an individual line, we return control back to GoScintilla with one of two codes : #GOSCI_STYLELINESASREQUIRED or #GOSCI_STYLENEXTLINEREGARDLESS as appropriate.

When called, our line styling function immediately enters a loop in which each 'symbol' within the line being styled is passed to GoScintilla's lexer for styling. We are interested only in the code folding and so why not let GoScintilla's lexer handle the styling?

After each symbol has been styled, we take a closer look at it to see if it is the word "function"? If so, we then look at the previous non-whitespace symbol to see if it was an "end". If so, we invoke the GOSCI_DecFoldLevel() function to decrease the current line's fold level as appropriate for a close-fold keyword. Otherwise we invoke the GOSCI_IncFoldLevel() function to increase the current line's fold level as appropriate for an open-fold keyword.


And that is basically it!


Regards.


