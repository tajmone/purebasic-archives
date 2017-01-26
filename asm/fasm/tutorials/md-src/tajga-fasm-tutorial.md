Introduction
============

For whom?
---------

It is meant for beginners, so almost no programing knowledge is required. Altough learning assembly as first programing language is quite hard, it is possible. You only need to know how to use the command line (`command.com` in DOS/Win95/98, `cmd` in WinNT/XP). Some programming knowledge is very helpful, but not nescessary.

What OS?
--------

I decided to write tutorial for DOS, because it allows you to use whole your machine however you wish, unlike Windoze. I just want this tutorial to cover more assembly topics than Windows allows, so DOS is my only choice. Porting from DOS to Windows isn’t very difficult, if you already know protected mode. [IczLion’s tutorial](http://win32assembly.programminghorizon.com/tutorials.html) covers this, and is also translated to FASM. I personally don’t like starting learning assembly under Windows, because there are too many things abstracted from you.

Development status of tutorial
------------------------------

This tutorial is very far from being complete, but it already contains enough informations to be worth reading for beginners and intermediates.

Currently, [**Chapter 7**](#arithmetic-instructions-more-on-flags) is done and is being revised.

Additional articles
-------------------

There are also some other articles connected with assembly and FASM included in this tutorial package.

Articles:

-   [FASM preprocessor guide](./fasm-preprocessor-guide.html) (complete)

Legal stuff
-----------

This tutorial is without any warranty (you are using it at your own risk **:)** ). That also means you can use it however you like, and/or do whatever you like with it. If you would like to include tutorial or some part of it in a project you are working on, or you want to translate it to some other language, or something like that, then it would be nice if you wrote me an [e-mail](mailto:vid@InMail.sk) and mention me somewhere in your work.

Translating this tutorial
-------------------------

There were several requests for permission to translate this tutorial. Of course, I’ve granted it; but I realized that it is hard to maintain such a translation: if I edit the already-writen text, the maintainer doesn’t always know about it. So I decided to create change log, inside which all changes will be logged. The log will be provided on request.

I will provide links to translated versions as soon as they are ready.

Please help me to improve this tutorial by sending all sugestions and error reports to [tutorial’s thread on FASM board](https://board.flatassembler.net/topic.php?t=1178) or with [email](mailto:vid@InMail.sk) if you like.

Also, if you find that something in this tutorial isn’t explained comprehensibly enough , please tell what is it, where in tutorial is it mentioned, and what you don’t understand about it, so I can add it for future readers.

This tutorial was translated to HTML (from original plain-text version) by [**Decard**](https://web.archive.org/web/20070128085747/http://decard.net/?). He also created a utility to convert FASM source to HTML text with syntax highlighting used for code blocks in this tutorial. There is also [online version of this tutorial](https://web.archive.org/web/20060925090450/http://www.decard.net/article.php?body=tajga) hosted at his site.

1. Getting Started
==================

I assume you have some basic knowledge about what bytes are, and an idea on what ASCII code is. Maybe I’ll describe ASCII in a next versions of tutorial.

First, try to compile and empty source file. Just create an empty “`empty.asm`” file and type in the command line:

``` dos
fasm empty.asm empty.bin
```

You should see that a “`empty.bin`” file is created, and it’s length is zero.

Now we will create binary file containing some data. Create a text file containing the follwoing line:

``` fasm
db 'a'
```

and compile it (I hope you already know how). When you look at the created file you should see that it’s 1 byte long and it contains character “`a`”.

Now let’s analyze the source: `db` is a “**directive**” (a directive is command to the compiler, remember this!) which means “**define byte**”. So this directive will put a byte into the destination file. Value of byte should follow this directive. For example, `db 0` will insert a byte with value 0 into the destination file. But if you wanted to insert a character, you would have to remember its ASCII value. In this case, you can enter the character enclosed in straight single quotes (`'`) and the compiler will “get” its value for you. This is how the above code works.

<div class="alert alert-info">
**directive**

A command to the compiler.

</div>
Now let’s create a file with more than one character. It will be:

``` fasm
db '1'
db '2'
db '3'
```

I think it should be clear how this works: it stores three bytes into the destination file, which should now contain a simple line with `123`. By the way you can’t write:

``` fasm
db '1' db '2' db '3'
```

because <mark>every directive must be on separate line</mark>. But if you want to define more bytes, you can use a simple `db` directive followed by multiple values, sperated by commas (`,`):

``` fasm
db '1','2','3'
```

This will also produce a file with `123`.

But what if you wanted to define something longer, for example a file containing `This is my first long string in FASM`? You could write:

``` fasm
db 'T','h','i','s'  etc...
```

but this isn’t very nice. For this reason, if you want define more consecutive characters using `db` , you can use this form:

``` fasm
db 'This is my first long string in FASM'
```

So you have to enclose whole text in quotes. You could also write:

``` fasm
db 'This is my first long string in ','FASM'
```

or

``` fasm
db 'Thi','s is my first lo','ng string in',' FASM'
```

etc.

<div class="alert alert-info">
**string**, **quoted string**

Text enclosed in quotes is called a “**string**”. In general, a “string” is an array of characters. The term for denoting a string inside source code is  “**quoted string**”.

</div>
2. First Program
================

You may wonder why I’m fooling about creating text files when you want to learn assembly. But text files are just some “**arrays**” of bytes. You haven’t learnt just how to create a text file: you learnt how to define a file containing any data you want! And this is what a runnable program is — a special “**data**” file, an array of numeric values, called “**machine code**”. You only have to know the meaning of these values **:)**. Of course, it’s very hard to remember all the values and their’s meanings, and this is what an assembler is for: It translates programs from a human acceptable language to machine code. Therefore, you only have to learn this human acceptable language **:)**.

<div class="alert alert-info">
**machine code**

An array of numeric values that represents instructions to the processor (CPU).

</div>
Now we’ll look into DOS `.COM` (**COM files**) programs (occasionaly called “**memory image**” — you will learn why later on, when you get into it). These are the simplest executable (runnable) files under DOS and Windows.

So let’s create our first `.COM` file, which won’t do anything.

``` fasm
org 256
int 20h
```

Compile this to a `.COM` file and run it. Nothing should happen. Now let’s look at what those two lines of code mean. (This is going to be funny…)

``` fasm
org 256
```

Right now, I won’t explain what this directive does. Just put this line in the begginning of every `.COM` file! It doesn’t define any data, it doesn’t even do anything that you can notice. We’ll get back to this later on.

``` fasm
int 20h
```

This is an “**instruction**”. An instruction is a command for the processor, which is stored in the created file as one or more bytes. When you run a `.COM` executable file, the processor walks through it and decodes its instructions from machine code and does what these instructions instruct it to. Instruction `int 20h` says that this is the end of execution of the file. So, the first instruction in this code tells the processor to stop execution, therefore the executable file does nothing, as you saw.

<div class="alert alert-info">
**instruction**

A single command to the processor.

</div>
<div class="alert">
__BY THE WAY__: `int 20h` is NOT the processor instruction which ends the execution of the `.COM` program. It instructs the processor to call a system procedure. The system procedure to be called is chosen by the number following `int` — in our case: number `20h` (it IS a sort of number), which means calling the procedure to end a `.COM` file.

`int` could be followed by a different number, and a different system procedure would be called. But right now, we can abstract away from this, forget about it and take `int 20h` as the instruction to stop a program.

</div>
So, “**machine code**” is a set of “**instructions**”. <mark>There is a difference between directives and instructions.</mark> Directives are commands for the compiler — how it should define data, and what data it should define. Instructions are defined data which encodes what the processor will do when you execute the program. For example, `db 0,0` is a directive which defines two zero bytes, but it is an instruction in case it is executed, because two zero bytes have special meaning for the processor (don’t bother about their meaning right now). `org 256` is a directive, not an instruction, because it doesn’t define any data. You will get into this by practice.

Instruction `int 20h` is simple, it doesn’t need any arguments (=parameters, or values which changes its effect). But what if some instruction DOES need arguments? For this reason the processor has it’s own “**variables**” (variable is a general term for a space which stores some value). These variables are called “**registers**”. The first registers we’ll learn are `al`, `ah`, `bl`, `bh`, `cl`, `ch`, `dl`, and `dh`, which are **byte-sized** (they contain a value within the range 0 to 255).

<div class="alert alert-info">
**register**

An “internal” processor’s variable.

</div>
<div class="alert">
__BY THE WAY__:  `int 20h` takes its argument in the `AL` register, but, again, we can abstract from this. And, in fact, value `20h` is an instruction argument too, but we abstracted from this before. This is what I was talking about when I mentioned that this was “going to be funny”.
</div>
Now, how do we set the value of a register? There is a instruction which does this, for example:

``` fasm
mov al,10
```

this instruction sets the value of the `al` register to 10. `mov` stands for “**move**”. The destination of “moving” follows `mov` (separated with spaces) — in our case, it’s the `al` register. Then comes the source of “moving”, separated by a comma (`,`) — in our case, it’s number 10. So this instruction “moves” value 10 to register `al`. Another example of moving:

``` fasm
mov al,bl
```

This copies the value in the `bl` register to the `al` register. It won’t change the value in the `bl` register. <mark>The source of `mov` always remains unchanged.</mark>

<div class="alert">
**NOTE:** You will often find people talking about the `mov` instruction. But `mov` is not instruction, and `int` is not an instruction either. `mov al,bl` and `int 20h` are instructions, for example. `mov` and `int` are called “**instruction mnemonics**”. But just accept it: everyone calls it “**instruction**”; and probably you will too, after some time  --- and I probably will too, sorry __:)__.

