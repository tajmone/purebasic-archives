PureBASIC
---------

PureBASIC CSS Theme based on the original [`purebasic.css`](https://github.com/isagalaev/highlight.js/blob/master/src/styles/purebasic.css) by Tristano Ajmone (extended to include PB mod extra lang token).

``` purebasic
Enumeration Test 3 Step 10
  #Constant_One ; Will be 3
  #Constant_Two ; Will be 13
EndEnumeration

A.i = #Constant_One
B = A + 3

STRING.s = SomeProcedure("Hello World", 2, #Empty$, #Null$)
ESCAPED_STRING$ = ~"An escaped (\\) string!\nNewline..."

FixedString.s{5} = "12345"

Macro XCase(Type, Text)
  Type#Case(Text)
EndMacro

StrangeProcedureCall ("This command is split " +
                      "over two lines") ; Line continuation example

If B > 3 : X$ = "Concatenation of commands" : Else : X$ = "Using colons" : EndIf

Declare.s Attach(String1$, String2$)

Procedure.s Attach(String1$, String2$)
  ProcedureReturn String1$+" "+String2$
EndProcedure
```

### PureBASIC Pseudocode

PureBASIC Pseudocode is and additional CSS class used with syntax-usage examples.

<pre class="purebasic pseudocode"><code>Interface <Name1> [Extends <Name2>]
  [Procedure1]
  [Procedure2]
  ...
EndInterface
</code></pre>
To enable PB Pseudocode in HTML, add “pseudocode” after “purebasic” (separated by a space) in the `class` attribute of the `<code>` tag:

``` nohighlight
<pre class="purebasic pseudocode"><code>
```

In Pandoc’s markdown, you can use this syntax (which might not work with other markdown parsers):

``` nohighlight
 ``` {.purebasic .pseudocode}
```

For other markdown flavors/parsers, check the relevant documentation. Basically, what you want to achieve is to have both “purebasic” and “pseudocode” to appear as classnames in the final html’s `<code>` tag.

Most likely, you’ll have to resort to raw HTML tags within your markdown source in order to achieve this (this is the way it’s being done in this document, which uses GFM).
