PBHGEN – PureBasic Header Generator
===================================

Will read a [PureBasic](http://www.purebasic.com/) source file (`*.pb`) and generate a header out of it (`*.pbi`). `Declare` statements are automatically generated for every procedure.

This program also works with [SpiderBasic](https://www.spiderbasic.com/).

### Useful Links

-   [Project HomePage](http://00laboratories.com/downloads/dl-pbhgen/)

-   [Precompiled Binary for PureBasic 5.42](http://00laboratories.com/download_file/6)

-   [Precompiled Binary for PureBasic 5.42 - mirror](https://dl.dropboxusercontent.com/u/19541374/00laboratories/downloads/PBHGEN/PBHGEN.7z)

-   [Official PureBasic Thread](http://www.purebasic.fr/english/viewtopic.php?f=27&t=53414)

### Usage Instructions

Under “**Tools**” in the PureBasic IDE add a new tool called “`PBHGEN`”:

-   At **Commandline** select your copy of `PBHGEN.exe`.
-   At **Arguments** type `%FILE`.
-   At **Event to trigger the tool** select “**Sourcecode Saved**”.

Ensure you include your headers in the Source using:

``` {.purebasic}
IncludeFile #PB_Compiler_File + "i" ;- PBHGEN
```

To use automatic header generation also in modules use:

``` {.purebasic}
Module MyModule
  IncludeFile #PB_Compiler_File + ".i" ;- PBHGEN
EndModule
```

### Remarks

At the moment if you wish to have a procedure with structured List/Array/Map arguments, you will have to put that procedure above the code where you call it from. This does not apply when using basic types and is a limitation of PureBasic.

### Motivation

PureBasic is a great language but I was always annoyed about the fact I could never choose where I would locate my Procedures, if I wished to use a Procedure somewhere I would have to move it above of the Procedure that was going to call it, the Declare statement allows to tell the compiler specific Procedures are going to exist and to find them but writing them over and over, fixing arguments is not only a pain but makes your source look like a mess. That’s the reason I required an automatic header generator for PureBasic. I hope you too will enjoy the new freedom thanks to this little tool!

### Changes

**V5.42**

-   Added SpiderBasic header generation support.

**V5.31e**

-   Fixed a comment after `EndProcedure` / `EndModule` / `EndMacro` skipping the next procedure declaration.
-   Now ignoring content between `Macro` / `EndMacro` statements.

**V5.31d**

-   Fixed case where the compiler directives failed when a module is declared above global procedures.

**V5.31c**

-   Using compiler directives to remove the need of multiple files for modules.

**V5.31b**

-   Improved parsing engine to comply with latest PureBasic syntax.

-   Optimized header file content and size.

-   Now supports any amount of spaces in front of a procedure.

-   Treats a colon seperator as a new line to allow multiple declarations on a single line.

-   Added support for module header generation (requires additional files and include lines in source code).

**V5.31**

-   Now naming version after PureBasic’s version when possible.

-   Added support for Runtime procedure statements.

-   Added support for case independent keyword detection.

-   Improved `ProcedureDLL` and `ProcedureCDLL` with appropriate `DeclareDLL` and `DeclareCDLL`.

**V0.9**

-   Fixed issue with multiline arguments. Thanks majikeyric for pointing this out.

**V0.8**

-   Fixed issue with a space in the directory/file path of source file.

**V0.7**

-   Stops when encountering the statement seperator “`:`” or comment “`;`” operators.

**V0.6**

-   Fixed issue where array arguments would still have impossible structures.

-   Added support for structured List/Array/Map arguments with some conditions.

-   Added support for all basic types when used with List/Array/Map arguments.

**V0.5**

-   Fixed issue where a `*pointer.structure` had no default parameter.

-   Fixed issue with a string as custom parameter, it was not escaped.

**V0.4**

-   Fixed issue where a `*pointer` would cause further Procedure Parameters to lose their types.

**V0.3**

-   Fixed issue with Structured List/Array/Map in Procedure Parameters.

**V0.2**

-   Fixed issue with Structure Pointers in Procedure Parameters, transforms to Pointers now.

**V0.1**

-   Initial Design

