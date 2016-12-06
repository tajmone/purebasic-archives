; ··············································································
; ··············································································
; ····························· la POO démystifiée ·····························
; ··············································································
; ············· Source- and Pseudo-Code Examples from The Tutorial ·············
; ··············································································
; ··············································································
; Here are the PureBASIC code/pseudo-code examples found in «la POO démystifiée».
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
; 3.1-1                Classe concrète et Classe abstraite                      
; ==============================================================================

Structure Rectangle
  *Dessiner
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Dessiner_Rectangle(*this.Rectangle)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 3.2-1                          Instanciation 1                                
; ==============================================================================

Rect1.Rectangle

; ==============================================================================
; 3.2-2                          Instanciation 2                                
; ==============================================================================

Rect1\Dessiner = @Dessiner_Rectangle()
Rect1\x1 = 0
Rect1\x2 = 10
Rect1\y1 = 0
Rect1\y2 = 20

; ==============================================================================
; 3.2-3                          Instanciation 3                                
; ==============================================================================

CallFunctionFast(Rect1\Dessiner, @Rect1)

; ==============================================================================
; 3.4-1                             Héritage 1                                  
; ==============================================================================

Structure Rectangle2 Extends Rectangle
  *Effacer
EndStructure

Procedure Effacer_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 3.4-2                             Héritage 2                                  
; ==============================================================================

Rect2.Rectangle2

Rect2\Dessiner = @Dessiner_Rectangle()
Rect2\Effacer = @Effacer_Rectangle()
Rect2\x1 = 0 
Rect2\x2 = 10
Rect2\y1 = 0
Rect2\y2 = 20

; ==============================================================================
; 3.5-1                            Surcharge 1                                  
; ==============================================================================

Rect1\Dessiner = @Dessiner_Rectangle()

; ==============================================================================
; 3.5-2                            Surcharge 2                                  
; ==============================================================================

CallFunctionFast(Rect1\Dessiner, @Rect1)

; ==============================================================================
; 3.5-3                            Surcharge 3                                  
; ==============================================================================

Procedure Dessiner_Rectangle2(*this.Rectangle)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 3.5-4                            Surcharge 4                                  
; ==============================================================================

Rect1\Dessiner = @Dessiner_Rectangle2()

; ==============================================================================
; 3.5-5                            Surcharge 5                                  
; ==============================================================================

CallFunctionFast(Rect1\Dessiner, @Rect1)

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 4                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 4-1                       L’instruction Interface 1                           
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Interface <Nom1> [Extends <Nom2>]
  [Procedure1]
  [Procedure2]
  ...
EndInterface

; ==============================================================================
; 4-2                       L’instruction Interface 2                           
; ==============================================================================

Interface Mon_Objet
  Procedure1(x1.l, y1.l)
  Procedure2(x2.l, y2.l)
EndInterface

; ==============================================================================
; 4-3                       L’instruction Interface 3                           
; ==============================================================================


Objet.Mon_Objet

; ==============================================================================
; 4-4                       L’instruction Interface 4                           
; ==============================================================================

Objet\Procedure1(10, 20)
Objet\Procedure2(30, 40)

; ==============================================================================
; 4.1-1                          Initialisation 1                               
; ==============================================================================

Structure Mes_Methodes
  *Procedure1
  *Procedure2
EndStructure

; ==============================================================================
; 4.1-2                          Initialisation 2                               
; ==============================================================================

Methodes.Mes_Methodes
Methodes\Procedure1 = @Ma_Procedure1()
Methodes\Procedure2 = @Ma_Procedure2()

; ==============================================================================
; 4.1-3                          Initialisation 3                               
; ==============================================================================

Objet.Mon_Objet = @Methodes

; ==============================================================================
; 4.1-4                          Initialisation 4                               
; ==============================================================================

Objet\Procedure2(30, 40)

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 5                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 5.2-1              Instanciation et Constructeur d’Objet 1                    
; ==============================================================================

Structure Rectangle2
  *Dessiner
  *Effacer
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Dessiner_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

