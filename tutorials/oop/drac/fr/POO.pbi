;=======================================================================
; OOP
;
; A set of instructions to equip PureBasic with
; OOP concepts. It is a possible implementation
; allowing basic concepts as:
; - instanciation,
; - encapsulation,
; - simple inheritance,
; - overload,
; - abstract/concret Classes,
; - composition/agregation.
;
; Dräc -  Oct 2007 : * Init_Mbers:EndInit_Mbers block became a private
;                      block of the OOP implementation used by a new
;                      block New:EndNew.
;                    * Externalisation of the header from Method, New &
;                      Free macros for an easy service.
;                    * Additional macros to an easy declaration of
;                      Methods, New and Free (DeclareMethods, DeclareNew
;                      DeclareFree)
; Dräc - Sept 2007 : creation
;=======================================================================

Macro Mtd
*this\Instance\Md
EndMacro

;///////////////////////////////////////////////////////
; OBJECT CLASS
;///////////////////////////////////////////////////////

;-------------------------------- Class --------------------------------
;
; Object class declaration.
;
; Syntax:
;         Class(ClassName)
;           [Mthd1()]
;           [Mthd2()]        <-- Interface declaration
;           ...
;         Methods(ClassName)
;           [<*Mthd1>]
;           [<*Mthd2>]       <-- methods table declaration
;           ...
;         Members(ClassName)
;           [<variable1>]    <-- members declaration
;           ...
;         EndClass(ClassName)
;------------------------------------------------------------------------
Macro Class(ClassName)
  ; Declare the class interface
  Interface ClassName#_ 
EndMacro
Macro Methods(ClassName) 
  EndInterface 
  ;Declare the methods table structure
  Structure Mthds_#ClassName 
EndMacro
Macro Members(ClassName) 
  EndStructure
  ; Create the methods table
  Mthds_#ClassName.Mthds_#ClassName
  ; Declare the members
  ; No mother class: implement pointers for the Methods and the instance
  Structure Mbrs_#ClassName#_
    *Methods
EndMacro 
Macro EndClass(ClassName)
  EndStructure
  Structure Mbrs_#ClassName Extends Mbrs_#ClassName#_
    *Instance.ClassName
  EndStructure
  ; Merges methods and members into an StructureUnion in order to
  ; symetrize their use and to benefit of 'automatic accessors'
  ; Syntax:
  ;         Object\Md\Method() to use method
  ;         Object\Mb\Member to access a member
  Structure ClassName
   StructureUnion
     *Md.ClassName#_     ; The methods
     *Mb.Mbrs_#ClassName ; The menbers
   EndStructureUnion
  EndStructure
EndMacro

;------------------------------- ClassEx -------------------------------
;
; Object class declaration.
; Use when the object inherite from an other class.
;
; Syntax:
;         ClassEx(ClassName, MotherClass)
;           [Mthd1()]
;           [Mthd2()]                       <-- Interface declaration
;           ...
;         MethodsEx(ClassName, MotherClass)
;           [<*Mthd1>]
;           [<*Mthd2>]                      <-- methods table declaration
;           ...
;         MembersEx(ClassName, MotherClass)
;           [<variable1>]                   <-- members declaration
;           ...
;         EndClass(ClassName)
;------------------------------------------------------------------------
Macro ClassEx(ClassName, MotherClass)
  ; Declare the class interface extended from the mother class
  Interface ClassName#_ Extends MotherClass#_
EndMacro
Macro MethodsEx(ClassName, MotherClass) 
  EndInterface
  ;Declare the methods table structure extended from the mother class 
  Structure Mthds_#ClassName Extends Mthds_#MotherClass
EndMacro
Macro MembersEx(ClassName, MotherClass)  
  EndStructure
  ; Create the methods table
  ; and initialize first with the methods from the mother class
  Mthds_#ClassName.Mthds_#ClassName
  CopyMemory(@Mthds_#MotherClass, Mthds_#ClassName, SizeOf(Mthds_#MotherClass))
  ; Declare the members extended from the mother class
  Structure Mbrs_#ClassName#_ Extends Mbrs_#MotherClass#_
EndMacro


;///////////////////////////////////////////////////////
; OBJECT METHODS
;///////////////////////////////////////////////////////
; private macro
Macro MethodHeader(ClassName, Mthd)  ; Header of the Method
  Mthd#_#ClassName(*this.Mbrs_#ClassName 
EndMacro
;-------------------------------- Method --------------------------------
;
; Object method implementation.
;
; Syntax:
;         Method(ClassName, Mthd) [,<variable1 [= DefaultValue]>,...])
;           ...
;           [ProcedureReturn value]
;         EndMethod(ClassName, Mthd)
;------------------------------------------------------------------------

Macro DeclareMethod(ClassName, Mthd) 
  Declare MethodHeader(ClassName, Mthd)
EndMacro

Macro Method(ClassName, Mthd) 
    Procedure MethodHeader(ClassName, Mthd)
EndMacro
Macro EndMethod(ClassName, Mthd)
  EndProcedure
  ; Save the method adress into the methods table
  Mthds_#ClassName\Mthd=@Mthd#_#ClassName()
