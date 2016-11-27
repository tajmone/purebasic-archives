IncludeFile #PB_Compiler_File + "i" ;- PBHGEN

; This is weird
Procedure NormalEmptyProcedure()
  ; Hello World
  
  ProcedureReturn 0
EndProcedure

;Procedure HehThisIsAComment()

;EndProcedure

Procedure WithOptionalArguments(heh.l, Something$="Procedure WithOptionalArguments(Something$)" + "lol")
  MultiLine(0,0,0,0)
EndProcedure

ProcedureC StructureThing(*Hello.SYSTEM_INFO, *Okay.SYSTEM_ALARM_ACE)
  
EndProcedure

Procedure ArrayThing(Array HelloWorld.SYSTEM_INFO(1))
  
EndProcedure

Procedure BracketStuff(String$ = "heh" + Chr(50), Okay.l = 50)
  
EndProcedure

DeclareModule EmptyModuleWithoutProcedures
  
EndDeclareModule

Module EmptyModuleWithoutProcedures
  
EndModule

Procedure.i MultiLine(   _nbNiveaux.u,
                           numNiveauDepart.u,
                          _nbViesDepart.a,
                       _IAGlobale.b = 0)

  ; etc...

EndProcedure

Macro FUNNY1
  Procedure This#Macro#Functon1()
    
  EndProcedure
  Procedure This#Macro#Functon2()
    
  EndProcedure;COMMENT
EndMacro
Macro FUNNY2() : Procedure God#No!() : Debug "heh" : EndProcedure : EndMacro

Runtime Procedure RuntimeProc(lol.l)
  
EndProcedure

    ProcedureDLL DLLProcedure()
  
  : EndProcedure ; comment

ProcedureCDLL CDLLProcedure()
  
EndProcedure

Procedure A() : PeekS(*lol) : EndProcedure : ;Procedure B() : PeekA(*pff) : EndProcedure
Procedure C() : PeekS(*lol) : EndProcedure : Procedure D() : PeekA(*pff) : EndProcedure

DeclareModule TestA
  Global String$
  Declare Func1()
EndDeclareModule

Module TestA
  IncludeFile #PB_Compiler_File + "i" ;- PBHGEN
  
  Global String$ = ""
  
  Procedure Func1()
    Debug #PB_Compiler_Module
    Func2()
  EndProcedure
  
  Macro FUNNY3() : Procedure God#Yes!() : Debug "cwap" : EndProcedure : EndMacro
  
  Procedure Func2()
    TestA::String$ = "OL"
    Debug TestA::String$
    TestA::Func1()
  EndProcedure
  
  Procedure A() : PeekS(*lol) : EndProcedure : ;Procedure B() : PeekA(*pff) : EndProcedure
EndModule;COMMENT

DeclareModule TestB
  Declare FuncHurrDurr(Cheese$ = "I love sandwhiche~")
EndDeclareModule

Module TestB
  IncludeFile #PB_Compiler_File + "i" ;- PBHGEN
  
  Procedure FuncHurrDurr(Cheese$ = "I love sandwhiche~")
    
  EndProcedure
EndModule
; IDE Options = PureBasic 5.42 LTS (Windows - x86)
; CursorPosition = 27
; Folding = -----
; EnableXP