Procedure Effacer_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

; ==============================================================================
; 5.2-2              Instanciation et Constructeur d’Objet 2                    
; ==============================================================================

Interface Rectangle
  Dessiner()
  Effacer()
EndInterface

; ==============================================================================
; 5.2-3              Instanciation et Constructeur d’Objet 3                    
; ==============================================================================

Rect.Rectangle

; ==============================================================================
; 5.2-4              Instanciation et Constructeur d’Objet 4                    
; ==============================================================================

Rect.Rectangle = New_Rect(0, 10, 0, 20)

; ==============================================================================
; 5.2-5              Instanciation et Constructeur d’Objet 5                    
; ==============================================================================

Procedure New_Rect(x1.l, x2.l, y1.l, y2.l)
  *Rect.Rectangle2 = AllocateMemory(SizeOf(Rectangle2))
  
  *Rect\Dessiner = @Dessiner_Rectangle()
  *Rect\Effacer = @Effacer_Rectangle()
  
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
  
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 5.2-6              Instanciation et Constructeur d’Objet 6                    
; ==============================================================================

Rect\Dessiner()
Rect\Effacer()

; ==============================================================================
; 5.3-1                      Initialisation d’Objet 1                           
; ==============================================================================

Procedure Init_Mthds_Rect(*Rect.Rectangle2)
  *Rect\Dessiner = @Dessiner_Rectangle()
  *Rect\Effacer = @Effacer_Rectangle()
EndProcedure

Procedure Init_Mbers_Rect(*Rect.Rectangle2, x1.l, x2.l, y1.l, y2.l)
  *Rect\x1 = x1
  *Rect\x2 = x2
  *Rect\y1 = y1
  *Rect\y2 = y2
EndProcedure

; ==============================================================================
; 5.3-2                      Initialisation d’Objet 2                           
; ==============================================================================