Arguments of an instruction (the part of the instruction without instruction mnemonics, like `al` and `10` in `mov al,10`) are called “**instruction operands**” (or “**instruction arguments**”)
</div>
<div class="alert alert-info">
**instruction mnemonics** (this term is not so improtant right now)

**instruction operand**
</div>
Now let’s get to how registers are used. We will use the `int 21h` instruction which can do MANY things depending on the value in `ah` register. We won’t learn the meaning of every value, right now we will talk only about value 2. If value 2 is in the `ah` register when instruction `int 21h` is executed, then the character in `dl` (more precisely: the character whose ASCII code is in `dl`) is printed to screen (console).

<div class="alert">
**NOTE:** if you are using a Windows file manager (like Total Commander), you'll see a window appear for a very short time and then disappear. Our character is being displayed in this window and you probably can’t notice it. You must run a shell (`cmd` on XP, `command` on older Windozes) and run your program from it. Anyway, if you can’t handle this, forget about assembly for a while and learn using your operating system first — and then, don't forget to return to assembly!
</div>
Okay, so let’s look at a program which prints character “`a`”:

``` fasm
org 256
mov ah,2
mov dl,'a'
int 21h
int 20h
```

Here is its analysis:

``` fasm
mov ah,2
```

sets value of “`ah`” register to 2 — this should be clear.

``` fasm
mov dl,'a'
```

this moves character “`a`” into `dl` register. (In fact, there is nothing like “character a” in assembly. You might have noticed that I wrote that registers can contain numeric values. Nothing about characters. The way this works is that the compiler translates a character enclosed in quotes into its numeric (ASCII) code, which is then recognized by `int 21h` as the code for this character. In assembly, character “`a`” means ASCII code for character “`a`”)

``` fasm
int 21h
```

In this case, when “`ah`” contains value 2, this prints the character in “`dl`”

``` fasm
int 20h
```

And we musn’t forget to stop execution. Otherwise, the program will most probably crash.

<div class="alert">
**NOTE:** In assembly a character enclosed in quotes is the same as the ASCII code of that character.

</div>
So, the code for printing multiple characters (“`ab`”) is:

``` fasm
org 256
mov ah,2
mov dl,'a'
int 21h
mov dl,'b'
int 21h
int 20h
```

we don’t have to set `ah` to 2 again, for the second `int 21h`, because `ah` will retrain the value of 2 previously set. Also `dl` will retain its value, therefore the following code:

``` fasm
org 256
mov ah,2
mov dl,'a'
int 21h
int 21h
int 21h
int 20h
```

will print “`aaa`”.

3. Labels, Addresses and Variables
==================================

Okay, let’s get to variables. In the previous chapter I wrote that variable is general term for a space which stores some value. Registers, for example, are variables. But there is a limited number of registers (VERY limited: around 8 + a few special ones), and their number is rarely sufficient. For this reason memory (RAM — random access memory) is used.

<div class="alert">
**NOTE:** When someone says “variable” he almost always means memory variable.
</div>
3.1. Labels
-----------

The problem is that you have to know WHERE in memory some value is being stored. A position in memory (called “**address**”) is given by number. But it’s quite hard to remember this number (address) for every variable.

<div class="alert alert-info">
term: **address**

A number which gives a position in memory.
</div>
Another problem with addresses is that when you change your program, addresses might changed too, so you would have to correct their number everywhere they are used. For this reason addresses are represented by “**labels**”. A label is just some word (not a string, it is not enclosed in quotes) which, in your program, represents an address in memory. When you compile your program, the compiler will replace the label with the proper address. Labels consists of alphabet characters (“`a`” to “`z`”, “`A`” to “`Z`”), numbers (“`0`” to “`9`”), underscores (“`_`”) and dots (“`.`”). But <mark>the first character of a label can’t be a number or a dot</mark>. Also, a label can’t have the same name as a directive or an instruction (instruction mnemonics). Labels are case sensitive in FASM (“`a`” is NOT same as “`A`”).

Labels Examples:

| LABEL         | STATUS                                                  |
|---------------|---------------------------------------------------------|
| `name`        | a label                                                 |
| `a`           | a label                                                 |
| `A`           | a label, different from “`a`”                           |
| `name2`       | a label                                                 |
| `name.NAME2`  | a label                                                 |
| `name._NAME2` | a label                                                 |
| `_name`       | a label                                                 |
| `_`           | a label                                                 |
| `.name`       | not a label, because is starts with a dot               |
| `1`           | not a label, because it starts with a number            |
| `1st_name`    | not a label, for the same reason                        |
| `name1 name2` | not a label, because it contains a space                |
| `mov`         | not a label, because “`mov`” is an instruction mnemonic |

<div class="alert"> __NOTE__: Labels starting with dot have special meaning in
FASM, which you will learn later. </div>
<div class="alert alert-info"> term:
**label**

A placeholder for some address; ie: a placeholder for some number, because an address is a number.

In FASM you can use a label the same way as any other number (not really, but it doesn’t really matter for you right now).
</div>
You can define labels using the “`label`” directive. This directive should be followed by the label itself (the label name). For example:

| DIRECTIVE     | LABEL STATUS                                                     |
|---------------|------------------------------------------------------------------|
| `label name`  | a label definition, it defines label “`name`”                    |
| `label _name` | a label definition, it defines label “`_name`”                   |
| `label label` | not a label definition, because a label can’t be named “`label`” |

This directive defines a label that will then represent the address of the data defined behind it.

<div class="alert alert-info">
directive: **label**
</div>
<div class="alert alert-info">
**label definition**

The **label** directive followed by a label-name.
</div>
A shorter way to define a label is to write just the label name followed by colon (`:`), like this:

``` fasm
name:
_name:
```

But we won’t be using this shorter way right now, in our examples.

3.2. Defining Variables
-----------------------

Now let’s go back to the problem with variables: how to define a variable in memory. The program you create (a compiled program, in machine code) is loaded to memory at execution time, where the processor executes it, instruction by instruction. Look at this program:

``` fasm
org 256
mov al,10
db 'this is a string'
int 20h
```

This program will probably crash, because after the processor executes `mov al,10` it reaches a string. Inside a program there is no difference between strings and instructions in machine code. Both are translated into an array of numeric values (bytes). There is no way the processor can distinguish whether a numeric value is the translation of a string or the translation of an instruction. In this example, the processor will execute instructions whose numeric representation (in machine code) is the same as the ASCII representation of the string “`this is a string`”. Now look at this:

``` fasm
org 256
mov al,10
int 20h
db 'this is a string'
```

This program will not crash, because before reaching the bytes defined by the string the processor reaches instruction `int 20h`, which ends the program’s execution. Therefore the bytes defined with a string will not be executed, they will just take up some space. This is how you can define a variable — define some data in a place where the processor won’t try to execute it (beyond `int 20h`, in our case).

Here is a code with a byte-sized variable of value 105:

``` fasm
org 256
mov al,10
int 20h
db 105
```

The last line defines a byte variable containing 105.

Now, how can we access a variable? First, we must know the address of the variable. For this purpose we can use a label (described above, re-read it if you have forgotten):

``` fasm
org 256
mov al,10
int 20h
label my_first_variable
db 105
```

So we already know the address of variable: it’s represented by the label `my_first_variable`. Now, how do we access it? You might think that you could do this:

``` fasm
mov al,my_first_variable
```

but you can’t! Remember, I told that a label (`my_first_variable` in our case) stands for the address of the variable. So this instruction will move the address of the variable to the `al` register, not the variable’s contents. To access the contents of a variable (or the contents of any memory location) you must enclose its address in square brackets (`[` and `]`). Therefore, to access the contents of our variable, and copy it’s value to `al`, we use:

``` fasm
mov al,[my_first_variable]
```

Now we will define two variables:

``` fasm
org 256
<some instructions>
int 20h
label variable1
db 100
label variable2
db 200
```

To copy the value of `variable1` to `al` we use:

``` fasm
mov al,[variable1]
```

To copy `al` to `variable1` use

``` fasm
mov [variable1],al
```

To set the value of `variable1` (exactly: to set the value of a variable which is stored at the address represented by `variable1`) to `10` we could try:

``` fasm
mov [variable1],10
```

