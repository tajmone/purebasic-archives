Introduction
============

I wrote this doc because I saw many people asking lots of questions on FASM board because they’re’ understanding the genarl idea of the preprocessor, or one of its specific features. (I’m not discouraging you from asking anything on the forum — failing to understand something is not a shame, and if your question isn’t too hard someone will surely answer it).

Please if you can’t understand something from this tutorial tell me about it on [my tutorial’s thread on FASM board](https://board.flatassembler.net/topic.php?t=1178), or via [email](mailto:vid@InMail.sk) if you prefer.

1. What Is a Preprocessor
=========================

A preprocessor is a program (or usually, part of the compiler) which modifies your source code before it is compiled. For example, if you use some piece of code very often, you can give it a name and tell preprocessor to replace that name with the piece of code each time it’s found.

Another example is when you want to simulate an instruction which doesn’t exist: using the preprocessor you can automatically replace it with a set of instructions yielding the same effect.

The preprocessor scans the source and replaces some things with others. But how do you tell it what should be preprocess? For this purpose, “preprocessor directives” are used. We will discuss them now.

The preprocessor doesn’t know anything about instructions, compiler directives, etc., it has its own set of directives and simply ignores parts of the source not meant for it.

2. Basic Preprocessing
======================

First, I shall describe basic preprocessing, which is performed on the file before any other preprocessing.

2.1. Comment `;`
----------------

Like in most assemblers, comments in FASM start with a semicolon (`;`). Everything else up to end of the line is ignored and removed from the source.

For example, the following source:

``` fasm
;fill 100h bytes at EDI with zeros
xor eax,eax ;zero value in eax
mov ecx,100h/4
rep stosd
```

… after preprocessing will become:

``` fasm
xor eax,eax
mov ecx,100h/4
rep stosd
```

<div class="alert">
**NOTE**: `;` can be also understood as a preprocessor operator which deletes all text beyond it, up to the end of that line.
</div>
<div class="alert">
**NOTE**: A line containing only a comment won’t be deleted, like in my example. It will become an empty line. I've skipped empty lines because of the text structure. This point will turn out to be important in the next chapter.
</div>
2.2. Line Break `\`
-------------------

If a line seems too long for you, you can “break” it with a backslash (“`\`”) symbol (or preprocessor operator). When a line ends with a `\`, the next line will be appended to current line.

Example:

``` fasm
db 1,2,3,\
   4,5,6,\
   7,8,9
```

… will be preprocessed to:

``` fasm
db 1,2,3,4,5,6,7,8,9
```

Of course a `\` inside strings or comments doesn’t concatenate lines: inside a string it’s interpreted as a string character (like everything else, except for the ending quote), and comments are deleted up to the end of line without inspecting what’s inside them.

There can’t be anything after the `\` in a line, except blank space and comment.

In the previous chapter I’ve mentioned that a line containing only a comment won’t be deleted, it will just become an empty line. That means, that code like this:

``` fasm
db 1,2,3,\
;   4,5,6,\   - commented
   7,8,9
```

… after preprocessing will become:

``` fasm
db 1,2,3
7,8,9
```

… thus raising an error. To solve a situation like this, you must place a line break before the comment:

``` fasm
db 1,2,3,\
\;   4,5,6     - validly commented
   7,8,9
```

… which will become:

``` fasm
db 1,2,3,7,8,9
```

… like we wanted.

2.3. Directive “`include`”
--------------------------

Its syntax:

``` fasm
include <quoted string - file name>
```

It will insert a text file into the source code. It allows you to break up the source code into multiple files. Of course, the inserted text will be preprocessed too. File path and name should be quoted (enclosed in `'`,`'` or `"`,`"`).

Examples:

``` fasm
include 'file.asm'
include 'HEADERS\data.inc'
include '..\lib\strings.asm'
include 'C:\config.sys'
```

You can also access environment variables enclosed in `%`,`%`:

``` fasm
include '%FASMINC%\win32a.inc'
include '%SYSTEMROOT%\somefile.inc'
include '%myproject%\headers\something.inc'
include 'C:\%myprojectdir%\headers\something.inc'
```

<div class="alert alert-warn">**TODO**: 1.52 paths system (someone could describe it for me…)
</div>
2.4. Strings Preprocessing
--------------------------

You might face problems including a `'` in a string declared using `'`s, or including a `"` in a string declared using `"`s. For this purpose you must place the character twice in the string; this won’t end the current string and begin a next one, as you may think, it will instead include the literal quote character in the string.

For example:

``` fasm
db 'It''s okay'
```

… will generate a binary containing string `It's okay`.

It’s same with `"`.

3. Equates
==========

3.1. Directive “`equ`”
----------------------

The simplest preprocessor command. It’s syntax:

``` fasm
<name1> equ <name2>
```

This command tells the preprocessor to replace every following occurrence of `<name1>` with `<name2>`.

Example, the source:

``` fasm
count equ 10  ;this is a preprocessor command
mov ecx,count
```

… is preprocessed to:

``` fasm
mov ecx,10
```

Example:

``` fasm
mov eax,count
count equ 10
mov ecx,count
```

… is preprocessed to:

``` fasm
mov eax,count
mov ecx,10
```

… because the preprocessor only replaces occurrences of `count` that come *after* the `equ` directive.

Even this works:

``` fasm
10 equ 11
mov ecx,10
```

… after preprocessing, it becomes:

``` fasm
mov ecx,11
```

Bare in mind that <mark>`name1` can be *any* symbol</mark>. A symbol is just a set of chars, terminated by a blank character (space, tab, end of line), a comment (`;`), a line-break (`\`) or an operator (including assembly-time operators, not just preprocessor operators). <mark>But it can’t be an operator or a special symbol</mark> (like `,` or `}`, etc.)

`name2` can be anything, not just one symbol: everything up to end of line is taken. It can even be empty, then `<name1>` is replaced with blank space.

Example:

``` fasm
10 equ 11,12,13
db 10
```

… becomes:

``` fasm
db 11,12,13
```

3.2. Directive “`restore`”
--------------------------

You can also tell the preprocessor to stop replacing a particular equate. This is achieved with the `restore` operator:

``` fasm
restore <name>
```

Where `<name>` is some equation. From this command onward, `<name>` will no longer be replaced as previously specified by `equ`.

Example:

``` fasm
mov eax,count
count equ 10
mov eax,count
restore count
mov eax,count
```

… becomes:

``` fasm
mov eax,count
mov eax,10
mov eax,count
```

Note that replacements are “stacked”: this means that if you define two equates for one symbol, and then restore it (once), the first one will be used.

Example:

``` fasm
mov eax,count
count equ 1
mov eax,count
count equ 2
mov eax,count
count equ 3
mov eax,count
restore count
mov eax,count
restore count
mov eax,count
restore count
mov eax,count
```

… becomes:

``` fasm
mov eax,count
mov eax,1
mov eax,2
mov eax,3
mov eax,2
mov eax,1
mov eax,count
```

If you try to restore a non-existing equation nothing will happen.

Example:

``` fasm
mov eax,count
restore count
mov eax,count
```

… becomes:

``` fasm
mov eax,count
mov eax,count
```

4. Simple Macros without Arguments
==================================

4.1. Simple Macro Definition
----------------------------

You can create your own instruction/directive using “`macro`”:

``` fasm
macro <name>
{
  <body>
}
```

When the preprocessor encounters a `macro` directive it defines a macro, which means that each following occurence of a line starting with `<name>` will be replaced by `<body>`. `<name>` must be a single symbol, `<body>` can be anything except `}` which denotes end of macro body.

Example:

``` fasm
macro a
{
  push eax
}
xor eax,eax
a
```

… becomes:

``` fasm
xor eax,eax
push eax
```

Example:

``` fasm
macro a
{
  push eax
}
macro b
{
  push ebx
}
b
a
```

… becomes:

``` fasm
push ebx
push eax
```

Of course, a macro doesn’t have to be indented like in my examples, you could also write it this way:

``` fasm
macro push5 {push dword 5}
push5
```

… which becomes:

``` fasm
push dword 5
```

Or even like this:

``` fasm
macro push5 {push dword 5
}
```

… producing the same result. You have freedom of style reagarding macros indentation.

4.2. Nested Macros
------------------

You can nest macros. This means that if you redefine a macro, then the last definition is used. But if you use the original macro inside the last one, it will still work. Look at this example:

``` fasm
macro a {mov ax,5}
macro a
{
  a
  mov bx,5
}
macro a
{
  a
  mov cx,5
}
a
```

… becomes:

``` fasm
mov ax,5
mov bx,5
mov cx,5
```

Or this example:

``` fasm
macro a {1}
a

