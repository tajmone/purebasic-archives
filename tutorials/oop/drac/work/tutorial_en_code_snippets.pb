; ··············································································
; ··············································································
; ····························· «OOP demystified» ······························
; ··············································································
; ············· Source- and Pseudo-Code Examples from The Tutorial ·············
; ··············································································
; ··············································································
; Here are the PureBASIC code/pseudo-code examples found in «OOP demystified».
; "Pseudo-code" here are PB Syntax templates with extra characters, not standard
;   PB code.
;
; DON'T auto-Format Indentation on whole document: It would break up correct
;   indentation of some Macros and pseudo-code!
; Apply auto-Format Indentation on selections only. Some blocks will require
;   manual adjustment of indentation because they break-up PB syntax flow (eg:
;   by containing "...".

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 3                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 4.1-1                  Concrete Class and Abstract Class
; ==============================================================================

Structure Rectangle
  *Draw
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Draw_Rectangle(*this.Rectangle)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 4.2-1                          Instanciation 1
; ==============================================================================

Rect1.Rectangle

; ==============================================================================
; 4.2-2                          Instanciation 2
; ==============================================================================

Rect1\Draw = @Draw_Rectangle()
Rect1\x1 = 0
Rect1\x2 = 10
Rect1\y1 = 0
Rect1\y2 = 20

; ==============================================================================
; 4.2-3                          Instanciation 3
; ==============================================================================

CallFunctionFast(Rect1\Draw, @Rect1)

; ==============================================================================
; 4.4-1                           Inheritance 1
; ==============================================================================

Structure Rectangle2 Extends Rectangle
  *Erase
EndStructure

Procedure Erase_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 4.4-2                           Inheritance 2
; ==============================================================================

Rect2.Rectangle2

Rect2\Draw = @Draw_Rectangle()
Rect2\Erase = @Erase_Rectangle()
Rect2\x1 = 0
Rect2\x2 = 10
Rect2\y1 = 0
Rect2\y2 = 20

; ==============================================================================
; 4.5-1                           Overloading 1
; ==============================================================================

Rect1\Draw = @Draw_Rectangle()

; ==============================================================================
; 4.5-2                           Overloading 2
; ==============================================================================

CallFunctionFast(Rect1\Draw, @Rect1)

; ==============================================================================
; 4.5-3                           Overloading 3
; ==============================================================================

Procedure Draw_Rectangle2(*this.Rectangle)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 4.5-4                           Overloading 4
; ==============================================================================

Rect1\Draw = @Draw_Rectangle2()

; ==============================================================================
; 4.5-5                           Overloading 5
; ==============================================================================

CallFunctionFast(Rect1\Draw, @Rect1)

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 4                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 5-1                        Interface instruction 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Interface <Name1> [Extends <Name2>]
  [Procedure1]
  [Procedure2]
  ...
EndInterface

; ==============================================================================
; 5-2                        Interface instruction 2
; ==============================================================================

Interface My_Object
  Procedure1(x1.l, y1.l)
  Procedure2(x2.l, y2.l)
EndInterface

; ==============================================================================
; 5-3                        Interface instruction 3
; ==============================================================================

Object.My_Object

; ==============================================================================
; 5-4                        Interface instruction 4
; ==============================================================================

Object\Procedure1(10, 20)
Object\Procedure2(30, 40)

; ==============================================================================
; 5.1-1                          Initialization 1
; ==============================================================================

Structure My_Methods
  *Procedure1
  *Procedure2
EndStructure

; ==============================================================================
; 5.1-2                          Initialization 2
; ==============================================================================

Methods.My_Methods
Methods\Procedure1 = @My_Procedure1()
Methods\Procedure2 = @My_Procedure2()

; ==============================================================================
; 5.1-3                          Initialization 3
; ==============================================================================

Object.My_Object = @Methods

; ==============================================================================
; 5.1-4                          Initialization 4
; ==============================================================================

Object\Procedure2(30, 40)

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 5                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 6.2-1           Object Instanciation and Object Constructor 1
; ==============================================================================

Structure Rectangle2
  *Draw
  *Erase
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Draw_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

Procedure Erase_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 6.2-2           Object Instanciation and Object Constructor 2
; ==============================================================================

Interface Rectangle
  Draw()
  Erase()
EndInterface

; ==============================================================================
; 6.2-3           Object Instanciation and Object Constructor 3
; ==============================================================================

Rect.Rectangle

; ==============================================================================
; 6.2-4           Object Instanciation and Object Constructor 4
; ==============================================================================

Rect.Rectangle = New_Rect(0, 10, 0, 20)

; ==============================================================================
; 6.2-5           Object Instanciation and Object Constructor 5
; ==============================================================================

Procedure New_Rect(x1.l, x2.l, y1.l, y2.l)
  *Rect.Rectangle2 = AllocateMemory(SizeOf(Rectangle2))

  *Rect \Draw = @Draw_Rectangle()
  *Rect \Erase = @Erase_Rectangle(

  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2

  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.2-6           Object Instanciation and Object Constructor 6
; ==============================================================================

Rect\Draw()
Rect\Erase()

; ==============================================================================
; 6.3-1                      Object Initialization 1
; ==============================================================================

Procedure Init_Mthds_Rect(*Rect.Rectangle2)
  *Rect\Draw = @Draw_Rectangle()
  *Rect\Erase = @Erase_Rectangle()
EndProcedure

Procedure Init_Mbers_Rect(*Rect.Rectangle2, x1.l, x2.l, y1.l, y2.l)
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
EndProcedure

; ==============================================================================
; 6.3-2                      Object Initialization 2
; ==============================================================================

Procedure New_Rect(x1.l, x2.l, y1.l, y2.l)
  *Rect = AllocateMemory(SizeOf(Rectangle2))
  Init_Mthds_Rect(*Rect)
  Init_Mbers_Rect(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.3-3                      Object Initialization 3
; ==============================================================================

Procedure Free_Rect(*Rect)
  FreeMemory(*Rect)
EndProcedure

; ==============================================================================
; 6.3-4                      Object Initialization 4
; ==============================================================================

Free_Rect(Rect2)

; ==============================================================================
; 6.6-1                          Encapsulation 1
; ==============================================================================

Interface Rectangle
  Draw()
EndInterface

; ==============================================================================
; 6.6-2                          Encapsulation 2
; ==============================================================================

Rect.Rectangle = New_Rect()

; ==============================================================================
; 6.6-3                          Encapsulation 3
; ==============================================================================

Procedure Init_Mthds_Rect(*Rect.Rectangle2)
  *Rect\Draw = @Draw_Rectangle()
  *Rect\Erase = @Erase_Rectangle()
EndProcedure

Procedure Init_Mbers_Rect(*Rect.Rectangle2, x1.l, x2.l, y1.l, y2.l)
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
EndProcedure

Procedure New_Rect(x1.l, x2.l, y1.l, y2.l)
  *Rect = AllocateMemory(SizeOf(Rectangle2))
  Init_Mthds_Rect(*Rect)
  Init_Mbers_Rect(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.6-4                          Encapsulation 4
; ==============================================================================

Interface Rectangle
  Erase()
EndInterface

; ==============================================================================
; 6.6-5                          Encapsulation 5
; ==============================================================================

Procedure Init_Mthds_Rect2(*Rect.Rectangle2)
  *Rect\Draw = @Erase_Rectangle()
  *Rect\Erase = @Draw_Rectangle()
EndProcedure

Procedure Init_Mbers_Rect(*Rect.Rectangle2, x1.l, x2.l, y1.l, y2.l)
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
EndProcedure

Procedure New_Rect2(x1.l, x2.l, y1.l, y2.l)
  *Rect = AllocateMemory(SizeOf(Rectangle2))
  Init_Mthds_Rect2(*Rect)
  Init_Mbers_Rect(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.6-6                          Encapsulation 6
; ==============================================================================

Structure Rectangle2
  *Method1
  *Method2
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

; ==============================================================================
; 6.7                             Inheritance 1
; ==============================================================================

; ------------------------------------------------------------------------------
; 6.7-1                             Interface
; ------------------------------------------------------------------------------

Interface Rect1
  Draw()
EndInterface

; ------------------------------------------------------------------------------
; 6.7-2                               Class
; ------------------------------------------------------------------------------

Structure Rectangle1
  *Method1
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Draw_Rectangle(*this.Rectangle1)
  ; [ ...some code... ]
EndProcedure

Procedure Init_Mthds_Rect1(*Rect.Rectangle1)
  *Rect\Method1 = @Draw_Rectangle()
EndProcedure

; ------------------------------------------------------------------------------
; 6.7-3                            Constructor
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Rect1(*Rect.Rectangle1, x1.l, x2.l, y1.l, y2.l)
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
EndProcedure

Procedure New_Rect1(x1.l, x2.l, y1.l, y2.l)
  *Rect = AllocateMemory(SizeOf(Rectangle1))
  Init_Mthds_Rect1(*Rect)
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
;                                 Inheritance 2
; ==============================================================================

; ------------------------------------------------------------------------------
; 6.7-4                             Interface
; ------------------------------------------------------------------------------

Interface Rect2 Extends Rect1
  Erase()
EndInterface

; ------------------------------------------------------------------------------
; 6.7-5                               Class
; ------------------------------------------------------------------------------

Structure Rectangle2 Extends Rectangle1
  *Method2
EndStructure

Procedure Erase_Rectangle(*this.Rectangle1)
  ; [ ...some code... ]
EndProcedure

Procedure Init_Mthds_Rect2(*Rect.Rectangle2)
  Init_Mthds_Rect1(*Rect)
  *Rect\Method2 = @Erase_Rectangle()
EndProcedure

; ------------------------------------------------------------------------------
; 6.7-6                            Constructor
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Rect2(*Rect.Rectangle2, x1.l, x2.l, y1.l, y2.l)
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y2)
EndProcedure

Procedure New_Rect2(x1.l, x2.l, y1.l, y2.l)
  *Rect = AllocateMemory(SizeOf(Rectangle2))
  Init_Mthds_Rect2(*Rect)
  Init_Mbers_Rect2(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.7-7                           Inheritance 3
; ==============================================================================

Structure Rectangle2
  *Method1
  x1.l
  x2.l
  y1.l
  y2.l
  *Method2.l
EndStructure

; ==============================================================================
; 6.7-8                           Inheritance 4
; ==============================================================================

Structure Rectangle2
  *Method1
  *Method2
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

; ==============================================================================
;                                 Inheritance 5
; ==============================================================================

; ------------------------------------------------------------------------------
; 6.7-9                             Interface
; ------------------------------------------------------------------------------

Interface Rect1
  Draw()
EndInterface

; ------------------------------------------------------------------------------
; 6.7-10                              Class
; ------------------------------------------------------------------------------

Structure Rectangle1
  *Methods
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Draw_Rectangle(*this.Rectangle1)
  ; [ ...some code... ]
EndProcedure

Structure Methds_Rect1
  *Method1
EndStructure

Procedure Init_Mthds_Rect1(*Mthds.Mthds_Rect1)
  *Mthds\Method1 = @Draw_Rectangle()
EndProcedure

Mthds_Rect1.Mthds_Rect1
Init_Mthds_Rect1(@Mthds_Rect1)

; ------------------------------------------------------------------------------
; 6.7-11                           Constructor
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Rect1(*Rect.Rectangle1, x1.l, x2.l, y1.l, y2.l)
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
EndProcedure

Procedure New_Rect1(x1.l, x2.l, y1.l, y2.l)
  Shared Mthds_Rect1
  *Rect.Rectangle1 = AllocateMemory(SizeOf(Rectangle1))
  *Rect\Methods = @Mthds_Rect1
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y3)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.7-12                      Inheritance >> Aside 1
; ==============================================================================

Mthds_Rect1.Mthds_Rect1
Init_Mthds_Rect1(@Mthds_Rect1)

; ==============================================================================
; 6.7-13                      Inheritance >> Aside 2
; ==============================================================================

Init_Mthds_Rect1(@Mthds_Rect1.Mthds_Rect1)

; ==============================================================================
;                                 Inheritance 6
; ==============================================================================

; ------------------------------------------------------------------------------
; 6.7-14                            Interface
; ------------------------------------------------------------------------------

Interface Rect2 Extends Rect1
  Erase()
EndInterface

; ------------------------------------------------------------------------------
; 6.7-15                              Class
; ------------------------------------------------------------------------------

Structure Rectangle2 Extends Rectangle1
EndStructure

Procedure Erase_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

Structure Methds_Rect2 Extends Methds_Rect1
  *Method2
EndStructure

Procedure Init_Mthds_Rect2(*Mthds.Mthds_Rect2)
  Init_Mthds_Rect1(*Mthds)
  *Mthds\Method2 = @Erase_Rectangle()
EndProcedure

Mthds_Rect2.Mthds_Rect2
Init_Mthds_Rect2(@Mthds_Rect2)

; ------------------------------------------------------------------------------
; 6.7-16                           Constructor
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Rect2(*Rect.Rectangle2 , x1.l, x2.l, y1.l, y2.l)
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y2)
EndProcedure

Procedure New_Rect2(x1.l, x2.l, y1.l, y2.l)
  Shared Mthds_Rect2
  *Rect.Rectangle2 = AllocateMemory(SizeOf(Rectangle2))
  *Rect\Methods = @Mthds_Rect2
  Init_Mbers_Rect2(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 6.8-1                  Get() and Set() object methods 1
; ==============================================================================

Procedure Get_var2(*this.Rectangle1)
  ProcedureReturn *this\var2
EndProcedure

; ==============================================================================
; 6.8-2                  Get() and Set() object methods 2
; ==============================================================================

Procedure Set_var2(*this.Rectangle1, value)
  *this\var2 = value
EndProcedure

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 6                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
;                             Synthesis and notation
; ==============================================================================

; ------------------------------------------------------------------------------
; 7-1                               Interface
; ------------------------------------------------------------------------------
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Interface <Interface> {Extends <ParentInterface>}
  Method1()
  [Method2()]
  [Method3()]
  ...
EndInterface

; ------------------------------------------------------------------------------
; 7-2                                 Class
; ------------------------------------------------------------------------------
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Structure <Class> {Extends <ParentClass>}
  *Methods
  [Attribute1]
  [Attribute2]
  ...
EndStructure

Procedure Method1(*this.Class, [arg1]...)
  ...
EndProcedure

Procedure Method2(*this.Class, [arg1]...)
  ...
EndProcedure
...

Structure <Mthds_Class> {Extends <Mthds_ParentClass>}
  *Method1
  *Method2
  ...
EndStructure

Procedure Init_Mthds_Class(*Mthds.Mthds_Class)
  {Init_Mthds_ParentClass(*Mthds)}
  *Mthds\Method1 = @Method1()
  *Mthds\Method2 = @Method2()
  ...
EndProcedure

Mthds_Class.Mthds_Class
Init_Mthds_Class(@Mthds_Class)

; ------------------------------------------------------------------------------
; 7-3                              Constructor
; ------------------------------------------------------------------------------
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Class(*this.Class, [var1]...)
  {Init_Mbers_ParentClass(*this)}
  [*this\Attibute1 = var1]
  ...
EndProcedure

Procedure New_Class([var1]...)
  Shared Mthds_Class
  *this.Class = AllocateMemory(SizeOf(Class))
  *this\Methods = @Mthds_Class
  Init_Mbers_Class(*this, [var1]...)
  ProcedureReturn *this
EndProcedure

; ------------------------------------------------------------------------------
; 7-4                               Destructor
; ------------------------------------------------------------------------------

Procedure Free_Class(*this)
  FreeMemory(*this)
EndProcedure

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 7                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 8.1-1                          PureBasic Class
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Object class
Class(<ClassName>)
  [Method1()]
  [Method2()]
  [Method3()]
  ...
  Methods(<ClassName>)
    [<*Method1>]
    [<*Method2>]
    [<*Method3>]
    ...
  Members(<ClassName>)
    [<Attribute1>]
    [<Attribute2>]
    ...
EndClass(<ClassName>)

; Object methods (implementation)
Method(<ClassName>, Method1) [,<variable1 [= DefaultValue]>,...])
  ...
  [ProcedureReturn value]
EndMethod(<ClassName>, Method1)

; ...(ditto For each method)...

; Object constructor
New(<ClassName>)
  ...
EndNew

; Object destructor
Free(<ClassName>)
  ...
EndFree

; ==============================================================================
; 8.2-1                         Class : EndClass 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Object class
Class(<ClassName>)
  [Method1()]
  [Method2()]
  [Method3()]
  ...
  Methods(<ClassName>)
    [<*Method1>]
    [<*Method2>]
    [<*Method3>]
    ...
  Members(<ClassName>)
    [<Attribute1>]
    [<Attribute2>]
    ...
EndClass(<ClassName>)

; ==============================================================================
; 8.2-2                         Class : EndClass 2
; ==============================================================================

Macro Class(ClassName)
  ; Declare the class interface
  Interface ClassName#_
EndMacro

; ==============================================================================
; 8.2-3                         Class : EndClass 3
; ==============================================================================

Macro Methods(ClassName)
  EndInterface
  ; Declare the method-table structure
  Structure Mthds_#ClassName
EndMacro

; ==============================================================================
; 8.2-4                         Class : EndClass 4
; ==============================================================================

Macro Members(ClassName)
  EndStructure
  ; Create the method-table
  Mthds_#ClassName.Mthds_#ClassName
  ; Declare the members
  ; No parent class: implement pointers for the Methods and the instance
  Structure Mbrs_#ClassName
    *Methods
    *Instance.ClassName
EndMacro

; ==============================================================================
; 8.2-5                         Class : EndClass 5
; ==============================================================================

Macro EndClass(ClassName)
  EndStructure

  Structure ClassName
    StructureUnion
      *Md.ClassName#_     ; its methods
      *Mb.Mbrs_#ClassName ; its memebers
    EndStructureUnion
  EndStructure
EndMacro

; ==============================================================================
; 8.2-6                         Class : EndClass 6
; ==============================================================================

*Rect\Md\Draw()

; ==============================================================================
; 8.2-7                         Class : EndClass 7
; ==============================================================================

*Rect\Mb\var1

; ==============================================================================
; 8.2-8                    Class : EndClass | Important
; ==============================================================================

Structure ClassName
  StructureUnion
    *Md.ClassName#_       ; methods
    *Get.Mbrs_#ClassName  ; used to read a member
    *Set.Mbrs_#ClassName  ; used to modify a member
  EndStructureUnion
EndStructure

; ==============================================================================
; 8.3-1                        Method : EndMethod 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Object methods (implementation)
Method(<ClassName>, Method1) [,<variable1 [= DefaultValue]>,...])
  ...
  [ProcedureReturn value]
EndMethod(<ClassName>, Method1)

; ==============================================================================
; 8.3-2                        Method : EndMethod 2
; ==============================================================================

Macro Method(ClassName, Mthd)
  Procedure Mthd#_#ClassName(*this.Mbrs_#ClassName
EndMacro

; ==============================================================================
; 8.3-3                        Method : EndMethod 3
; ==============================================================================

Macro EndMethod(ClassName, Mthd)
  EndProcedure
  ; Save the method’s address into the method-table
  Mthds_#ClassName\Mthd=@Mthd#_#ClassName()
EndMacro

; ==============================================================================
; 8.4-1                        Object Constructor 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Object constructor
New(<ClassName>)
  ...
EndNew


; ==============================================================================
; 8.4-2                        Object Constructor 2
; ==============================================================================

Macro New(ClassName)
  Declare Init_Mbers_#ClassName(*this, *input.Mbrs_#ClassName=0)

  Procedure.l New_#ClassName(*input.Mbrs_#ClassName =0)
    Shared Mthds_#ClassName
    ; Allocate the memory required for the object members
    *this.Mbrs_#ClassName = AllocateMemory(SizeOf(Mbrs_#ClassName))
    ; Attach the method-table to the object
    *this\Methods=@Mthds_#ClassName
    ; The object is created then initialized
    ; Create the object
    *this\Instance= AllocateMemory(SizeOf(ClassName))
    *this\Instance\Md = *this
    ; Now init members
    Init_Mbers_#ClassName(*this, *input)
    ProcedureReturn *this\Instance
  EndProcedure

  Init_Mbers(ClassName)
EndMacro

; ==============================================================================
; 8.4-3                        Object Constructor 3
; ==============================================================================

Macro EndNew
  EndInit_Mbers
EndMacro

; ==============================================================================
; 8.4-4                        Object Constructor 4
; ==============================================================================

New(Rect1)
  *this\var1 = *input\var1
  *this\var2 = *input\var2
  ; [ ...some code... ]
EndNew

; ==============================================================================
; 8.4-5                        Object Constructor 5
; ==============================================================================

input.Mbrs_Rect1
input\var1 = 10
input\var2 = 20

; *Rect is a new object from Rect1 class
*Rect.Rect1 = New_Rect1(input)

; ==============================================================================
; 8.4-6             Init_Mbers : EndInit_Mbers private block 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Attributes initialization
Init_Mbers(<ClassName>)
  ...
EndInit_Mbers

; ==============================================================================
; 8.4-7             Init_Mbers : EndInit_Mbers private block 2
; ==============================================================================

Macro Init_Mbers(ClassName)
  Method(ClassName, Init_Mbers), *input.Mbrs_#ClassName =0)
EndMacro

; ==============================================================================
; 8.4-8             Init_Mbers : EndInit_Mbers private block 3
; ==============================================================================

Init_Mbers(Rect1)
  *this\var1 = *input\var1
  *this\var2 = *input\var2
  ; [ ...some code... ]
EndInit_Mbers

; ==============================================================================
; 8.4-9              Init_Mbers : EndInit_Mbers private block 4
; ==============================================================================

Macro EndInit_Mbers
  EndProcedure
EndMacro

; ==============================================================================
; 8.5-1                        Object destructor 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Object destructor
Free(<ClassName>)
 ...
EndFree

; ==============================================================================
; 8.5-3                        Object destructor 2
; ==============================================================================

Macro Free(ClassName)
  Procedure Free_#ClassName(*Instance.ClassName)
    If *Instance
EndMacro

Macro EndFree
      FreeMemory(*Instance\Md)
      FreeMemory(*Instance)
    EndIf
  EndProcedure
EndMacro

; ==============================================================================
; 8.5-3                        Object destructor 3
; ==============================================================================

Free_Rect1(*Rect)


; ==============================================================================
; 8.6-1                            Inheritance
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Object class
ClassEx(<ClassName>,<ParentClass>)
  [Method1()]
  [Method2()]
  [Method3()]
  ...
  MethodsEx(<ClassName>,<ParentClass>)
    [<*Method1>]
    [<*Method2>]
    [<*Method3>]
    ...
  MembersEx(<ClassName>,<ParentClass>)
    [<Attribute1>]
    [<Attribute2>]
    ...
EndClass(<ClassName>)

; Object methods (implementation)
Method(<ClassName>, Method1) [,<variable1 [= DefaultValue]>,...])
  ...
  [ProcedureReturn value]
EndMethod(<ClassName>, Method1)

; ...(ditto For each method)...

; Object constructor
NewEx(<ClassName>,<ParentClass>)
  ...
EndNew

; Object destructor
Free(<ClassName>)
  ...
EndFree

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 9                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; A.1.1-1                        First solution 1
; ==============================================================================

Rect.Rect = New_Rect()
*Rect.Rectangle1 = Rect

; ==============================================================================
; A.1.1-2                        First solution 2
; ==============================================================================

*Rect\var2

; ==============================================================================
; A.1.2-1                       Second solution 1
; ==============================================================================

Structure Rect_
  StructureUnion
    Mthd.Rect
    *Mbers.Rectangle1
  EndStructureUnion
EndStructure

; ==============================================================================
; A.1.2-2                       Second solution 2
; ==============================================================================

New_Rect(@Rect.Rect_)

; ==============================================================================
; A.1.2-3                       Second solution 3
; ==============================================================================

Procedure New_Rect(*Instance.Rect_)
  *Rect = AllocateMemory(SizeOf(Rectangle2))
  Init_Rect1(*Rect)
  Init_Rect2(*Rect)
  *Instance\Mthd = *Rect
EndProcedure

; ==============================================================================
; A.1.2-4                       Second solution 4
; ==============================================================================

Rect\Mthd\Draw()

; ==============================================================================
; A.1.2-5                       Second solution 5
; ==============================================================================

Rect\Mbers\var2

