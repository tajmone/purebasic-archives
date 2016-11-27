;- PBHGEN V5.42 [http://00laboratories.com/]
;- 'Entry.pb' header, generated at 19:25:09 26.11.2016.

CompilerIf #PB_Compiler_Module = ""
Declare ExplodeStringArray(Array a$(1), s$, delimeter$)
Declare.s FilterArguments(Line$)
Declare WriteHeader(Str$)
Declare IsComment(Line$)
Declare IsEmpty(Line$)
Declare IsBeginProcedure(Line$)
Declare IsEndProcedure(Line$)
Declare IsBeginModule(Line$)
Declare IsEndModule(Line$)
Declare IsBeginMacro(Line$)
Declare IsEndMacro(Line$)
Declare.s ParseProcedure(Line$)
Declare.s ParseModuleName(Line$)
Declare ParseLine(Line$)
CompilerEndIf