macro a {
  a
  2}

a
macro a {
  a
  3}

a
```

… becomes:

``` fasm
1

1
2

1
2
3
```

4.3. Directive “`purge`” (macro undefinition)
---------------------------------------------

You can also undefine macros, like you undefined equate. This is acomplished with the `purge` directive followed by the macro’s name:

``` fasm
a
macro a {1}
a
macro a {2}
a
purge a
a
purge a
a
```

… becomes:

``` fasm
a
1
2
1
a
```

If you try to `purge` a non-existing macro nothing will happen.

4.4. Macros Behaviour
---------------------

A macro’s name will be replaced by the macro’s body not just when the line starts with the macro, but in every place where an instruction mnemonic (like `add`, `mov`) is accepted. It is because the main purpose of macros is to simulate instructions. The only exception is instruction prefix: <nark>a macro is not accepted after an instruction prefix</nark>.

Example:

``` fasm
macro CheckErr
{
  cmp eax,-1
  jz error
}
call Something
a: CheckErr    ;here macro name is preceded by label definition, but it
               ;will be replaced
```

… becomes:

``` fasm
call Something
a:
cmp eax,-1
jz error
```

Example:

``` fasm
macro stos0
{
  mov al,0
  stosb
}
stos0       ;this is place for instruction, will be replaced
here: stos0 ;this is place for instruciton too
db stos0    ;this in not place for instruction and so it won't be replaced
```

… becomes:

``` fasm
mov al,0
stosb
here:
mov al,0
stosb
db stos0
```

You can also “overload” instructions with macros. Since the preprocessor isn’t aware of instructions, it allows macro names to be instruction mnemonics:

``` fasm
macro pusha
{
  push eax ebx ecx edx ebp esi edi
}
macro popa
{
  pop edi esi ebp edx ecx ebx eax
}
```

… these 2 save 4 bytes for every `pusha` because they don’t push `ESP`. But overloading istructions isn’t a very good idea, because someone reading your code may be fooled if he doesn’t know that the instruction is overloaded.

You can also overload assembly-time directives:

``` fasm
macro use32
{
  align 4
  use32
}
macro use16
{
  align 2
  use16
}
```

5. Macros with Fixed Number of Arguments
========================================

5.1. Macros with Single Argument
--------------------------------

You can also define a macro’s argument. This argument is represented by a symbol, which will be replaced in the macro’s body by the passed argument.

``` fasm
macro <name> <argument> { <body> }
```

Example:

``` fasm
macro add5 where
{
  add where,5
}
add5 ax
add5 [variable]
add5 ds
add5 ds+2
```

… becomes:

``` fasm
add ax,5
add [variable],5
add ds,5   ;There is no such instruction, but it's not the task of the
           ;preprocessor to check it. It will be preprocessed in this form,
           ;and will throw an error during the assembling stage.