EndMacro

;///////////////////////////////////////////////////////
; OBJECT INITIALISATION
;///////////////////////////////////////////////////////
; private macros
Macro Declared_Init_Mbers_Arg(ClassName) ; for an easy service of the Init_Mbers argument declared
  *input.Mbrs_#ClassName =0, arg1.l=0, arg2.l=0, arg3.l=0, arg4.l=0, arg5.l=0
EndMacro
Macro Used_Init_Mbers_Arg()              ; for an easy service of the Init_Mbers argument used
  *input, arg1, arg2, arg3, arg4, arg5
EndMacro

;----------------------------- Init_Mbers -------------------------------
;
; Object members initialisation.
; Used by the New method
;
; Syntax:
;         Init_Mbers(ClassName)
;           ...
;         EndInit_Mbers
;------------------------------------------------------------------------
Macro Init_Mbers(ClassName)
  Method(ClassName, Init_Mbers), Declared_Init_Mbers_Arg(ClassName))
EndMacro
Macro EndInit_Mbers()
  EndProcedure
EndMacro

;---------------------------- Init_MbersEx ------------------------------
;
; Object members initialisation.
; Used by the New method when the object inherite from an other class.
;
; Syntax:
;         Init_MbersEx(ClassName, MotherClass)
;           ...
;         EndInit_Mbers
;------------------------------------------------------------------------
Macro Init_MbersEx(ClassName, MotherClass)
  Init_Mbers(ClassName)
  ;Call the object initialisation method of the mother class
  Init_Mbers_#MotherClass(*this, Used_Init_Mbers_Arg())
EndMacro

;///////////////////////////////////////////////////////
; OBJECT CONSTRUCTORS
;///////////////////////////////////////////////////////
; private macro
Macro New_body(ClassName)   ; Commun body of a New method
  Shared Mthds_#ClassName
  ;Allocate the memory required for the object members
  *this.Mbrs_#ClassName = AllocateMemory(SizeOf(Mbrs_#ClassName))
  ;Attach the methods table to the object
  *this\Methods=@Mthds_#ClassName
  ;The object is created than initialised (like this, aggregated/composite objects are available during init)
  ;Create the object
  *this\Instance= AllocateMemory(SizeOf(ClassName))
  *this\Instance\Md = *this
  ;Now init members 
  Init_Mbers_#ClassName(*this, Used_Init_Mbers_Arg())
EndMacro
Macro NewHeader(ClassName)  ; Header of the New method
  New_#ClassName(Declared_Init_Mbers_Arg(ClassName))
EndMacro

Macro FreeHeader(ClassName) ; Header of the Free method
  Free_#ClassName(*Instance.ClassName)
EndMacro

;-------------------------------- New -----------------------------------
;
; Object  constructor.
; Return the adress of the new instance.
;
; INPUT:
; Input data by referent.
;
; Syntax:
;         New(ClassName)
;           ...
;         EndNew
; Use:
;         *Object.ClassName = New_ClassName([*input])
;------------------------------------------------------------------------
Macro DeclareNew(ClassName) ; Used to declare a New method
  Declare NewHeader(ClassName)
EndMacro

Macro New(ClassName)
  DeclareMethod(ClassName, Init_Mbers), Declared_Init_Mbers_Arg(ClassName))
	Procedure.l NewHeader(ClassName)
	  New_body(ClassName)
	  ProcedureReturn *this\Instance  
	EndProcedure
	Init_Mbers(ClassName)
EndMacro
Macro EndNew
  EndInit_Mbers()
EndMacro

;-------------------------------- NewEx -----------------------------------
;
; Object  constructor.
; Return the adress of the new instance.
;
; INPUT:
; Input data by referent.
;
; Syntax:
;         NewEx(ClassName, MotherClass)
;           ...
;         EndNew
;
; Use: (idem than New() method above)
;
;         *Object.ClassName = New_ClassName([*input])
;------------------------------------------------------------------------
Macro NewEx(ClassName, MotherClass)
	DeclareMethod(ClassName, Init_Mbers), Declared_Init_Mbers_Arg(ClassName))
	Procedure.l NewHeader(ClassName)
	  New_body(ClassName)
	  ProcedureReturn *this\Instance  
	EndProcedure
	Init_MbersEx(ClassName, MotherClass)
EndMacro

;------------------------------- Free -----------------------------------
;
; Object destructor.
;
; INPUT:
; Require the object instance.
;
; !! Don't forget to free all aggregated/composite objects here !!
;
; Syntax:
;         Free(ClassName)
;           ...
;         EndFree
;
; Use:
;         Free_ClassName(*Object.ClassName)
;------------------------------------------------------------------------
Macro DeclareFree(ClassName); Used to declare a Free method
  Declare FreeHeader(ClassName)
EndMacro

Macro Free(ClassName)
Procedure FreeHeader(ClassName)
  If *Instance
EndMacro
Macro EndFree
  FreeMemory(*Instance\Md)
  FreeMemory(*Instance)
  EndIf
EndProcedure
EndMacro