Procedure New_Rect(x1.l, x2.l, y1.l, y2.l)
  *Rect = AllocateMemory(SizeOf(Rectangle2))
  Init_Mthds_Rect(*Rect)
  Init_Mbers_Rect(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 5.3-3                      Initialisation d’Objet 3                           
; ==============================================================================

Procedure Free_Rect(*Rect)
  FreeMemory(*Rect)
EndProcedure

; ==============================================================================
; 5.3-4                      Initialisation d’Objet 4                           
; ==============================================================================

Free_Rect(Rect2)

; ==============================================================================
; 5.6-1                          Encapsulation 1
; ==============================================================================

Interface Rectangle
  Dessiner()
EndInterface

; ==============================================================================
; 5.6-2                          Encapsulation 2
; ==============================================================================

Rect.Rectangle = New_Rect()

; ==============================================================================
; 5.6-3                          Encapsulation 3
; ==============================================================================

Procedure Init_Mthds_Rect(*Rect.Rectangle2)
  *Rect\Dessiner = @Dessiner_Rectangle()
  *Rect\Effacer = @Effacer_Rectangle()
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
; 5.6-4                          Encapsulation 4
; ==============================================================================

Interface Rectangle
  Effacer()
EndInterface

; ==============================================================================
; 5.6-5                          Encapsulation 5
; ==============================================================================

Procedure Init_Mthds_Rect2(*Rect.Rectangle2)
  *Rect\Dessiner = @Effacer_Rectangle()
  *Rect\Effacer = @Dessiner_Rectangle()
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
; 5.6-6                          Encapsulation 6
; ==============================================================================

Structure Rectangle2
  *Methode1
  *Methode2
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

; ==============================================================================
; 5.7                               Héritage 1                                  
; ==============================================================================

; ------------------------------------------------------------------------------
; 5.7-1                             Interface
; ------------------------------------------------------------------------------

Interface Rect1
  Dessiner()
EndInterface

; ------------------------------------------------------------------------------
; 5.7-2                               Class
; ------------------------------------------------------------------------------

Structure Rectangle1
  *Methode1
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Dessiner_Rectangle(*this.Rectangle1)
  ; [ ...some code... ]
EndProcedure

Procedure Init_Mthds_Rect1(*Rect.Rectangle1)
  *Rect\Methode1 = @Dessiner_Rectangle() 
EndProcedure

; ------------------------------------------------------------------------------
; 5.7-3                            Constructor
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
;                                   Héritage 2                                  
; ==============================================================================

; ------------------------------------------------------------------------------
; 5.7-4                             Interface
; ------------------------------------------------------------------------------

Interface Rect2 Extends Rect1
  Effacer()
EndInterface

; ------------------------------------------------------------------------------
; 5.7-5                               Class
; ------------------------------------------------------------------------------

Structure Rectangle2 Extends Rectangle1
  *Methode2
EndStructure

Procedure Effacer_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

Procedure Init_Mthds_Rect2(*Rect.Rectangle2)
  Init_Mthds_Rect1(*Rect)
  *Rect\Methode2 = @Effacer_Rectangle()
EndProcedure

; ------------------------------------------------------------------------------
; 5.7-6                            Constructor
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
; 5.7-7                             Héritage 3                                  
; ==============================================================================

Structure Rectangle2
  *Methode1
  x1.l
  x2.l
  y1.l
  y2.l
  *Methode2
EndStructure

; ==============================================================================
; 5.7-8                             Héritage 4                                  
; ==============================================================================

Structure Rectangle2
  *Methode1
  *Methode2
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

; ==============================================================================
;                                   Héritage 5                                  
; ==============================================================================

; ------------------------------------------------------------------------------
; 5.7-9                             Interface
; ------------------------------------------------------------------------------

Interface Rect1
  Dessiner()
EndInterface

; ------------------------------------------------------------------------------
; 5.7-10                              Class
; ------------------------------------------------------------------------------

Structure Rectangle1
  *Methodes
  x1.l
  x2.l
  y1.l
  y2.l
EndStructure

Procedure Dessiner_Rectangle(*this.Rectangle1)
  ; [ ...some code... ]
EndProcedure

Structure Mthds_Rect1
  *Methode1
EndStructure

Procedure Init_Mthds_Rect1(*Mthds.Mthds_Rect1)
  *Mthds\Methode1 = @Dessiner_Rectangle() 
EndProcedure

Mthds_Rect1. Mthds_Rect1
Init_Mthds_Rect1(@Mthds_Rect1)

; ------------------------------------------------------------------------------
; 5.7-11                           Constructor
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
  *Rect\Methodes = @Mthds_Rect1
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y3)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 5.7-12                       Héritage >> Aside 1                              
; ==============================================================================

Mthds_Rect1.Mthds_Rect1
Init_Mthds_Rect1(@Mthds_Rect1)

; ==============================================================================
; 5.7-13                       Héritage >> Aside 2                              
; ==============================================================================

Init_Mthds_Rect1(@Mthds_Rect1.Mthds_Rect1)

; ==============================================================================
;                                   Héritage 6                                  
; ==============================================================================

; ------------------------------------------------------------------------------
; 5.7-14                            Interface
; ------------------------------------------------------------------------------

Interface Rect2 Extends Rect1
  Effacer()
EndInterface

; ------------------------------------------------------------------------------
; 5.7-15                              Class
; ------------------------------------------------------------------------------

Structure Rectangle2 Extends Rectangle1
EndStructure

Procedure Effacer_Rectangle(*this.Rectangle2)
  ; [ ...some code... ]
EndProcedure

Structure Mthds_Rect2 Extends Mthds_Rect1
  *Methode2
EndStructure

Procedure Init_Mthds_Rect2(*Mthds.Mthds_Rect2)
  Init_Mthds_Rect1(*Mthds)
  *Mthds\Methode2 = @Effacer_Rectangle()
EndProcedure

Mthds_Rect2. Mthds_Rect2
Init_Mthds_Rect2(@Mthds_Rect2)

; ------------------------------------------------------------------------------
; 5.7-16                           Constructor
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Rect2(*Rect.Rectangle2 , x1.l, x2.l, y1.l, y2.l)
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y2)
EndProcedure