add ds+2,5 ;Same as previous, but this is also syntactically wrong,
           ;so it will throw an error during the parsing stage.
```

(of course there won’t be those comments in the preprocessed file :)

5.2. Macros with Miltiple Arguments
-----------------------------------

Macros can have multiple arguments, separated with commas (`,`):

``` fasm
macro movv where,what
{
  push what
  pop  where
}
movv ax,bx
movv ds,es
movv [var1],[var2]
```

… gets preprocessed to:

``` fasm
push bx
pop ax
push es
pop ds
push [var2]
pop [var1]
```

If multiple arguments have the same name, the first one is used :).

If you pass less arguments than listed in macro declaration, the value of unspecified arguments will be blank:

``` fasm
macro pupush a1,a2,a3,a4
{
  push a1 a2 a3 a4
  pop a4 a3 a2 a1
}
pupush eax,dword [3]
```

… becomes:

``` fasm
push eax dword [3]
pop dword [3] eax
```

If you want to include a comma (`,`) in a macro’s argument, you must enclose the argument in angle brackets `<`,`>`:

``` fasm
macro safe_declare name,what
{
  if used name
    name what
  end if
}
safe_declare var1, db 5
safe_declare array5, <dd 1,2,3,4,5>
safe_declare string, <db "hi, i'm stupid string",0>
```

… becomes:

``` fasm
if used var1
  var1 db 5
end if
if used array5
  array5 dd 1,2,3,4,5
end if
if used string
  string db "hi, i'm stupid string",0
end if
```

Of course, you can use `<` and `>` in the macro’s body too:

``` fasm
macro a arg {db arg}
macro b arg1,arg2 {a <arg1,arg2,3>}
b <1,1>,2
```

… is preprocessed to:

``` fasm
db 1,1,2,3
```

5.3. Directive “`local`”
------------------------

You may want to declare a label inside the macro’s body:

``` fasm
macro pushstr string
{
  call behind ;pushes address of string and jumps to behind
  db string,0
  behind:
}
```

but if you use this macro twice, label “`behind`” will be defined twice and that will raise an error. You can solve this by making the “`behind`” label local to the macro. This can be done using the “`local`” preprocessor directive:

``` fasm
local <name>
```

It must be inside the macro’s body. It makes all following occurences of `<name>` inside the macro’s body local to macro. Therefore, if the macro is used twice:

``` fasm
macro pushstr string
{
  local behind
  call behind
  db string,0
  behind:
}
pushstr 'aaaaa'
pushstr 'bbbbbbbb'
call something
```

this won’t cause any problems. This is done by replacing `behind` with `behind?XXXXXXXX` where `XXXXXXXX` is some hexadecimal number generated by the preprocessor. The previous code could, for example, be preprocessed to:

``` fasm
call behind?00000001
db 'aaaaa',0
behind?00000001:
call behind?00000002
db 'bbbbbbbb',0
behind?00000002:
call something
```

Note that you can’t directly access names containing `?`, as it is a special symbol for fasm, and for this reason it is used with local names. For example `aa?bb` is considered as symbol `aa`, special symbol `?` and symbol `bb`.

If you want more local labels you don’t have to use `local` twice: you can list them all in a single `local` directive, separated by commas (`,`):

``` fasm
macro pushstr string  ;does same job as previous macro
{
  local addr,behind
  push addr
  jmp behind
  addr db string,0
  behind:
}
```

It is always good practice to start all macro local label names with two dots (`..`), which means they won’t change the current global label. For example:

``` fasm
macro pushstr string
{
  local behind
  call behind
  db string,0
  behind:
}
MyProc:
  pushstr 'aaaa'
  .a:
