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