Procedure New_Rect2(x1.l, x2.l, y1.l, y2.l)
  Shared Mthds_Rect2
  *Rect.Rectangle2 = AllocateMemory(SizeOf(Rectangle2))
  *Rect\Methodes = @Mthds_Rect2
  Init_Mbers_Rect2(*Rect, x1, x2, y1, y2)
  ProcedureReturn *Rect
EndProcedure

; ==============================================================================
; 5.8-1                  Accesseur et Modifieur d’Objet 1                       
; ==============================================================================

Procedure Get_var2(*this.Rectangle1)
  ProcedureReturn *this\var2
EndProcedure

; ==============================================================================
; 5.8-2                  Accesseur et Modifieur d’Objet 2                       
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
;                              Synthèse et notation                             
; ==============================================================================

; ------------------------------------------------------------------------------
; 6-1                               Interface
; ------------------------------------------------------------------------------
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Interface <Interface> {Extends <InterfaceMere>}
  Methode1()
  [Methode2()]
  [Methode3()]
  ...
EndInterface

; ------------------------------------------------------------------------------
; 6-2                                 Classe                                    
; ------------------------------------------------------------------------------
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Structure <Classe> {Extends <ClasseMere>}
  *Methods
  [Attribut1]
  [Attribut2]
  ...
EndStructure

Procedure Methode1(*this.Classe, [arg1]…)
  ...
EndProcedure

Procedure Methode2(*this.Classe, [arg1]…)
  ...
EndProcedure
  ...

Structure <Mthds_Classe> {Extends <Mthds_ClasseMere>}
  *Method1
  *Method2
  ...
EndStructure

Procedure Init_Mthds_Classe(*Mthds.Mthds_Classe)
  {Init_Mthds_ClasseMere(*Mthds)}
  *Mthds\Method1 = @Methode1()
  *Mthds\Method2 = @Methode2()
  ...
EndProcedure

Mthds_Classe.Mthds_Classe
Init_Mthds_Classe(@Mthds_Classe)

; ------------------------------------------------------------------------------
; 6-3                              Constructeur                                 
; ------------------------------------------------------------------------------
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

Procedure Init_Mbers_Classe(*this.Classe, [var1]…)
  {Init_Mbers_ClasseMere(*this)}
  [*this\Attibut1 = var1]
  ...
EndProcedure

Procedure New_Classe([var1]…)
  Shared Mthds_Classe
  *this.Classe = AllocateMemory(SizeOf(Classe))
  *this\Methods = @Mthds_Classe 
  Init_Mbers_Classe(*this, [var1]…)
  ProcedureReturn *this
EndProcedure

; ------------------------------------------------------------------------------
; 6-4                              Destructeur                                  
; ------------------------------------------------------------------------------

Procedure Free_Classe(*this)
  FreeMemory(*this)
EndProcedure

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 7                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; 7.1-1                          Classe PureBasic                               
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

;Classe de l’objet
Class(<ClassName>) 
  [Methode1()]
  [Methode2()]
  [Methode3()]
  ...
  Methods(<ClassName>) 
    [<*Methode1>]
    [<*Methode2>]
    [<*Methode3>]
    ...
  Members(<ClassName>) 
    [<Attribut1>]
    [<Attribut2>]
    ...
EndClass(<ClassName>)

; Méthodes de l’object (implémentation)
  Method(<ClassName>, Method1) [,<variable1 [= DefaultValue]>,...])
  ...
  [ProcedureReturn value]
EndMethod(<ClassName>, Method1) 

; ...(idem pour déclarer chaque methode)

; Constructeur de l’objet
New(<ClassName>)
  ...
EndNew

; Destructeur de l’objet
Free(<ClassName>)
  ...
EndFree

; ==============================================================================
; 7.2-1                         Class : EndClass 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Classe de l’objet
Class(<ClassName>) 
  [Methode1()]
  [Methode2()]
  [Methode3()]
  ...
  Methods(<ClassName>) 
    [<*Methode1>]
    [<*Methode2>]
    [<*Methode3>]
    ...
  Members(<ClassName>) 
    [<Attribut1>]
    [<Attribut2>]
    ...