```

… will be preprocessed to:

``` fasm
MyProc:
call behind?00000001
db 'aaaa',0
behind?00000001:
.a:
```

… which will create a `behind?00000001.a` label instead of `MyProc.a`. But names that start with two dots (`..`) don’t change the current global label, so in the following case `MyProc.a` would be declared:

``` fasm
macro pushstr string
{
  local ..behind
  call ..behind
  db string,0
  ..behind:
}
MyProc:
  pushstr 'aaaa'
  .a:
```

5.4. Operator `#` (symbol concatenation)
----------------------------------------

Another feature of fasm’s macrolanguage is symbols manipulation. This is achieved with the symbol-concatenation operator `#`, which concatenates two symbols into one: for example, `a#b` will become `ab`, and `aaa bbb#ccc ddd` -&gt; `aaa bbbccc ddd`. This operator can be used only inside a macro’s body, and symbols concatenatiion will occur after the replacement of a macro’s arguments, so you can use this feature to create a symbol from a macro’s argument.

Example:

``` fasm
macro string name, data
{
  local ..start
  ..start:
  name db data,0
  sizeof.#name =  $ - ..start
}
string s1,'macros are stupid'
string s2,<'here I am',13,10,'rock you like a hurricane'>
```

… becomes:

``` fasm
..start?00000001:
s1 db 'macros are stupid',0
sizeof.s1 = $ - ..start?00000001
..start?00000002:
s2 db 'here I am',13,10,'rock you like a hurricane',0
sizeof.s2 = $ - ..start?00000002
```

… where for each string defined via the macro, a symbol `sizeof.<name of string>` gets defined.

This operator can also concatenate quoted strings:

``` fasm
macro debug name
{
  db 'name: '#name,0
}
debug '1'
debug 'barfoo'
```

… becomes:

``` fasm
db 'name: 1',0
db 'name: barfoo',0
```

this is usefull when passing argument from macro to macro:

``` fasm
macro pushstring string
{
  local ..behind
  call ..behind
  db string,0
  ..behind:
}
macro debug string
{
  push MB_OK
  push 0 ;empty caption
  pushstring 'debug: '#string  ;"pushstring" takes one argument
  push 0 ;no partent window
  call [MessageBox]
}
```

Note that you can’t use `#` in arguments of `local`, because `local` is processed before `#`. Therefore, code like this won’t work:

``` fasm
macro a arg
{
  local name_#arg
}
a foo
```

5.5. Operator “`` ` ``”
-----------------------

There is also the `` ` `` operator, which transfers the symbol following it to a quoted string. This operator can be used only inside macros.

Example:

``` fasm
macro proc name
{
  name:
  log `name   ;log can be a macro which takes a string as argument
}
proc DummyProc
```

… becomes:

``` fasm
DummyProc:
log 'DummyProc'
```

A slightly more complicated example of `#` usage:

``` fasm
macro proc name
{
  name:
  log 'entering procedure: '#`name
}
proc DummyProc
retn
proc Proc2
retn
```

… becomes:

``` fasm
DummyProc:
log 'entering procedure: DummyProc'
retn
Proc2:
log 'entering procedure: Proc2'
retn
```

6. Macros with Group Argument
=============================

6.1. Declaring Macros with Group Argument
-----------------------------------------

Macros can have the so-called “group argument”, allowing for a non-fixed number of arguments. The group argument must be enclosed in square brackets `[`,`]` in the macro definition:

``` fasm
macro name arg1,arg2,[grouparg]
{
  <body>
}
```

The group argument must be the last argument in the macro defintion. Group argument can contain multiple arguments, like:

``` fasm
macro name arg1,arg2,[grouparg] {}
name 1,2,3,4,5,6
```

… here the values of group argument (`grouparg`) are values 3, 4, 5 and 6. 1 and 2 are the values of `arg1` and `arg2`.

6.2. Directive “`common`”
-------------------------

To work with group arguments, you use some preprocessor directives. These directives can be used only inside the body of a macro with group argument. The first of these directives is `common`. It means that from this directive onward the group argument’s name in a macro’s body will be replaced by all the arguments:

``` fasm
macro string [grp]
{
  common
    db grp,0
}
string 'aaaaaa'
string 'line1',13,10,'line2'
string 1,2,3,4,5
```

… becomes:

``` fasm
db 'aaaaaa',0
db 'line1',13,10,'line2',0
db 1,2,3,4,5,0
```

6.3. Directive “`forward`”
--------------------------

But you can also work with the arguments in group argument by treating them separately. For this purpose, the `forward` preprocessor directive is used. The part of the macro’s body following the `forward` directive is preprocessed for each argument of the group argument:

``` fasm
macro a arg1,[grparg]
{
forward
  db arg1
  db grparg
}
a 1,'a','b','c'
a -1,10,20
```

… becomes:

``` fasm
db 1
db 'a'
db 1
db 'b'
db 1
db 'c'
db -1
db 10
db -1
db 20
```

`forward` is the default behavior for macros with group arguments, so the previous macro could be just as well written:

``` fasm
macro a arg1,[grparg]
{
  db arg1
  db grparg
}
```

6.4. Directive “`reverse`”
--------------------------

`reverse` is the same as `forward`, except that it processess the arguments in group argument from last to first (reverse order):

``` fasm
macro a arg1,[grparg]
{
reverse
  db arg1
  db grparg
  }