but this will cause an error (try it yourself if you wish). The problem here is that you know that you are changing the variable at address `variable1` to `10`. But what is the size of the variable? In the previous two cases a byte-size could be determined because you used the `al` register which is byte sized, so the compiler decided that the variable at `variable1` is byte sized too, because you can’t move between operands with different sizes. But in this case, value 10 could be of any size, so it can’t decide the memory size of the variable. To solve this we use “**size operators**”. We will talk about two size operators for now: `byte` and `word`. You can put the size operator before the instruction operand when accessing it, to let the compiler know what the variable size is:

``` fasm
mov byte [variable1],10
```

Another way to do it is:

``` fasm
mov [variable1], byte 10
```

in this case the compiler knows that value `10` being moved is byte sized, so it decides that the variable is byte-sized too (because we can move a byte sized value only to a byte sized variable).

But it would be hard to always remember and always write the size of a variable when you access it. For this reason you can assign the size of the variable to its label when you define it. Just write the size operator after the label’s name in its definition:

``` fasm
label variable1 byte
db 100
```

or

``` fasm
label variable1 word
dw 1000
```

now, every time you use `[variable1]` it will have the same meaning as `byte [variable1]` (or `word [variable1]` in the second example). So `mov [variable1],10` will work — in the first case, it will store value `10` into the byte at address `variable1`; in the second case, it will store it into a word.

<div class="alert alert-info">
**size operator**
</div>
<div class="alert alert-warn">
**NOTE:** <mark>You can’t move values between variables of different size</mark>:

``` fasm
mov byte [variable1], word 10
```

or

``` fasm
mov [variable1],al
...
label variable1 word
dw 0
```
</div>
<div class="alert alert-warn">
**NOTE:** <mark>You can’t access two memory locations in one instruction</mark> (except for some special instructions). This is wrong, and it won’t compile:

``` fasm
mov [variable1],[variable2]
```

use this instead:

``` fasm
mov al,[variable2]
mov [variable1],al
```

This will cause you some problems in the beginning, but it will force you to write faster code --- which is the main reason for coding in assembly.
</div>
<div class="alert alert-warn">
**NOTE:** The size operator assigned to a label in its definition has lower priority than a size operator within an instruction for accessing a variable; therefore:

``` fasm
mov byte [variable],10
label variable word
dw 0
```

will access a BYTE, while

``` fasm
mov [variable],10
```

will access a WORD.
</div>
I think you noticed that having two lines to define one variable is too much. There is a shorter way to define variables:

``` fasm
variable1 db 100
```

which is the same as

``` fasm
label variable1 byte
db 100
```

notice that size of variable is defined too. In general, if data definiton (using `db` or `dw` directive) is preceded by a label, then it will define this label too, and assign to the label the same size of the defined data. It can be used with words too:

``` fasm
variable2 dw 100
```

An example of variables usage:

``` fasm
mov ah,2
mov dl,[character_to_write]
int 21h
int 20h
character_to_write db 'a'
```

3.3. Addresses and basics of segmentation
-----------------------------------------

Now we will discuss addresses a little further. I told you that an address is number (**!**) which refers to a position in memory. You’ve learnt how to represent this number with labels, so that their numeric addresses are managed by the compiler. But you still don’t know anything about the format of this number. I will try to explain it a little in this chapter.

As you probably know, data in memory are stored in “**bits**” which can have value `0` or `1`. You can consider memory as a (one dimensional) array of bits. 8 consecutive bits make one **byte**. An address is the number (index, position in array) of a byte. For example address “`0`” is the address of the first bit of memory (or address of the first byte), address “`1`” is the address of the eighth bit (or address of the second byte) of memory, etc. The easiest way to comprehend it is to think of memory as a (one dimensional) array of bytes

Addresses in `.COM` files are word-sized numbers, so

``` fasm
label var1
<some data>
mov al,var1
```

is wrong. It may work if `var1` is less than 256 (so it fits into a byte sized register), but as a general rule store addresses in word-sized variables — we’ll talk about them later on.

Now, some addresses examples. Check this file:

``` fasm
label variable1
db 10
label variable2
db 20
label variable3
db 30
```

here the address represented by `variable1` is `0`, whereas `variable2` stands for `1`, and `variable3` for `2`.

OK, this looks nice except that it is’nt true, at all! The problem is that usually there are multiple programs loaded in memory at the same time (operating system, mouse driver, you program, etc.). In this context the program would have to know WHERE in memory will it be loaded so it can access it’s variables. For this reason addresses are “**relative**”. It means that for each loaded program is reserved a region in memory called “**segment**”. All memory addresses accessed by this program are going to be relative to the begginning of this region. So `[0]` doesn’t mean the first byte of memory, but the first byte of the segment.

<div class="alert alert-info">
**segment**

A consecutive region of memory reserved for a program.
</div>
How does this work? The processor has a few special registers (segment registers) which hold the address of the segment (ie: the address of the first byte of the segment). Every time you access memory in your program the content of this segment register is added to the address you provided; therfore `mov al,[0]` accesses the first byte of your segment.

<div class="alert">
**NOTE:** I have told that memory addresses in `.COM` programs are words. That means they can be in the range 0 to 65535. Therefore the maximal size of a segment is 65536 bytes. This can be “tricked” by changing the content of segment registers, but don’t bother with this right now.
</div>
<div class="alert">
**NOTE:** A segment is a region in memory. But the term “segment” is often used to indicate the beginning address of this region. Sad but true.
</div>
So an absolute address in memory has two parts: segment (exactly: the address of the segment’s beggining) and, as second part, a word-sized value called “**offset**” which is the address relative to the segment (ie: address of segment’s beginning).

<div class="alert alert-info">
**offset**

An address relative to a segment, or address “inside” a segment.
(the first definition is more exact, but the second is easier to comprehend)
</div>
<div class="alert alert-warn">
**IMPORTANT:** I stated that labels represent the address of a variable. As a matter of fact, labels in FASM represent the offset of a variable. This is why FASM is called “**flat**” assembler --- you'll understand this later on (much much later __:)__).
</div>
I won’t get deeper into segment registers — on how a segment’s beginning address is stored in them (there IS difference). Right now, take segment registers as some kind of black box that works even if we ignore how.

3.4. The ‘org’ directive explained
----------------------------------

As your program is loaded, it often needs some external info from the program that launched it. The best example is command line arguments; or it may need know WHO launched it; etc. This value must, of course, be stored in the same segment of the program. In `.COM` files this data (passed to your program by the program that you launched it from) is stored in the first 256 bytes of the segment. Therefore, your program is loaded from offset 256 onward.

<div class="alert">
**NOTE:** The 256-bytes structure at the beginning of a `.COM` file is called “**PSP**”, which stands for “**program segment prefix**”
</div>
Now imagine this `.COM` program:

``` fasm
mov al,[variable1]
int 20h
variable1 db 0
```

(notice: no `org 256` directive). Instruction `mov al, [variable1]` takes up 3 bytes, `int 20h` takes up 2 bytes, therefore `variable1` will stand for offset 5. Therefore instruction `mov al,[variable1]` is `mov al,[5]`. So this instruction accesses the 6th byte of the segment (first byte is at offset 0). But I already told you that the first 256 bytes of the segment store some informations, and that your program is loaded beyond them, from offset 256 onward. So you don’t want `variable1` to be 5, you want it to be 256+5. And this is what the `org` directive does: It sets the “**origin**” of the file’s addresses. `org 256` tells FASM to add 256 to the offset held by every label defined beyond this directive (before the next `org` directive). And this is exactly what we want in `.COM` files.

Therefore the previous code example won’t access the variable you want, it will access something in PSP (first 256 bytes of segment). To make it work properly use:

``` fasm
org 256
mov al,[variable1]
int 20h
variable1 db 0
```

<div class="alert">
**NOTE:** `org` affects labels at defintion-time (for example at `label variable byte` or `variable db 0`), not when they are used (like at `mov ax,[variable]`). That means, that if you change addresses' “origin” via the `org` directive after defining some label, that label will still hold the same value before and beyond the `org` directive.
</div>
I won’t tell you anything about the data contained in the PSP, you dont have to worry about it for now.

4. Endian Encodings and Word Registers
======================================

4.1. Endian encodings
---------------------

We should already have a precise idea about byte variables. You already know they are 8 bit wide (not so important now) and that they can contain a numeric value ranging from **0** to **255**. Regarding word variables, you know that they are 16 bits wide and they contain a value ranging from 0 to 65535.

<!-- NOTE: THIS PART WAS REVISED TO MAKE IT CLEARER -->
Whether you can see it or not, a word has the same size as two bytes. Now let’s deal with how values are stored in two bytes. Both bytes can contain a value ranging from **0** to **255**. From their combination we get **256\*256**, that is **65536**. But how is this value actually stored in two bytes?