EndClass(<ClassName>)

; ==============================================================================
; 7.2-2                         Class : EndClass 2
; ==============================================================================

Macro Class(ClassName) 
  ; Declare the class interface
  Interface ClassName#_ 
EndMacro

; ==============================================================================
; 7.2-3                         Class : EndClass 3
; ==============================================================================

Macro Methods(ClassName)
  EndInterface
  ; Declare the method-table structure
  Structure Mthds_#ClassName
EndMacro

; ==============================================================================
; 7.2-4                         Class : EndClass 4
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
; 7.2-5                         Class : EndClass 5
; ==============================================================================

Macro EndClass(ClassName) 
  EndStructure
  
  Structure ClassName
    StructureUnion
      *Md.ClassName#_     ; les méthodes
      *Mb.Mbrs_#ClassName ; les membres
    EndStructureUnion
  EndStructure
EndMacro

; ==============================================================================
; 7.2-6                         Class : EndClass 6
; ==============================================================================

*Rect\Md\Draw()

; ==============================================================================
; 7.2-7                         Class : EndClass 7
; ==============================================================================

*Rect\Mb\var1

; ==============================================================================
; 7.2-8                    Class : EndClass | Important
; ==============================================================================

Structure ClassName
  StructureUnion
    *Md.ClassName#_       ; les méthodes
    *Get.Mbrs_#ClassName  ; utilisé pour lire un membre
    *Set.Mbrs_#ClassName  ; utilisé pour modifier un menbre
  EndStructureUnion
EndStructure

; ==============================================================================
; 7.3-1                        Method : EndMethod 1
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Méthodes de l’object (implémentation)
Method(<ClassName>, Method1) [,<variable1 [= DefaultValue]>,...])
  ...
  [ProcedureReturn value]
EndMethod(<ClassName>, Method1)

; ==============================================================================
; 7.3-2                        Method : EndMethod 2
; ==============================================================================

Macro Method(ClassName, Mthd)
  Procedure Mthd#_#ClassName(*this.Mbrs_#ClassName
EndMacro


; ==============================================================================
; 7.3-3                        Method : EndMethod 3
; ==============================================================================

Macro EndMethod(ClassName, Mthd)
  EndProcedure
  ; Save the method’s address into the method-table
  Mthds_#ClassName\Mthd=@Mthd#_#ClassName()
EndMacro

; ==============================================================================
; 7.4-1                    Le constructeur de l’objet 1                         
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Constructeur de l’objet
New(<ClassName>)
  ...
EndNew

; ==============================================================================
; 7.4-2                    Le constructeur de l’objet 2                         
; ==============================================================================

Macro New(ClassName)
  Declare Init_Mbers_#ClassName(*this, *input.Mbrs_#ClassName=0)

  Procedure.l New_#ClassName(*input.Mbrs_#ClassName =0)
    Shared Mthds_#ClassName
    ; Réserve la place mémoire nécéssaire à l’objet
    *this.Mbrs_#ClassName = AllocateMemory(SizeOf(Mbrs_#ClassName))
    ; Lui attache la table des méthodes
    *this\Methods=@Mthds_#ClassName
    ; L’objet est d’abord crée puis initialisé
    ; Crée l’objet
    *this\Instance= AllocateMemory(SizeOf(ClassName))
    *this\Instance\Md = *this
    ; Inititialise l’objet
    Init_Mbers_#ClassName(*this, *input)
    ProcedureReturn *this\Instance
  EndProcedure

  Init_Mbers(ClassName)
EndMacro

; ==============================================================================
; 7.4-3                    Le constructeur de l’objet 3                         
; ==============================================================================

Macro EndNew
  EndInit_Mbers
EndMacro

; ==============================================================================
; 7.4-4                    Le constructeur de l’objet 4                         
; ==============================================================================

New(Rect1)
  *this\var1 = *input\var1
  *this\var2 = *input\var2
  ; [ ...some code... ]