a 1,'a','b','c'
```

… becomes:

``` fasm
db 1
db 'c'
db 1
db 'b'
db 1
db 'a'
```

6.5. Combining Group Control Directives
---------------------------------------

These three directives divide a macro into blocks. Each block is processed after the previous one. For example:

``` fasm
macro a [grparg]
{
  forward
    f_#grparg:         ;symbol-concatenation operator #, see chapter 4.4
  common
    db grparg
  reverse
    r_#grparg:
}
a 1,2,3,4
```

… becomes:

``` fasm
f_1:
f_2:
f_3:
f_4:
db 1,2,3,4
r_4:
r_3:
r_2:
r_1:
```

6.6. Behavior of `local` inside a Macro with Group Argument
-----------------------------------------------------------

There is yet another very nice feature with labels that are local in a macro (ie: listed with the `local` preprocessor directive; see [**Chapter 5.3**](#directive-local)). If the `local` directive is defined inside a `forward` or `reverse` block, then a unique label is defined for each argument in the group, and the same labels are then used with their correspective arguments in the following `forward` or `reverse` blocks. Example:

``` fasm
macro string_table [string]
{
  forward         ;table of pointers to strings
    local addr    ;declare label for this string as local
    dd addr       ;pointer to string
  forward         ;strings
    addr db string,0
}
string_table 'aaaaa','bbbbbb','5'
```

… becomes:

``` fasm
dd addr?00000001
dd addr?00000002
dd addr?00000003
addr?00000001 db 'aaaaa',0
addr?00000002 db 'bbbbbb',0
addr?00000003 db '5',0
```

Another example, this time with a `reverse` block:

``` fasm
macro a [x]
{
forward
  local here
  here db x
reverse
  dd here
}
a 1,2,3
```

… becomes:

``` fasm
here?00000001 db 1
here?00000002 db 2
here?00000003 db 3
dd here?00000003
dd here?00000002
dd here?00000001
```

… the same unique label is used with each argument in both the `forward` and `reverse` blocks.

6.7. Macros with Multiple Group Arguments
-----------------------------------------

You can also have multiple group arguments. In that case a macro definition won’t look like:

``` fasm
macro a [grp1],[grp2]
```

… because then it would be unclear which arguments belong to which group. For this reason you declare them like this:

``` fasm
macro a [grp1,grp2]
```

… here every odd argument belongs to `grp1`, and every even argument to `grp2`.

Example:

``` fasm
macro a [grp1,grp2]
{
  forward
    l_#grp1:
  forward
    l_#grp2:
}
a 1,2,3,4,5,6
```

… becomes:

``` fasm
l_1:
l_3:
l_5:
l_2:
l_4:
l_6:
```

Another example:

``` fasm
macro ErrorList [name,value]
{
  forward
    ERROR_#name = value
}
ErrorList \
 NONE,0,\
 OUTOFMEMORY,10,\
 INTERNAL,20
```

… becomes:

``` fasm
ERROR_NONE = 0
ERROR_OUTOFMEMORY = 10
ERROR_INTERNAL = 20
```

Of course, there can be more than just two group arguments:

``` fasm
macro a [g1,g2,g3]
{
  common
    db g1
    db g2
    db g3
}
a 1,2,3,4,5,6,7,8,9,10,11
```

… becomes:

``` fasm
db 1,4,7,10
db 2,5,8,11
db 3,6,9
```

7. Preprocessor Conditionals
============================

In fact, there is no preprocessor conditional syntax in FASM (too bad). But the assembly directive `if` can be used in conjuction with the preprocessor to achieve the same results as with preprocessor conditionals (but this way it wastes more time and memory).

As you know, `if` is an assembly-time statement. It means that the statement is checked after preprocessing, and this allows some special conditional operators to work.

I won’t describe its assembly-time behavior (conditional operators like `&`, `|`, etc), read FASM’s docs for this. Here I will describe only those operators that are used with the preprocessor.

7.1. Operator `eq`
------------------

The simplest on is `eq`. It just compares two symbols and checks if they are the same. Value of `abcd eq abcd` is true, value of `abcd eq 1` is false, etc. It is useful for comparing a symbol that will be preprocessed, like:

``` fasm
STRINGS equ ASCII
if STRINGS eq ASCII
  db 'Oh yeah',0
else if STRINGS eq UNICODE
  du 'Oh yeah',0
else
  display 'unknown string type'
end if
```

… after preprocessing it will become:

``` fasm
if ASCII eq ASCII
  db 'Oh yeah',0
else if ASCII eq UNICODE
  du 'Oh yeah',0
