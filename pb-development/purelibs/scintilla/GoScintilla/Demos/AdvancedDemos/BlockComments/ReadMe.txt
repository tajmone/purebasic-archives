GoScintilla.
============

"BlockComments" demo.


This demo is primarily intended to demonstrate the use of a 'user-defined line styling function' in order to supplement GoScintilla's lexer to add functionality which the lexer does not natively support.

In this case we show how to extend the lexer so that it can automatically style multiline block comments as supported by programming languages such as C and PHP etc.

It really is intended for 'advanced users' only. Those users very comfortable with Purebasic.



Background.
-----------
GoScintilla's lexer natively supports single character separators and delimiters and thus, in terms of automatically styling comments (for example), can only do so when a comment is signalled by the presence of a single character. Indeed, one of our demos (a Purebasic syntax demo) uses the semi-colon as a 'delimit up to the end of the line'
type delimiter. This enables GoScintilla to apply one of our custom styles to all text on a line following a semi-colon etc.

This is fine for programming languages whose syntax allows only single line comments delimited by a single character.
Other programming languages using multi-line block comments are thus not natively supported by GoScintilla. Neither are those using multi-character comment delimiters.


C, of course, uses both with multi-line comments being delimited by /* and */ etc.



This demo, uses a user-defined line styling function in order to circumvent this limitation.


NOTE that whilst the demo is geared for C syntax editing, it is by no means suitable for such uses in that, for example, GoScintilla's lexer could not recognise C's -> operator. For that, we would need to adjust our user-defined line styling function.



Algorithm.
----------
First, our demo sets up our custom styles, keyword lists and lexer options as appropriate.

Next, we use the GOSCI_SetLineStylingFunction() function to register our user defined line styling function which we have named myLineStyler().

Note the parameters taken by this function; id, *utf8Buffer.ASCII, numUtf8Bytes, currentLine, startLine, originalEndLine.

The final 3 parameters are for information only.

Our line styling function is of course invoked by GoScintilla in response to it being notified by the Scintilla library that a range of text requires restyling. Our function is called once for each line to be styled.
 Once we have finished with an individual line, we return control back to GoScintilla with one of two codes : #GOSCI_STYLELINESASREQUIRED or #GOSCI_STYLENEXTLINEREGARDLESS as appropriate.

When invoked, our function checks if the end of the previous line (if we are not styling line 0) has been commented out due to the user entering a /* symbol. This information is stored (in boolean form) alongside the line by using the GOSCI_SetLineData() function and retrieved using the GOSCI_GetLineData() function.

If it transpires that the end of the previous line has been commented (with no terminating */ marker) then we know that at the very least, the current line begins with some commented text. We thus call a utility function named myStylerUtility_StyleCommentPart() which will proceed to style the commented part of the line as appropriate. This utility will continue to the end of the line or until it finds a terminating */ marker, whatever occurs first. On return it informs our main function as to the number of bytes styled and also whether a terminating */ was encountered.

On return to the main function, note how the number of bytes remaining to be styled is adjusted as appropriate.

Our main function now knows that if there still remains a part of the line to be styled, then the remaining character bytes at least begin with symbols that are not to be commented.

It then proceeds to examine the rest of the line. Each 'symbol' to be styled is examined and if it does not begin with /* characters, the symbol is passed back to GoScintilla's lexer for styling (using the GOSCI_StyleNextSymbol() function). If the /* characters are encountered then our line styler once again calls the 
myStylerUtility_StyleCommentPart() utility function to style any commented part of the line.

And this basic process is repeated in a loop until the end of the line is encountered.

When done, we make a note of whether the end of the current line (and thus the beginning of the next line) is commented by placing the aforementioned boolean value within the line's user-data value (GOSCI_SetLineData()).

Finally, we either return #GOSCI_STYLELINESASREQUIRED or #GOSCI_STYLENEXTLINEREGARDLESS as appropriate depending on whether the line's 'commented state' has changed.
 For example, if the line has switched from being uncommented to commented, then we return #GOSCI_STYLENEXTLINEREGARDLESS in order to ensure that the next line is styled because this line may have to switch commented state as well.

And that is basically it!


Regards.