Let’s say one of the bytes (**byte\#1**) holds value 0. The other byte (**byte\#2**) can hold a value from 0 to 255. In this case we can store numbers ranging from 0 to 255 in our word. Now let’s suppose that **byte\#1** holds 1; we can store in the other byte a value 0-255, which gives us numbers 256 to 511. When **byte\#1** contains 2, we can store 256 other possible values in the other byte, which gives us numbers 512 to 767; and so on. In total, we have 256\*256 combinations which, as I said, amounts to 65536.

It is like with decimal numbers: every digit is a value 0 to 9, and the “true” value of a digit depends on it’s position. The last digit holds value 0 to 9, the previous one holds 10\*(0 to 9), the next one 100\*(0 to 9), and so on.

It’s the same with words: One of the two bytes hold value 0 to 255, the other one holds value 256\*(0 to 255). The byte holding 0..255 is called “**low order byte**”, the other one (holding 256\*(0..255)) is called “**high order byte**”.

<div class="alert alert-info">
terms: **low order byte**, **high order byte**
</div>
Examples (word value = high order byte : low order byte)

``` nohighlight
 WORD | HOB | LOB |
-------------------
    0 =   0 :   0
    1 =   0 :   1
  255 =   0 : 255
  256 =   1 :   0
  257 =   1 :   1
  511 =   1 : 255
  512 =   2 :   0
  513 =   2 :   1   (   513 / 256 =   2 | 513   mod 256 =   1 )
65535 = 255 : 255   ( 65535 / 256 = 255 | 65535 mod 256 = 255 )
```

On last problem remains: The order of these bytes. (ie: which comes first, low order byte or high order byte?). This is handled differently on different computers. On IBM PCs (and compatible) low order byte comes first, and high order byte second. For example, with:

``` fasm
label variable
dw 0
```

then `byte [variable]` is the low order byte, and `byte [variable + 1]` is the high order byte. (The `+ 1` addition to `variable`’s offset is carried out by the compiler, the value of `variable` is constant, so `variable + 1` is constant as well. It means the next byte beyond `variable`’s offset. I think this should be clear enough to need no further explaination).

<div class="alert">
**NOTE:** When the low order byte comes first, then it's called “**little endian encoding**”; when it's the high order byte that comes first, then it's called “**big endian encoding**”. But these terms are not important, especially for a beginner ASM coder.
</div>
4.2. Word registers
-------------------

Beside the byte registers (like `al`,`ah`, `dl`…) the processor has also some word registrs, of course. As you know, a word is combination of two bytes, and it’s the same with registers. Word registers are a combination of byte registers. The first word registers we’ll learn are `ax`, `bx`, `cx` and `dx`.

`ax` is the combination of `al` and `ah`, where `al` is the low order byte, and `ah` the high order byte. The same goes for the rest: `bx` = `bh:bl`, `cx` = `ch:cl`, `dx` = `dh:dl`.

If you were to “**emulate**” register `ex` in memory it would be:

``` fasm
label ex word
el db 0
eh db 0
```

`el` would be the low order byte, so it comes first.

<div class="alert alert-info">
terms: **word register**

word registers: `ax`, `bx`, `cx`, `dx`
</div>
<div class="alert">
**NOTE:** The letters `a`, `b`, `c` and `d` stand for “**accumulator**”, “**base**”, “**counter**” and “**data**”, it has nothing to do with alphabetical order. The real order of these registers is `ax`, `cx`, `dx`, `bx`; but it is not important until you want to generate/change machine code yourself.
</div>
Now, if you want to set the value in register `ax` to 52 you use:

``` fasm
mov ax,52
```

but you also could use:

``` fasm
mov al,52
mov ah,0
```

To set `dx` to 12345:

``` fasm
mov dx,12345
```

but it could also be done (no reason to do it this way in real coding, this is just to demonstrate word to byte:byte relations):

``` fasm
mov dh,48
mov dl,57
```

because 48 is equal to “12345 / 256”, and 57 is “12345 modulo 57” (modulo is the remainder after division).

<div class="alert">
**NOTE:** You know that the instruction operand can be a number (numeric constant), like “`0`”, “`256`”, “`12345`” etc. But every assembler I know of allows you to place an expression as operand. During compilation, the value of the expression is evaluated and the expression is “replaced” by it’s result. So `mov dx,(1 + 5)` is same as `mov dx,6`. Therefore the previous code example could be better written as

``` fasm
mov dh,12345/ 256
mov dl,12345 mod 256
```

("`/`" is the division operator, `mod` (modulo) is the operator which returns the remainder of a division. You don’t have to know these operators right now, but you should already know something about expressions).
</div>
The processor has also other word registers: `sp`, `bp`, `si`, `di`. But you can’t access directly the byte parts of these registers, you must access the whole word. This is a limitation of the processor, so there’s nothing you can do about it. For example, if you want set the high order byte of `si` to 17 you must do it this way:

``` fasm
mov ax,si
mov ah,17
mov si,ax
```

So first you copy the value of `si` to `ax`. The high order byte of `ax` can be accessed dirctly (it’s the `ah` register), so you set it to `17`. The low order byte of the word remains unchanged. Then you copy back the value from `ax` to `si`. Now the word’s high order byte has been changed to `17`, while its low order byte remains unchanged.

<div class="alert">
**NOTE:** Register `sp` always has a special function; `bp` usually has a special function (in code generated by most (all?) non-assembly compilers). Registers `si` and `di` can be used whenever you want. This means you shouldn’t change `sp` and `bp` unless you know what you are doing.
</div>
4.3. String output using int 21h/ah=9
-------------------------------------

This should belong to [**Chapter 3**](#labels-addresses-and-variables), about addresses, but you need to know the `dx` register which is explained here.

Here we will talk about another usage of `int 21h`. You should already know that when `ah` contains 2 then `int 21h` prints the character stored in `dl`. But if we wanted to display a long text we would have to set `dl` for every char, and this would be a bad method. Wouldn’t it be better if we just stored the string we want to display somewhere in a file (like we did in [**Chapter 1**](#getting-started)) and then just display it from here?

For this we can use `int 21h` with value `9` in `ah` and the string’s address in the `dx` register. Something like:

``` fasm
mov ah,9
mov dx,address_of_string
int 21h
```

But another problems pops up: how to determine the length of the string, ie: the number of characters to display from the given address. There are different methods to achieve this, we will talk about the simplest one, the one used by `int 21h/ah=9`. It relies on a special character, which is reserved as end-of-string marker. With `int 21h/ah=9`, it’s the “`$`” character. So, to store the string “`Hello World`”, you define “`Hello World$`”, where “`$`” means end of string. Example of displaying a string:

``` fasm
org 256
mov ah,9
mov dx,text_to_display
int 21h
int 20h
label text_to_display
db 'Hello World$'
```

This program will print “`Hello World`”.

This method of marking the end of a string has a limitation: you can’t print the “`$`” character. For example:

``` fasm
org 256
mov ah,9
mov dx,text_to_display
int 21h
int 20h
label text_to_display
db 'It costed 50$, maybe more$'
```

will of course print only “`It costed 50`”. This can be worked around this way:

``` fasm
org 256
mov ah,9
mov dx,text1
int 21h
mov ah,2
mov dl,'$'
int 21h
mov ah,9
mov dx,text2
int 21h
int 20h
label text1
db 'It costed 50$'
label text2
db ', maybe more$'
```

The first part (first `int 21h`) will print “`It costed 50`”, then `int 21h/ah=2`, will print “`$`” and the second `int 21h/ah=9` will print “`, maybe more`”. We won’t deal any further with this limitation, for now — this was just to improve on the explanation.

Let’s now take a closer look at `int 21h/ah=9`. As you maight have realized already, it will print every character (exactly: every character whose ASCII code is in byte form) from the address contained in `dx` until the first “`$`” character after the address in `dx`.

<div class="alert">
**NOTE:** ASCII codes 0 to 31 (I think) have a special meaning for `int 21h/ah=9`. These codes have characters assigned to them (smiling faces, diamonds etc.) but `int 21h/ah=9` doesn't print them, but does something else. For example, the character with ASCII code 7 will produce a short beep. Try this:

``` fasm
org 256
mov ah,9
mov dx,text
int 21h
int 20h
label text
db 'Beep',7,'$'
```

It should print “`Beep`” and then beep.
</div>
Other common values are 10 and 13: `10` causes the cursor to return to the first column of the current row; `13` causes cursor to down move one row (if them bottom of screen is reached, then the screen is scrolled). So a combination of these two causes the cursor to move to the first column of the next row. These two should (but don’t always do) work in any order, but you should always place `13` first. These two characters are often called EOL (end of line). Try this example:

``` fasm
org 256
mov ah,9
mov dx,text
int 21h
int 20h
label text
db 'Line 1',13,10,'Line 2$'
```

it should print:

``` nohighlight
Line 1
Line 2
```

<div class="alert">
**NOTE:** ASCII code 13 is called "CR" (carriage return) and code 10 is called "LF" (line feed).
</div>
Another example on addresses (previous chapter), but with word registers. Check by yourself whether you understood [**Chapter 3**](#labels-addresses-and-variables):

``` fasm
org 256
mov ah,9
mov dx,[address_of_text]
int 21h
text db 'Hello World$'
address_of_text dw text
```

Here we load the `dx` register with the contents of `address_of_text` variable, which holds value `text`, and (as we already know) `text` is a placeholder for the offset of ‘`Hello World$`’ string. Thus the word-sized variable `address_of_text` holds the offset of that string. Therefore, loading `dx` with the contents of `address_of_text` will load it with the offset of the string we want to print. I hope you got it.

5. Jumps and Branching
======================

You should know a little about how instructions are processed by the processor. It fetches an instruction in machine code, executes it, and then moves to next instruction. This is repeated until instruction `int 20h` is reached. In this chapter we will learn something about instructions which change this behaviour.

5.1. Instruction pointer
------------------------

The processor loads the first instruction (it determines the number of bytes the instrution consists of), executes it and then moves to another instruction. But how does this mechanism works? The processor has a special word register “`ip`” which holds the address of the instruction currently executed. After the instruction is executed, the processor adds its size to “`ip`” and executes the instruction located at the (new) address in “`ip`”. This mechanism works like this:

-   Loop:
    -   Execute instruction on `ip`
    -   `size` = size of instruction on `ip`
    -   `ip` = `ip` + `size`
-   Until instruction `int 20h` is found

<div class="alert">
**NOTE:** As with others pointers, “`ip`” doesn’t hold the full address of the instruction, just the offset part. Be we shouldn't worry about this right now.
</div>
<div class="alert">
**NOTE:** “`ip`” stands for “**instruction pointer**”.
</div>
5.2. Jumps
----------

The `ip` register is not like the other registers (`ax`, `ah`, `bp`, …). It’s contents can’t be changed using the `mov` instruction. `mov ip,5` doesn’t work. But there is a special instruction which can change the value of `ip` register: it’s the `jmp` instruction (“`jmp`” = “**jump**”). This instruction has one operand, the new address for `ip` register. So `jmp 5` has an effect like `mov ip,5` would if it was an instruction. Example:

``` fasm
org 256
jmp Start
text db 'Text to output'
Start:
mov ah,9
mov dx,text
int 21h
int 20h
```

The first instruction sets the value of `ip` to the address of `mov ah,9` instruction (its address is held in label `Start`). Thus the processor won’t try to execute the bytes defined by “`Text to output`” string and this program will work.

<div class="alert">
**NOTE:** Of course, when `ip` is changed by the `jmp` instruction, then the size of this instruction is NOT added to it.
</div>
5.3. Comparing and conditonal jumps
-----------------------------------

If you can write code in any language you should already know about branching, ie: conditional execution of some parts of code. For example, suppose you want a value not greater than 10 in `al`. If the value in `al` register is &gt; 10, you will set `al` to 10. This is branching — if some condition is true then something is executed, otherwise it is not executed. Assembly implementation of this mechanism is that when a condition is false you will jump over the conditional code, when the condition is true you will just continue the execution. It is as if this C code:

``` c
if (condition)
  ConditionalCode(); // this can be any C code, not just function call
```

would be writen this way:

``` c
if (!condition) goto LabelAfterConditionalCode;
ConditionalCode(); // this can be any C code, not just function call
LabelAfterConditionalCode:
```

The first problem is how to decide whether a condition is true. In assembly, there is an instruction which can compare two operands. It is `cmp`. Its operands follow the same rules as `mov`’s operands (almost every instruction follows these or very similar rules). Some examples of comparing:

``` fasm
cmp ax,bx                 ; compare value of "ax" to value of "bx"
cmp al,byte [SomeLabel]   ; comapre value of "al" to byte at SomeLabel
cmp ax,5                  ; compare value of "ax" to 5
cmp ax,al                 ; wrong, operands have different size
```

This instructions checks whether the first operand is the same, greater or lesser compared to the second one.

<div class="alert alert-info">
instruction: **cmp**
</div>
OK, we can compare, but how are the results of comparison stored? The CPU (the processor) has a special register called “**flags register**” in which it stores results of comparison (and some other things too). This register (like `ip`) can’t be accessed with `mov` or similar instructions; its value is set by the `cmp` instruction. Right now you don’t have to bother HOW the result of comparison is stored in this register — you would need to understand bit arithmetics for that.

<div class="alert alert-info">
register: **flags**
</div>
OK, we can compare, and we know that the result is stored in `flags`. The only thing we need now is the conditional jump itself. A conditional jump is a jump which is taken only when a condition you specified is true (in the flags register). It will be best explained on example. We compare `ax` to `bx` (`cmp ax,bx`). A conditional jump can jump if `ax` &lt; `bx`, or when `ax` = `bx`, or when `ax` &gt;= `bx` etc. These jumps are (op1 is first operand of `cmp`, op2 is second):

-   `je` — jump if op1 = op2 (op1 is “**equal to**” op2)
-   `ja` — jump if op1 &gt; op2 (op1 is “**greater than**” op2)
-   `jb` — jump if op1 &lt; op2 (op1 is “**less than**” op2)
-   `jae` — jump if op1 &gt;= op2 (op1 is “**greater than or equal to**” op2)
-   `jbe` — jump if op1 &lt;= op2 (op1 is “**less than or equal to**” op2)

Example code (don’t try to compile it, it is not a `.COM` executable, it’s just a snippet of code):

``` fasm
cmp ax,10
jbe AX_lesser_than_10
mov ax,10
AX_lesser_than_10:
```

this piece of code will check whether value in `ax` is less than or equal to 10, and if not (if the value in `ax` is greater than 10) it will set `ax` to 10. The corresponding C code is:

``` c
if (ax > 10) ax=10;
```

or, more similar to our assembly version:

``` c
if (ax <= 10) goto AX_lesser_than_10
ax=10;
AX_lesser_than_10:
```

Another example: get maximum of `{ax,bx}` and store it in `ax`:

``` fasm
cmp ax,bx
jae AX_already_contains_greater_value
mov ax,bx
AX_already_contains_greater_value:
```

So compare `ax` to `bx`, if it is greater or equal then it already contains the greater value, so we dont need to change anything. If `ax` is less than `bx` then we must move `bx`‘s’ value (=greater value) to `ax`.

A more complicated version: store maximum of `{ax,bx}` in `cx`:

``` fasm
cmp ax,bx
ja  AX_bigger
mov cx,bx
jmp done
AX_bigger:
mov cx,ax
done:
```

here we compare `ax` to `bx`, then if `ax` is less than `bx` the jump won’t take place and we continue with `mov cx,bx`, which stores the greater value in `cx`, as desired, and then `jmp done` skips the instructions used in case `ax` is greater. Otherwise, if `ax` is greater than `bx`, then `jmp AX_bigger` takes place, so the next instruction is `mov cx,ax` which moves the greater value (ie: the one in `ax`) to `cx`. As you can see, the code was divided into two “branches”: one for `ax`&gt;`bx`, the other for `ax`&lt;=`bx`. Finally, both branches reach the instruction beyond `done:`, and at this point `cx` always holds the greater value. By the way, there could be `jae` instead of `ja`, because for the case when `ax`=`bx` both branches have the same effect.

<div class="alert alert-info">
instructions: **je, ja, jb, jae, jbe**
</div>
But what can we do if we want to jump when operands are NOT equal? We could do something like this:

``` fasm
cmp ax,bx
je Same
jmp NotSame
Same:
...
NotSame:
```

but this is not needed because there are instructions which jump when the condition is false. These are `jne`, `jna`, `jnb`, `jnae` and `jnbe`. Instruction `jne` jumps when operands are not equal, `jna` when first operand is not greater than second operand, etc. Therefore:

``` fasm
cmp ax,bx
jne NotSame:
...
NotSame:
```

where the `...` part is executed only if the value in `ax` is equal to the value in `bx`.

<div class="alert">
**NOTE:** `jna` is the same as as `jbe`, `jnb` is the same as as `jae`, `jb` is the same as as `jnae`, and `ja` is the same as as `jnbe`.
</div>
<div class="alert alert-info">
instructions: **jne, jna, jnb, jnae, jnbe**
</div>
<div class="alert alert-warn">
**IMPORTANT:** Many instruction change the `flags` register, not just `cmp`, so conditional jumps should come right after `cmp`, with no instructions between them.
</div>
6. Bit Arithmetics
==================

This is what most tutorials usually start with. After reading this you will be confused, it’s normal. You’ll master this through practice. Return to this chapter whenever needed. So let’s go.

6.1. Encoding numbers in bits
-----------------------------

You know that computers use “**bits**”, which are variables that can contain one of two possible values: `0` or `1`. When a bit’s value is `0`, we say that it’s “**clear**”, when it’s `1`, we say that it’s “**set**”

<div class="alert alert-info">
terms:

**bit** --- A variable containing `0` or `1`.

**clear bit** --- A bit containing `0`.

**set bit** --- A bit containing `1`.
</div>
Now, how can we store a number in these bits? It’s similar to storing a word in two bytes ([**Chapter 4.2**](#word-registers), re-read it). One bit contains a `0` or `1` value, therefore a number that consists in just one bit can only contain values 0 and 1. When we add another bit, we can still store 0 and 1 in the first bit, but we have another bit which now can hold 2\*(0 or 1). A further bit holds 4\*(0 or 1), and then 8\*(0 or 1), etc.

Like I said before, a byte consists of 8 bits. So it can hold a value of:

``` nohighlight
1*(0 or 1) + 2*(0 or 1) + 4*(0 or 1) + 8*(0 or 1) + 16*(0 or 1) + 32*(0 or 1) + 64*(0 or 1) + 128*(0 or 1)
```

which is value ranging from 0 (when all bits are `0`) to `1+2+4+8+16+32+64+128` = 255 (when all bits are `1`). Can you see it?

It is similar with a word, except you have 16 bits instead of 8; check it yourself if you wish.

Now some terms: the bit which holds 1\*(0 or 1) is **bit\#0**; the next one, which holds 2\*(0 or 1) is **bit\#1**; and so on until **bit\#7**, which holds 128\*(0 or 1). So bits are enumerated starting from 0, not from 1 — as you would maybe exepect. Bit\#0 is called the “**low order bit**”, the highest bit (which holds the greatest value) is the “**high order bit**”. For example, the high order bit of a byte value is bit\#7, and the high order bit of a word value is bit\#15.

<div class="alert alert-info">
terms: **low-order bit**, **high-order bit**
</div>
<div class="alert alert-warn">
**IMPORTANT**: Bits are enumerated starting from 0, not from 1, so the first bit is bit\#0.
</div>
A number encoded this way (in bits) is called a “**binary number**”.

6.2. Binary constants
---------------------

You have been using numeric constants before, probably without realizing you were using them. These numeric constants were just numbers you wrote in a source file which was assembled into a binary file. Examples of numeric constants ar: “`0`”, “`50`”, “`-100`”, “`123456`”.

You used them here:

``` fasm
db 5
mov al,20
cmp ax,5
db 'Some string',0
org 256
```

These numbers were decimal numbers, the type which is normally used by people. The assembler then translated them to binary form. But sometimes you want to specify numbers directly in binary format. Of course you don’t have to manually translate them to decimal, you can specify them directly in binary. Here are some examples of binary numbers: `0`, `101011`, `1101011`, `11111`, etc. To distinguish them from decimal numbers, every binary number must end with the “`b`” character, therefore: “`0b`”, “`101011b`”, “`1101011b`”, “`11111b`” etc. Here the first binary digit (the first bit, the first `0` or `1`) is the high-order bit, and the last one is the low-order bit. So if you write “`1101`”, then bit\#0 = 1, bit\#1 = 0, bit\#2 =1, bit\#3 = 1.

Example table:

| decimal | binary   |
|:--------|:---------|
| 0       | `0b`     |
| 1       | `1b`     |
| 2       | `10b`    |
| 3       | `11b`    |
| 4       | `100b`   |
| 5       | `101b`   |
| 6       | `110b`   |
| 7       | `111b`   |
| 10      | `1010b`  |
| 15      | `1111b`  |
| 16      | `10000b` |

I could teach you a way to translate numbers between decimal and binary forms, but you won’t need it just now anyway, and plenty of other tutorials are full of such information.

Binary numeric constants are just another way to express some number. Writing “`5`” is the same as writing “`101b`”. For example, this will work too:

``` fasm
org 100000000b
mov ah,1001b
mov dx,string
int 21h
int 20h
string db 'Hello world writen using binary constants',0
```

`org 100000000b` is the same as `org 256`, and `mov ah,1001b` is the same as `mov ah,9`

6.3. Bit operations
-------------------

Now let’s think about what we can do with a bit (which can hold a `0` or `1` value).

First, we can “**set**” it (set its value to `1`) or “**clear**” it (set its value to `0`). Then we can “**flip**” its value (from `0` to `1`, from `1` to `0`). And that is probably all. This operation is also called “**bit complement**” (`0` is the complement of `1`, and `1` is the complement of `0`).

Now, what can we do with 2 bits? You can think of bits as boolean values, which can be either true (`1`) or false (`0`). Now, what operations can we make with boolean values? If you programmed before you’ll probably know the answer.

First of all, there is `and` (like “`a and b`” where “`a`” and “`b`” are boolean values). When we have two boolean values, the result of `and`ing them is true only when they are both true, otherwise the result is false. (See Table below)

Then comes `or`. As you know, the result of `or`ing two values is true when at least one of them is true. And finally — and less known — there is `xor`, which means “**exclusive or**” (the previous one was “**inclusive or**”, but everyone calls it just “**or**”). The result of `xor`ing is 1 when one operand is `1` and the other is `0`.

Here is the Table:

|  A  |  B  | A and B | A or B | A xor B |
|:---:|:---:|:-------:|:------:|:-------:|
|  0  |  0  |    0    |    0   |    0    |
|  0  |  1  |    0    |    1   |    1    |
|  1  |  0  |    0    |    1   |    1    |
|  1  |  1  |    1    |    1   |    0    |

<div class="alert">
**NOTE:** There are 16 possible operations on two bits, but we won't talk about all of them.
</div>
Now the interesting part: In late times, processors designers didn’t like having lots of instructions on their processors. But as you saw, we defined 3 operations for a single bit and 3 for two bits. So they found a way to achieve operations on single bit by using operations on two bits. Remember, the operations on a single bit were: setting it to `0`, setting it to `1` and flipping its value (`0`-&gt;`1`, and `1`-&gt;`0`). How?

First let’s talk about clearing a bit (setting its value to `0`). Note that the result of `and` is `0` whenever at least one of operands is `0`. So if we `and` any bit (`0` or `1`) with `0` we always get `0`, and when we `and` with `1` the bit will reamin unchanged. And this is what we wanted. It is similar to setting a bit (to `1`). The result of `or`ing is `1` when at least one operand is `1`. So `or`ing any bit with `1` will always produce `1`, and `or`ing with `0` will leave the bit unchanged.

How can we flip a bit? The result of `xor`ing is `1` when one operand is `1` and the other is `0`. So `xor`ing any value with `1` will always produce that value’s complement, and `xor`ing it with `0` will leave the bit unchanged. This last one is not so obvious, so you better look at it in the Table.

6.4. Binary operations instructions
-----------------------------------

First of all, you know the the smallest registers we have are the 8 bits (byte) registers. Also the smallest part of memory that we can access is one byte (8 bits). For this reason, the instructions used for binary operations will operate on two 8-bit numbers instead of on two bits. What will be the result? **Bit\#0** of the result will be the result of the operation between **bit\#0** of the first argument and **bit\#0** of the second argument. **Bit\#1** of the result will be the result of the operation on **bits\#1** of the arguments, etc. You ’ll see it.

Our first operation will be an “`and`”. Example:

``` fasm
mov al,00010001b
mov bl,00001001b
and al,bl
```

<!-- NOTE: EXAMPLE CORRECTED: "bl,00000001b" => "bl,00001001b" -->
first we load `al` with `00010001b`, so it’s **bits \#0** and **\#4** contain `1`, the remaining bits contain `0`. Then we load `bl` with `00000001b`, so it’s **bit\#0** contains `1`, the others contain `0`. When we `and` `al` with `bl` (this is how asm coders usually describe it) it works as `al = al and bl` would – ie: the result of `and`ing `al` with `bl` is stored in `al`.

So what’s the final result (in `al`)? **Bit\#0** of `al` contained `1` and was `and`ed with `1`. “`1 and 1`” is `1`, so **bit\#0** in `al` will be `1`. **Bits \#1** to **\#2** and **\#5** to **\#7** would be “`0 and 0`” which is `0`. **Bit\#3** would contain “`0 and 1`” which is `0` too. **Bit\#4** will contain “`1 and 0`” which is `0` again. So the result will be `00000001b`.

A better way to write the previus code would be:

``` fasm
mov al,00010001b
and al,00001001b
```

(I used `bl` in the previous example only to simplify referencing the second number in the text).

Now, an example of `or`ing:

``` fasm
mov al,00010001b
or  al,00001001b
```

… the result will be `00011001b`. (see: `or` description, in previous section).

And of `xor`ing:

``` fasm
mov al,00010001b
xor al,00001001b
```

… the result will be `00011000b` — bits `xor`ed with `0` will stay unchanged, bits `xor`ed with `1` will be flipped (to their complement).

<div class="alert alert-info">
instructions: **and, or, xor**
</div>
These instructions take the same arguments as `mov` — ie: the first argument can be a memory variable or a register, the second one can be a memory variable, a register or a constant. <mark>Both arguments must be of the same size, and only one of the arguments can be a memory variable.</mark>

6.5. Testing bits
-----------------

If you have programmed before, you probably already know about boolean variables (ocassionaly called “logical”). They can hold two values: `TRUE` or `FALSE`. You can see that they can be stored in a bit wuite finely — `1` for `TRUE`, and `0` for `FALSE`.

<div class="alert alert-info">
term: **boolean variable**
</div>
The problem here is that the smallest data directly accessible is a byte (8 bits). As you know, you can access a byte register or a byte memory variable, not a bit. It’s truely this way: there are no instruction which can access just one bit. (Of course there are, you just don’t need to know about them right now **:)**)

But when you work with boolean variables you want to access just one single bit, not all 8 bits or more. There are some tricks to achieve this:

Use only one bit of the whole byte and leave the other bits cleared. Thus if you want to verify if the bit is `0`, you just check if the whole byte is equal to `0`. If it isn’t, then our bit is `1`. Example:

``` fasm
cmp [byte_boolean_varaible],0
je byte_boolean_variable_is_false
jnz byte_boolean_varaible_is_true
```

where `byte_boolean_variable` is a byte varaible with only one bit used. When this variable is `0` then its value is `FALSE`, otherwise its value is `TRUE`.

`byte_boolean_variable_is_***` are labels used for branching, as shown in a previous chapter. By the way, a better “more assembly” way to implement the previous code is:

``` fasm
  cmp [byte_boolean_varaible],0
  je byte_boolean_variable_is_false
byte_boolean_varaible_is_true:
  <here value is TRUE>
byte_boolean_varaible_is_false:
  <here value is FALSE>
```

beacause in the first version the `jnz` conditonal jump would always take place, because the instruction is executed only when `je` didn’t take place. If you don’t understand it, read again the previous chapter.

But this approach leaves 7 bits unused, and this is a waste of space. (Not in case of a single variable, but surely so with an array of similar variables). Clearly, we can “**pack**” 8 boolean variables into a single byte (8 bits). The only problem is setting and reading it.

First, we’ll set all 8 bits (boolean variables) using `mov` instruction.

``` fasm
mov [eight_booleans],00000000b
```

this would set all variables to zero (clear them). If we want to set some of them to one, we just set the bits in which they are stored.

``` fasm
mov [eight_booleans],00010100b
```

this will set variables in **bits \#2** and **\#4**, and leave all others clear.

First, how to **clear** one bit and leave all others unchanged? We handled this before: we can do it by `and`ing:

``` fasm
and [eight_booleans],11110111b
```

… this will clear **bit\#3** (`and`ed with `0` so the result will be `0`), and leave all other bits unchanged (`and`ed with `1` so they will reamain unchanged). This will clear **bits \#3** and **\#5**:

``` fasm
and [eight_booleans],11010111b
```

All this should be clear to you if you understood [**Chapter 6.4**](#binary-operations-instructions).

Now, how to **set** one of the variables:

``` fasm
or [eight_booleans],00001000b
```

… this sets **bit\#3** to `1` (`or`ing with `1` always yelds `1`) and leave the others unchanged (`or`ing with `0` leaves unchanged).

And, of course, using `xor` we can **flip** bit(s):

``` fasm
xor [eight_booleans],00001000b
```

… will flip **bit\#3** and leave the others unchanged.

These were just a reminder, now let’s deal with how to check the value of bits. Checking the value of bit is called “**bit testing**”.

<div class="alert alert-info">
term: **bit testing**
</div>
<!-- NOTE: FOLLOWING PARAGRAPH WAS REVISED -->
You often need to test the value of some boolean variable and then do something (jump somewhere) if it is (or isn’t) TRUE. We did this with a byte-sized boolean variable using the `cmp` instruction, but it is impossible to use `cmp` for testing just a single bit of a byte. For this reason, there is a `test` instruction. It takes the same arguments as `mov`, `xor`, `and`, `cmp`, etc.

It `and`s it’s operands and then sets flags accordingly, so that if the result of `and`ing them was `0` then `je` will jump, otherwise (if result wasn’t zero) `je` won’t jump (and `jnz` will).

``` fasm
test arg1,arg2
```

… acts similarly to:

``` fasm
and arg1,arg2
cmp arg1,0
```

… but it doesn’t modify `arg1` and you use `jz` (jump if zero) and `jnz` (jump if not zero) conditional jumps. `jz` jumps if the result of virtual `and`ing (testing) is zero. Similary, `jnz` jumps, if result is not zero (eg. at least one of the tested bits is non-zero)

<div class="alert">
**NOTE:** In fact, `jz` is the same instruction as `je`, and `jnz` is the same as `jne`; therefore, in our `and`/`cmp` example, using `jz` would be the same as using `je`.
</div>
<div class="alert alert-info">
instruction: **test**
</div>
An example of using `test`:

``` fasm
test [eight_booleans],00001000b
jz bit_3_is_clear
bit_3_is_set:
<...>
bit_3_is_clear:
<...>
```

<!-- TEXT CORRECTED TO MATCH CODE: `je` => `jz` -->
… all bits but the third one of `eight_booleans` are `and`ed against `0` (but `eight_booleans` remains unmodified), which means they are cleared, only the value of **bit\#3** will remain. The result of this operation will be zero (and `jz` will jump) only if **bit\#3** is `0`. If it’s `1`, the result of the operation will be `00001000b`, not `0`, so `jz` won’t jump.

Now a slightly more dificult example:

``` fasm
test [eight_booleans],00101000b
je bits_3_and_5_clear
bits_3_and_5_not_both_clear:
<...>
bits_3_and_5_clear:
<...>
```

… **bits \#3** and **\#5** of `eight_booleans` will remain, so the result of the operation will be `0` (and `je` will jump) only when both these bits are `0`. If at least one of these bits is `1` the result won’t be `0` (it can be `00001000b`, `00100000b` or `00101000b`) and `jz` won’t jump. But testing two bits at once is not usual practice, at least not for beginners, I gave this example just to provide a better picture of how `test` works.

7. Arithmetic Instructions: More on Flags
=========================================

In this chapter you will learn how to perform basic math operations in assembly language. Then we’ll look deeper into how the processor carries them out, and in doing so yoi’ll learn more about flags.

7.1. Addition and substraction
------------------------------

The simplest case of addition is addition by one, called “**increment**”. For example, if we increment a variable holding value 5, it will contain 6, etc.

The instruction to perform increment is `inc` (its name should be obvious). It has one operand, which tells what should be incremented (ie: to what will 1 be added). The operand can be a register or a memory variable. It can’t be a constant, obviously, because such an instruction (even if it existed) wouldn’t have any effect. Example of increment:

``` fasm
mov ax,5
inc ax       ;increment (add 1 to) value in ax
  ;here ax holds value 6
```

… I think it should be self-explaining (if it isn’t, you’ll see later why).

Substracting 1 from a value is called “**decrement**”. Decrement is the opposite of increment. The instruction which performs decrement is `dec`. Example:

``` fasm
mov ax,5
inc ax       ;increment (add 1 to) value in ax
  ;here ax holds value 6
dec ax       ;decrement (subtract 1 from) value in ax
  ;here ax holds value 5 again
```

<!-- FIXED: "(substracting 0)" => " (subtracting 1)" -->
<div class="alert alert-info">
terms: **increment** (adding 1), **decrement** (substracting 1)

instructions: **inc**, **dec**
</div>
If you wan’t to add or substract more than 1, you can use more `inc`s or `dec`s, but that is a rather ugly way to do it, requires more typing, and the code gets big and slow. So there is instruction which can add any value, this instruction is `add`. It takes two arguments, the first one is the *destination* (ie: the value being added to), and the second one is the value to be added. Argument types are the same as for `mov`: the first one can be a register or a memory variable, the second one can be a constant, a register or a memory variable (only if the first one isn’t memory variable! Always remember: <mark>a single instruction can’t access two memory locations</mark>). Example:

``` fasm
mov ax,5
add ax,5
;here ax contains 10
```

Another example:

``` fasm
mov ax,5
mov bx,5
add bx,[five]
add ax,bx
;here ax contains 15, bx contains 10
five dw 5
```

The instruction for substracting is `sub`. It’s the exact opposite of `add`, but it’s used the same way:

``` fasm
mov ax,15
mov bx,10
sub bx,[five]
sub ax,bx
;here ax contains 10, bx contains 5
five dw 5
```

7.2. Overflows
--------------

There are some cases with addition and substraction which I haven’t yet mentioned. For example, if you try to add 10 to a byte-sized variable holding 250 (the biggest number a byte-sized variable can hold is 255). In such cases, we say that an `overflow` has occured.

But the question is, what happens to the result of an operation that has overflown? When the upper limit of a variable is crossed, the result of the operation will be the rest of the value to be added. We can say that the operation will be “**wrapped**” from maximum value to minimal value. For example:

``` nohighlight
byte   255 +     1 =     0
byte   255 +     2 =     1
byte   254 +     3 =     1
byte   250 +    10 =     5
byte   255 +   255 =   254
word 65535 +     1 =     0 
word 65535 + 65535 = 65534
etc. 
```

There is also another case, when the result of the operation falls below the lower limit (which is 0 for all variable sizes). In this case the result of the operation will be wrapped from the lower limit to the upper limit. This case is called `underflow`. For example:

``` nohighlight
byte   0 -   1 = 255
byte   0 - 255 =   1
byte 254 - 254 =   0
byte 254 - 255 = 255
etc.
```

<div class="alert">
**NOTE:** The word `oveflow` is usually used for both `overflow` and `underflow`.
</div>
<div class="alert alert-info">
Terms: **Overflow**, **Underflow**
</div>
We also need to know how to check if an overflow has occured after performing an operation, to prevent bugs. For this purpose, flags are used. I already mentioned flags in [**Chapter 5.3**](#comparing-and-conditonal-jumps). We used flags for checking the results of comparison at conditional jumps, and I also said that there shouldn’t be any instrcutions between a comparison and its jumps because many instructions change the flags (of course, you can place an instruction there if you are sure it won’t change any needed flag). Arithmetic instructions `add` and `sub` use a flags’ bit called `CF` (carry flag). If an overflow occurs, they set it to `1`, otherwise they set it to `0`. You can test the carry flag with conditional jumps `jc` and `jnc` (see [**Chapter 5.3**](#comparing-and-conditonal-jumps) about conditional jumps). `jc` jumps if the carry flag is set, `jnc` jumps if the carry flag is not set. Here is an example of testing overflows:

``` fasm
add ax,bx
jc overflow
no_overflow:

sub cx,dx
jc underflow
no_underflow:
```

<div class="alert alert-info">
**carry flag (CF)** --- One bit (flag) of “flags” register.

conditional jump instructions: **jc**, **jnc**
</div>
7.3. Zero Flag
--------------

Instructions `inc` and `dec` don’t set `CF`, so you can’t test for overflows using `CF` with them. But there is another rule that can be used to prevent overflows with `inc` and `dec`. This rule is that when the result of an operation is zero, the flag called “**zero flag**” (`ZF`) is set. This flag is tested with `jz` (jump if zero flag is set) and `jnz` (jump if zero flag is clear) conditional jump instructions.

With this you can create loops, ie: repeat several times some part of code .

For example, the following code:

``` fasm
  org 256
  mov cx,5
here:
  mov dl,'a'
  mov ah,2
  int 21h
  dec cx
  jnz here

  int 20h
```

… will write:

``` nohighlight
aaaaa
```

<div class="alert">
**NOTE:** You can optimize the previous code example to:

``` fasm
  org 256
  mov cx,5
  mov dl,'a'
  mov ah,2
here:
  int 21h
  dec cx
  jnz here

  int 20h
```

since the value of `dl` and `ah` isn’t changed anywhere in the loop, we don’t need to set them each time the loop repeats. 
</div>
Not only `add` and `sub` instructions set `ZF` if result is zero (and clear it otherwise). All basic arithmetic instructions do this. So far, you’ve learned these arithmetic instructions: `add`, `sub`, `and`, `xor` and `or`. So, after any of these instruction, `ZF` tells you if destination (first argument) of the operation holds 0. For example, You can use this behavior to check if the value of a register is 0. So far, you’ve learnt to do this with:

``` fasm
cmp ax,0
jz ax_is_zero
```

But you can also do it using “`or`”:

``` fasm
or ax,ax
jz ax_is_zero
```

… `or` won’t change `ax`, because `1` `or`ed with `1` is `1`, and `0` `or`ed with `0` is `0`. (Read again [**Chapter 6**](#bit-arithmetics) if you aren’t following this.) Btw, this was used on older computers because such code is faster and a few bytes smaller than with `cmp`.

7.4. Carry flag: more binary arithmetic instructions
----------------------------------------------------

I mentioned the carry flag a little in connection with overflows. But `CF` is really a general-purpose flag because it can be tested easily (`jc`, `jnc` and a few more), and its value can be easily set. You will find many more uses of `CF` later on.

How to set `CF`? There are two instructions for this: `stc` and `clc`. `stc` stands for “**SeT Carry**”, and it “sets” the carry flag (ie: sets its value to `1`) — so `jc` performs a jump, and `jnc` doesn’t, etc., etc. (you should understand this aleady). Instruction `clc` (CLear Carry) clears `CF`.

Once we know how to work with `CF`, we can learn the rest of bit arihmetic operations. First, let’s look at `shl`. It shift the bits of a register to the left, ie: 0th bit becomes 1st, 1st becomes 2nd, and so on. The last bit (7th in a byte, 15th in a word) is moved to `CF`. The first bit becomes `0`. This way (if the highest bit was zero) we have multiplied the shifted register by 2.

Before shifting:

``` nohighlight
|| bit#7 | bit#6 | bit#5 | bit#4 | bit#3 | bit#2 | bit#1 | bit#0 ||
```

After shifting:

``` nohighlight
|| bit#6 | bit#5 | bit#4 | bit#3 | bit#2 | bit#1 | bit#0 |     0 || ; ( CF = bit7 )
```

Let me explain why the number is multipied by 2. If you remember the beginning of [**Chapter 6**](#bit-arithmetics), you know that a number before shifting is:

``` nohighlight
128*bit#7 + 64*bit#6 + 32*bit#5 + 16*bit#4 + 8*bit#3 + 4*bit#2 + 2*bit#1 + bit#0
```

… so after shifting it becomes:

``` nohighlight
128*bit#6 + 64*bit#5 + 32*bit#4 + 16*bit#3 + 8*bit#2 + 4*bit#1 + 2*bit#0
```

… which is:

``` nohighlight
2*(64*bit#6 + 32*bit#5 + 16*bit#4 + 8*bit#3 + 4*bit#2 + 2*bit#1 + bit#0)
```

Therefore, if the highest bit is zero the number is multiplied by two. This way we can easily multiply by powers of two (`2`, 2^2=`4`, 2^3=`8`, 2^4=`16`, etc.). Furthermore, the highest bit is stored in `CF`, so we can test with `jc` and `jnc` if the multiplication overflowed.

Usually we want to shift more than once (multiply by 4, 8, 16, …), so `shl` takes a second argument, which tells how many times we want to shift. If we shift by a number greater than 1, `CF` will contain `1` if ANY of the discarded bits (*x* highest bits, where *x* is the number of shifts) contained `1`. This way we can still check for overflows. If you are beginner, don’t worry too much about checking for overflows, you probably won’t do it anyway **:)** (and therefore your program will probably contain bugs).

There is one limitation to `shl`: its arguments don’t follow the same rules as the other instructions you’ve learned (`mov`, `add`, etc.) <mark>The fisrt argument can be a register or a memory location, but the second one can only be a numeric constant or the `CL` register</mark> (really, no other!).

<div class="alert">
**NOTE:** Orignially, with 8086 (that’s 086, first of 80x86 series known as x86, like 286 or 486), there was only a `shl` instruction which could shift by one, and so for example `shl ax,3` was compiled into 3 `shl`s. There also wasn’t any shifting by register, you had to make a loop for that. Fortunately 80286 had shifting by constant and by `CL,` so it is OK now.
</div>
We’ve dealt with left shifting, but there is also another type of shifting, ie: shifting to the right. I hope you can by now imagine what it does, so I’ll drop just few notes about it. The instruction that performs this is `shr` (shift right). Its effect is division by two (or powers of two) without remainder. When shifting right by two, the remainder (`0` or `1`) is then found in `CF`; apart from this, `CF` beheaves like shifting left by a number greater than two: If the remainder isn’t `0` (ie: at least one of the discarded bits was `1`) then `CF` is set, otherwise it is clear.

7.5. Some examples
------------------

At least we are now able to print the output of a number (print the number on the screen). It’s a pity that we can only write it in binary form. So here is our task: Write a program that outputs any binary number. For now, we will hardcode the number into the program, ie: `mov`e it into some register as a constant. Here is the source:

``` fasm
org 100h

mov bx,65535 ;we store in bx the number we want to display
 ;(because it's not used by DOS services we use)
mov cx,16 ;we are displaying 16 digits (bits)

;display one digit from BX each loop

display_digit:
shl bx,1
jc display_one

;display '0'
mov ah,2
mov dl,'0'
int 21h
jmp continue

;display '1'
display_one:
mov ah,2
mov dl,'1'
int 21h

;check if we want to continue
continue:
dec cx
jnz display_digit

;end program
int 20h
```

I hope you understand this, it’s quite simple. At each loop we shift the `BX` register left by one, so the upper bit is moved to `CF`, then we print ‘`0`’ or ‘`1`’ depending on the value of `CF` (previously the upper bit of the number) and continue to loop until we’ve printed 16 digits (because a word has 16 bits). Example of stepping through the code:

<!-- FIXED: "Start:  CF = 16" => "Start:  CX = 16" -->
``` nohighlight
Start:  CX = 16, BX = 1100101000001011b
Pass1:  CX = 15, BX = 1001010000010110b, CF = 1
Pass2:  CX = 14, BX = 0010100000101100b, CF = 1
Pass3:  CX = 13, BX = 0101000001011000b, CF = 0
...
Pass14: CX =  2, BX = 1100000000000000b, CF = 0
Pass15: CX =  1, BX = 1000000000000000b, CF = 1
Pass16: CX =  0, BX = 0000000000000000b, CF = 1
```

In my opinion, if you made it up to this point, having (generally) understood everything, you can consider yourself more than just a beginner — congratulations!!! There is still much to learn to become a well-armed assembly programmer, but now you have a solid grounding from which to start expanding your knowledge – with or without use of this tutorial. (But there are several parts which will be explained in further detail, which are hard to find in any tutorial).