else
  display 'unknown string type'
end if
```

… where the first condition (`ASCII eq ASCII`) is true, so only `db 'Oh yeah',0` will be assembled.

Another example:

``` fasm
STRINGS equ UNICODE   ;only difference here, UNICODE instead of ASCII
if STRINGS eq ASCII
  db 'Oh yeah',0
else if STRINGS eq UNICODE
  du 'Oh yeah',0
else
  display 'unknown string type'
end if
```

… after preprocessing it will be:

``` fasm
if UNICODE eq ASCII
  db 'Oh yeah',0
else if UNICODE eq UNICODE
  du 'Oh yeah',0
else
  display 'unknown string type'
end if
```

… now the first condition (`UNICODE eq ASCII`) will be false, and the second one (`UNICODE eq UNICODE`) will be true, therefore `du 'Oh yeah',0` will be assembled.

A better usage of this operator is for checking macro arguments, like:

``` fasm
macro item type,value
{
  if type eq BYTE
    db value
  else if type eq WORD
    dw value
  else if type eq DWORD
    dd value
  else if type eq STRING
    db value,0
  end if
}
item BYTE,1
item STRING,'aaaaaa'
```

… which becomes:

``` fasm
if BYTE eq BYTE
  db 1
else if BYTE eq WORD
  dw 1
else if BYTE eq DWORD
  dd 1
else if BYTE eq STRING
  db 1,0
end if
if STRING eq BYTE
  db 'aaaaaa'
else if STRING eq WORD
  dw 'aaaaaa'
else if STRING eq DWORD
  dd 'aaaaaa'
else if STRING eq STRING
  db 'aaaaaa',0
end if
```

… so only these two commands will get assembled:

``` fasm
db 1
db 'aaaaaa',0
```

`eq` (like all other preprocessor operators) can also work with empty arguments. This means, for example, that `if eq` is true, and `if 5 eq` is false etc. Example macro:

``` fasm
macro mov dest,src,src2
{
  if src2 eq
    mov dest,src
  else
    mov dest,src
    mov src,src2
  end if
}
```

7.2. Operator `eqtype`
----------------------

Another operator is `eqtype`. It compares whether symbols are of the same type. Types are:

-   individual quoted strings (those not being a part of numerical expression)
-   floating point numbers
-   any numerical expression (note that any unknown word will be treated as a label, so it will also will be seen as an expression),
-   addresses - the numerical expressions in square brackets (with size operators and segment prefixes)
-   instruction mnemonics
-   registers
-   size operators
-   near/far operators,
-   use16/use32 operators
-   blank space

Example of a macro which allows an `SHL` instruction with a memory variable as count, like `shl ax,[myvar]`:

``` fasm
macro shl dest,count
{
  if count eqtype [0]   ;if count is a memory variable
    push cx
    mov cl,count
    shl dest,cl
    pop cx
  else                  ;if count is of another type
    shl dest,count      ;just use original shl
  end if
}
shl ax,5
byte_variable db 5
shl ax,[byte_variable]
```

… becomes:

``` fasm
if 5 eqtype [0]
  push cx
  mov cl,5
  shl ax,cl
  pop cx
else
  shl ax,5
end if
byte_variable db 5
if [byte_variable] eqtype [0]
  push cx
  mov cl,[byte_variable]
  shl ax,cl
  pop cx
else
  shl ax,[byte_variable]
end if
```

… and so, because of the conditionals, it will be assembled to:

``` fasm
shl ax,5
byte_variable db 5
push cx
mov cl,[byte variable]
shl ax,cl
pop cx
```

Note that `shl ax,byte [variable]` wouldn’t work with this macro, because condition `byte [variable] eqtype [0]` isn’t true (read further).

<!-- NEXT PARAGRAPH NEED REVISING: BADLY BROKEN!!!! -->
The `eqtype` operator isn’t limited to just two operands. It just compares whether types of operands on its left-hand side and same to type of operands on right side of `eqtype`. For example, `if eax 4 eqtype ebx name` is true (`name` is a label, and thus it is a number too).

Example of extending the `mov` intruction so it allows moving between memory variables:

``` fasm
macro mov dest,src
{
  if dest src eqtype [0] [0]
    push src
    pop dest
  else
    mov dest,src
  end if
}
mov [var1],5
mov [var1],[var2]
```

… will be preprocessed to:

``` fasm
if [var1] 5 eqtype [0] [0]  ;false
  push 5
  pop [var1]
else
  mov [var1],5
end if
if [var1] [var2] eqtype [0] [0]  ;true
  push [var2]
  pop [var1]
else
  mov [var1],[var2]
