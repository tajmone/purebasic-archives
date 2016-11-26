 --------------------------------------------
  -- PureBasic Header Generator           --
  -- copyright © 00laboratories 2013-2016 --
  -- http://00laboratories.com/           --
 --------------------------------------------

Description:
	Will read a PureBasic source file (*.pb) and generate a header out of it (*.pbi).
	
Usage:
	1. Under "Tools" in the PureBasic IDE add a new tool called "PBHGEN".
	2.	* At Commandline select PBHGEN.exe
		* At Arguments type "%FILE" without the quotes.
		* At Event to trigger the tool select "Sourcecode Saved"
	3. Ensure you include your headers in the Source using:
		IncludeFile #PB_Compiler_File + "i" ;- PBHGEN
	4. To use automatic header generation in modules also use:
		Module MyModule
		  IncludeFile #PB_Compiler_File + "i" ;- PBHGEN
		  ...
		EndModule
		
Important:
	At the moment if you wish to have a procedure with structured List/Array/Map arguments,
	you will have to put that procedure above the code where you call it from.
	This does not apply when using basic types and is a limitation of PureBasic.

Version:
5.42
Added SpiderBasic header generation support.
5.31e
Fixed a comment after EndProcedure / EndModule / EndMacro skipping the next procedure declaration.
Now ignoring content between Macro / EndMacro statements.
5.31d
Fixed case where the compiler directives failed when a module is declared above global procedures.
5.31c
Using compiler directives to remove the need of multiple files for modules.
5.31b
Improved parsing engine to comply with latest PureBasic syntax.
Optimized header file content and size.
Now supports any amount of spaces in front of a procedure.
Treats a colon seperator as a new line to allow multiple declarations on a single line.
Added support for module header generation (requires additional include lines in source code).
5.31
Now naming version after PureBasic's version when possible.
Added support for Runtime procedure statements.
Added support for case independent keyword detection.
Improved ProcedureDLL and ProcedureCDLL with appropriate DeclareDLL and DeclareCDLL.
0.9
Fixed issue with multiline arguments. Thanks majikeyric for pointing this out.
0.8
Fixed issue with a space in the directory/file path of source file.
0.7
Stops when encountering the statement seperator ":" or comment ";" operators.
0.6
Fixed issue where array arguments would still have impossible structures.
Added support for structured List/Array/Map arguments with some conditions.
Added support for all basic types when used with List/Array/Map arguments.
0.5
Fixed issue where a *pointer.structure had no default parameter.
Fixed issue with a string as custom parameter, it was not escaped.
0.4
Fixed issue where a *pointer would cause further Procedure Parameters to lose their types.
0.3:
Fixed issue with Structured List/Array/Map in Procedure Parameters.
0.2:
Fixed issue with Structure Pointers in Procedure Parameters, transforms to Pointers now.
0.1:
Initial Design