EndNew

; ==============================================================================
; 7.4-5                    Le constructeur de l’objet 5                         
; ==============================================================================

input.Mbrs_Rect1
input\var1 = 10
input\var2 = 20

; *Rect est un nouvel objet de la classe Rect1
*Rect.Rect1 = New_Rect1(input)

; ==============================================================================
; 7.4-6         L’instruction privée Init_Mbers : EndInit_Mbers 1               
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Initialisation de l’objet
Init_Mbers(<ClassName>)
  ...
EndInit_Mbers

; ==============================================================================
; 7.4-7         L’instruction privée Init_Mbers : EndInit_Mbers 2               
; ==============================================================================

Macro Init_Mbers(ClassName)
  Method(ClassName, Init_Mbers), *input.Mbrs_#ClassName =0)
EndMacro

; ==============================================================================
; 7.4-8         L’instruction privée Init_Mbers : EndInit_Mbers 3               
; ==============================================================================

Init_Mbers(Rect1)
  *this\var1 = *input\var1
  *this\var2 = *input\var2
  ; [ ...some code... ]
EndInit_Mbers

; ==============================================================================
; 7.4-9         L’instruction privée Init_Mbers : EndInit_Mbers 4               
; ==============================================================================

Macro EndInit_Mbers
  EndProcedure
EndMacro

; ==============================================================================
; 7.5-1                      Destructeur de l’objet 1                           
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Destructeur de l’objet
Free(<ClassName>)
 ...
EndFree

; ==============================================================================
; 7.5-2                      Destructeur de l’objet 2                           
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
; 7.5-3                      Destructeur de l’objet 2                           
; ==============================================================================

Free_Rect1(*Rect)

; ==============================================================================
; 8.6-1                              Héritage                                   
; ==============================================================================
;                              PSEUDOCODE - SYNTAX!
; ------------------------------------------------------------------------------

; Classe de l’objet
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

; Méthodes de l’object (implémentation)
Method(<ClassName>, Method1) [,<variable1 [= DefaultValue]>,...])
  ...
  [ProcedureReturn value]
EndMethod(<ClassName>, Method1)

; ...(idem pour déclarer chaque méthode)...

; Constructeur de l’objet
NewEx(<ClassName>,<ParentClass>)
  ...
EndNew

; Destructeur de l’objet
Free(<ClassName>)
  ...
EndFree

; ******************************************************************************
; *                                                                            *
; *                                 WEB PAGE 9                                 *
; *                                                                            *
; ******************************************************************************

; ==============================================================================
; A.1.1-1                      Première Solution 1                              
; ==============================================================================

Rect.Rect = New_Rect()
*Rect.Rectangle1 = Rect

; ==============================================================================
; A.1.1-2                      Première Solution 2                              
; ==============================================================================

*Rect\var2

; ==============================================================================
; A.1.2-1                      Deuxième Solution 1                              
; ==============================================================================

Structure Rect_
  StructureUnion
    Mthd.Rect
    *Mbers.Rectangle1
  EndStructureUnion
EndStructure

; ==============================================================================
; A.1.2-2                      Deuxième Solution 2                              
; ==============================================================================

New_Rect(@Rect.Rect_)

; ==============================================================================
; A.1.2-3                      Deuxième Solution 3                              
; ==============================================================================

Procedure New_Rect1(*Instance.Rect_, x1.l, x2.l, y1.l, y2.l)
  Shared Mthds_Rect1
  *Rect.Rectangle1 = AllocateMemory(SizeOf(Rectangle1))
  *Rect \Methodes = @Mthds_Rect1
  Init_Mbers_Rect1(*Rect, x1, x2, y1, y2)
  *Instance\Mthds = *Rect
EndProcedure

; ==============================================================================
; A.1.2-4                      Deuxième Solution 4                              
; ==============================================================================

Rect\Mthds\Dessiner()

; ==============================================================================
; A.1.2-5                      Deuxième Solution 5                              
; ==============================================================================

Rect\Mbers\var2