end if
```

… and assembled to:

``` fasm
mov [var1],5
push [var2]
pop [var1]
```

Anyway, a better (and more readable) way to write a similar macro is to use the `&` operator (not covered in this document, see FASM documentation), like:

``` fasm
macro mov dest,src
{
  if (dest eqtype [0]) & (src eqtype [0])
    push src
    pop dest
  else
    mov dest,src
  end if
}
```

The previous example using `eqtype` with four arguments was meant only to demonstrate its possibilities, but `&` should be used if possible.

Note that currently you can use incomplete expressions as argument of `eqtype`, it is sufficent that the parser recognizes its type, but this is undocumented behavior so I won’t describe it any further.

7.3. Operator “`in`”
--------------------

FASM also includes another operator which can be employed if you use multiple `eq`s:

``` fasm
macro mov a,b
{
  if (a eq cs) | (a eq ds) | (a eq es) | (a eq fs) |\
     (a eq gs) | (a eq ss)
    push b
    pop a
  else
    mov a,b
  end if
}
```

Instead of many `|`ed `eq`s, you can use the `in` operator. It compares the symbol on its left-hand side with multiple symbols in a list on its right-hand side. The symbols list must be enclosed in angle brackets (`<` and `>`), and the symbols inside the list should be separated by commas (`,`).

``` fasm
macro mov a,b
{
  if a in <cs,ds,es,fs,gs,ss>
    push b
    pop a
  else
    mov a,b
  end if
}
```

`in` also works with multiple symbols on both sides (like `eq`):

``` fasm
if dword [eax] in <[eax], dword [eax], ptr eax, dword ptr eax>
```

8. Structures
=============

Structures are almost the same as macros. You declare them with the `struc` directive:

``` fasm
struc <name> <arguments> { <body> }
```

The difference is that when you use a structure in code, it must be preceded by a label (structure name). For example:

``` fasm
struc a {db 5}
a
```

… doesn’t work. A structure is only recognized when preceded by `name`, like:

``` fasm
struc a {db 5}
name a
```

… which, like a macro, will get preprocessed to:

``` fasm
db 5
```

The reason for the preceding `name` (ie: the one before the structure) is that `name` will be appended before every symbol inside the structure’s body that starts with a `.`. For example:

``` fasm
struc a {.local:}
name1 a
name2 a
```

… will become:

``` fasm
name1.local:
name2.local:
```

This way you can define something similar to structures found in other languages. Example:

``` fasm
struc rect left,right,top,bottom  ;has arguments, like macros
{
  .left dd left
  .right dd right
  .top dd top
  .bottom dd bottom
}
r1 rect 0,20,10,30
r2 rect ?,?,?,?
```

… becomes:

``` fasm
r1.left dd 0
r1.right dd 20
r1.top dd 10
r1.bottom dd 30
r2.left dd ?
r2.right dd ?
r2.top dd ?
r2.bottom dd ?
```

You can also use a cool trick with which you don’t have to specify arguments (and `0` will be used instead):

``` fasm
struc ymmud arg
{
  .member dd arg+0
}
y1 ymmud 0xACDC
y2 ymmud
```

… becomes:

``` fasm
y1.member dd 0xACDC+0
y2.member dd +0
```

As mentioned in 4.2, if an argument remain unspecified its value is blank inside macro/structure body. We also exploited the fact that `+` is both a binary (with two operands) and unary (with one operand) operator.

<div class="alert">
**NOTE**: You'll often encounter a defined macro or structure called `struct` (not `struc`), which declares a structure or extends structure declaration. Don’t mistake that `struct` with `struc`.
</div>
9. Fixes
========

By the time FASM was evolving, it still missed one very useful feature: the ability to declare a macro inside a macro — ie: the result of unrolling the macro becomes a macro definition. Hypothetically, something like this:

``` fasm
macro declare_macro_AAA
{
  macro AAA
  {
     db 'AAA',0
  } ;end of "AAA" declaration
} ;end of "declare_macro_AAA" declaration
```

The problem here is that when macro `declare_macro_AAA` is read by the preprocessor, the first `}` encountered is interpreted as its end, which isn’t what we intended. It is similar to what happens with other preprocessor symbols/operators (eg: `#`, `` ` ``, `forward`, `local`, etc.), they get processed during expansion of the outer macro, so they can’t be used in inner macro declaration.

9.1. Explaination of Fixes
--------------------------

