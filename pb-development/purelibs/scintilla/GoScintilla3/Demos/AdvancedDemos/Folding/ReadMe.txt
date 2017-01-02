GoScintilla 2.
============

"Folding" demo.


This demo is primarily intended to demonstrate the use of a 'user-defined line styling function' in order to supplement GoScintilla 2's lexer to add functionality which the lexer does not natively support.

In this case we show how to extend the lexer so that alongside it recognising a ' symbol as a comment (via a #GOSCI_DELIMITTOENDOFLINE delimiter) we can also utilise '{ and '} as open/close folding keywords as well. GoScintilla 2 can not deal with this without our assistance because marking ' as a delimiter subsequently prevents '{ being recognised as a keyword because the ' symbol will act as a separator.


Background.
-----------


Algorithm.
----------
First, our demo sets up our custom styles, keyword lists and lexer options as appropriate. We use a very limited set of keywords just to keep things simple in this demo and to thus not detract from the main task of demonstrating the user-defined line styling functions etc.

Next, we use the GOSCI_SetLineStylingFunction() function to register our user defined line styling function which we have named myLineStyler().

Note the parameters taken by this function; id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine.

The final 3 parameters are for information only.

Our line styling function is of course invoked by GoScintilla 2 in response to it being notified by the Scintilla library that a range of text requires restyling. Our function is called once for each line to be styled.
 Once we have finished with an individual line, we return control back to GoScintilla with one of two codes : #GOSCI_STYLELINESASREQUIRED or #GOSCI_STYLENEXTLINEREGARDLESS as appropriate.

When called, our line styling function immediately enters a loop in which each 'symbol' within the line being styled is passed to GoScintilla's lexer for styling. We are interested only in occurrences of the '{ and '} symbols and so why not let GoScintilla 2's lexer handle the styling?

After each symbol has been styled, we take a closer look at it to see if it began with either '{ or '} and, if so, adjusted the line's fold-level as appropriate.

And that is basically it!


Regards.