In the meantime, another preprocessor directive was added. It does the same job as `equ`, but BEFORE other preprocessing (except for things listed in [**Chapter 2**](#basic-preprocessing), which are done in a pre-preprocessing stage, but this is internal stuff, not particularly interesting). This directive is `fix`.

It has the same syntax as `equ` (`<symbol> fix <anything>`), but replacing fixed symbols in line is done before any other preprocessing (except things listed in [**Chapter 2**](#basic-preprocessing), again). Preprocessing is done line by line, left to right, so if we have the following code:

``` fasm
a equ 1
b equ a
a b
```

… its preprocessing will happens like this:

-   *Preprocessing line 1:*
    -   `a` — Preprocessor finds unknown word, skips it.
    -   `equ` — “`equ`” is second word of line, so it memorizes that “`a`” equals rest of line (“`1`”), then deletes line.
-   *Preprocessing line 2:*
    -   `b` — Preprocessor finds unknown word, skips it.
    -   `equ` — “`equ`” is second word of line, so it memorizes that “`b`” equals rest of line (“`a`”), then deletes line.
-   *Preprocessing line 3:*
    -   `a` — Preprocessor replaces “`a`” with “`1`”
    -   `b` — Preprocessor replaces “`b`” with “`a`”

So it becomes:

``` fasm
1 a
```

But if we have:

``` fasm
a fix 1
b fix a
a b
```

… then it looks like:

-   *Fixing line 1:* No symbols to be fixed
-   *Preprocessing line 1:*
    -   `a` — Preprocessor finds unknown word, skips it.
    -   `fix` — “`fix`” is second word of line, so it memorizes that “`a`” is fixed to rest of line (“`1`”), then deletes line.
-   *Fixing line 2:* “`a`” is fixed to “`1`”, so line becomes “`b fix 1`”
-   *Preprocessing line 2:*
    -   `b` — Preprocessor finds unknown word, skips it.
    -   `fix` — “`fix`” is second word of line, so it memorizes that “`b`” is fixed to rest of line (“`1`”) and deletes line
-   *Fixing line 3:* “`a`” is fixed to “`1`”, “`b`” is fixed to “`1`” so line becomes “`1 1`”
-   *Preprocessing line 3:*
    -   `1` — Preprocessor finds unknown word, skips it.
    -   `1` — Preprocessor finds unknown word, skips it.

This was only an example to show how fixing works, it isn’t usually used in this manner.

9.2. Using Fixes for Nested Macro Declaration
---------------------------------------------

Now let’s get back to declaring a macro inside a macro. First of all, we need to know how macros are preprocessed. You can quite easily work it out yourself: at macro declaration the macro’s body is saved, and when a macro is expanded the preprocessor replaces the line containing the macro with that macro’s body, it internally declares equates to handle its arguments and then continues preprocessing the macro body. (of course it’s more complicated than this, but this is enough for understanding fixes).

So what was the problem with declaring a macro inside a macro? The first time the compiler encountered a “`}`” inside the macro’s body it interpreted it as the end of the macro’s body declaration, so there wasn’t any way to include “`}`” in a macro’s body. But we can easily fix **:)** this:

``` fasm
macro a
{
  macro b
  %_
     display 'Never fix before something really needs to be fixed'
  _%
}
%_ fix {
_% fix }
a
b
```

Now preprocessing looks like this (simplified):

1.  Preprocessor loads declaration of macro “`a`”
2.  Preprocessor loads declaration of fixes “`%_`” and “`_%`”
3.  Preprocessor expands macro “`a`”
4.  Preprocessor loads macro “`b`” declaration (“`_%`” and “`%_`” are fixed in each line before being handled by rest of preprocessor)
5.  Preprocessor expands macro “`b`”

Here you can see how important is the positioning of fixes’ declaration, because the macro’s body is fixed too before being loaded by the preprocessor. For example, this won’t work:

``` fasm
%_ fix {
_% fix }
macro a
{
  macro b
  %_
     display 'Never fix before something really needs to be fixed, here you see it'
  _%
}
a
b
```

Because “`%_`” and “`_%`” will be fixed before loading macro “`a`”, so loading of the macro’s body will end at “`_%`” (by then, fixed to “`}`”) and the second “`}`” will remain there.

<div class="alert">
**NOTE**: Character “`%`” isn’t a special character for FASM’s preprocessor, so you use it just like any other normal character (eg: “`a`” or “`9`”). It has special meaning AFTER preprocessing, and only when it is the only char of a whole word (eg: “`%`” but not “`anything%anything`”).
</div>
We also need to fix other macro-releated operators:

``` fasm
%_ fix {
_% fix }
%local fix local
%forward fix forward
%reverse fix revese
%common fix common
%tostring fix `
```

<!-- NOTE: UNCLEAR... doesn't explain why # is special, and why we'd want to fix it. Lacks context, and lacks clear connection with preceding text  -->
Only `#` is a special case, you can fix it, but there is an easier way. Every time the preprocessor finds multiple `#`s, it removes one, so it is something like (this won’t actually work):

``` fasm
etc...
###### fix #####
#####  fix ####
####   fix ###
###    fix ##
##     fix #
```

So instead of using symbol fixed to “`#`” you can just use “`##`” etc.

9.3. Using Fixes for Moving Parts of Codes
------------------------------------------

You can also use fixes to move parts of code. In assembly programming this is useful, especially when you break code into modules but want to have data and code grouped in separate segment/section, but defined in a single file.

Right now this part of tutorial is **TODO**, I hope I will write it soon, for now you can look at JohnFound’s Fresh’s macro library, file `INCLUDE\MACRO\globals.inc`.

I know fixes are confusing, and to understand them you have to learn the inner workings of the preprocessor, but they give you great coding power. Privalov wanted FASM to be as powerful as possible, even at the cost of comprehensibility.

Closing Remarks
===============

Don’t forget to read FASM documentation. Almost everything from this tutorial is there, maybe written in a way that’s a little harder for learning but definitely a better reference. It is not so long, nor hard to remember — 99% of FASM users have learnt it from these docs and from the forum.
