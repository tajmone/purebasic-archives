; ··············································································
; ··············································································
; ························ OOP Inheritance in PureBASIC ························
; ··············································································
; ································· Example 1 ··································
; ··············································································
; ··············································································
; by Dräc, (c) 2005.
; ------------------------------------------------------------------------------
; "OOP-Inheritance-Ex1.pb"
; «PureBASIC Archives» release v1.0, January 9, 2016.
;
; Minor changes to the original code, by Tristano Ajmone (@tajmone):
;   -- renamed some vars, procedures
;   -- added/changed source comments
;   -- removed French comments
; ------------------------------------------------------------------------------
; Released under Creative Common Attribution (CC BY 4.0) license:
;   -- https://creativecommons.org/licenses/by/4.0/
; ------------------------------------------------------------------------------
; original file: "POO_Heritage.pb"
;   -- http://drac.site.chez.tiscali.fr/Tutorials Programming PureBasic/indexTutorials.htm#POO 
; ==============================================================================
;                                  DESCRIPTION                                  
; ==============================================================================
; This example shows how a concrete Class ('Rect1') inherits from an abstract
; Class ('Form').
; It also shows how to access an object’s attributes: either by Methods, or by a
; pointer on the object. 
; ------------------------------------------------------------------------------
; Cet exemple montre comment une Classe concrète (Rect1) hérite d'une Classe abstraite (Form) 
; Elle montre aussi comment accéder aux attributs d'un objet: soit par des méthodes, soit par un pointeur sur l'objet. 

Interface Form 
  Draw() 
  Cut() 
  Get_var1() 
  Get_var2() 
EndInterface 

Structure Form_ 
  *Methods
  var1.l 
  var2.l 
EndStructure 

Procedure Draw_Form(*this.Form_) 
  Debug "Draw from Form Class" 
EndProcedure 

Procedure Cut_Form(*this.Form_) 
  Debug "Cut from Form Class" 
EndProcedure 

Procedure Get_var2_Form(*this.Form_) 
  ProcedureReturn *this\var2 
EndProcedure 

Structure Mthds_Form 
  *Draw
  *Cut
  *Get_var1
  *Get_var2
EndStructure 

Procedure Init_Mthds_Form(*Mthds.Mthds_Form) 
  *Mthds\Draw=@Draw_Form() 
  *Mthds\Cut=@Cut_Form() 
  *Mthds\Get_var2=@Get_var2_Form() 
EndProcedure 

Mthds_Form.Mthds_Form 

Init_Mthds_Form(@Mthds_Form) 

; Ici la méthode Get_var1() n'est pas implémentée: la Classe Form est une Classe Abstraite 
; On n'a donc pas besoin de déclarer de Constructeur ni de Destructeur de cette Classe 
; Here the method Get_var1() is not implemented: the Class Form is an Abstract Class 
; Thus we don't need to declare a Constructor or a Destructor of this Class 

Procedure Init_Mbers_Form(*this.Form_, var1.l, var2.l) 
  *this\var1=var1 
  *this\var2=var2 
EndProcedure  

Procedure.l New_Form(var1.l, var2.l) 
  Shared Mthds_Form 
  *this.Form_ = AllocateMemory(SizeOf(Form_)) 
  *this\Methods=@Mthds_Form 
  Init_Mbers_Form(*this, var1, var2) 
  ProcedureReturn *this 
EndProcedure 

Procedure Free_Form(*this) 
  FreeMemory(*this) 
EndProcedure 

; ---------------------------------- 

Interface Rect1 Extends Form 
  Erase() 
  Get_var4() 
EndInterface 

Structure Rect1_ Extends Form_ 
  var3.l 
  var4.l 
  rectname.s 
EndStructure 

Procedure Draw_Rect1(*this.Rect1_) 
  Debug "Draw from Rect Class: " + *this\rectname 
EndProcedure 

Procedure Erase_Rect1(*this.Rect1_) 
  Debug "Erase from Rect Class: " + *this\rectname
EndProcedure 

Procedure Get_var1_Rect1(*this.Rect1_) 
  ProcedureReturn *this\var1 
EndProcedure 

Procedure Get_var4_Rect1(*this.Rect1_) 
  ProcedureReturn *this\var4 
EndProcedure 

Structure Mthds_Rect1 Extends Mthds_Form 
  *Erase
  *Get_var4
EndStructure 

Procedure Init_Mthds_Rect1(*Mthds.Mthds_Rect1) 
  Init_Mthds_Form(*Mthds)
  *Mthds\Draw=@Draw_Rect1() 
  *Mthds\Erase=@Erase_Rect1() 
  *Mthds\Get_var1=@Get_var1_Rect1(); La Classe concrète Rect1 se charge de donner l'implémentation de Get_var1() 
  *Mthds\Get_var4=@Get_var4_Rect1(); The concrete Class Rect1 takes care to give the implementation of Get_var1() method 
EndProcedure 

Mthds_Rect1.Mthds_Rect1 

Init_Mthds_Rect1(@Mthds_Rect1) 

Procedure Init_Mbers_Rect1(*this.Rect1_, var1.l, var2.l, var4.l, name.s) 
  Init_Mbers_Form(*this, var1,var2)
  *this\var4=var4 
  *this\rectname=name 
EndProcedure  

Procedure.l New_Rect1(var1.l, var2.l, var4.l, name.s) 
  Shared Mthds_Rect1 
  *this.Rect1_ = AllocateMemory(SizeOf(Rect1_)) 
  *this\Methods=@Mthds_Rect1 
  Init_Mbers_Rect1(*this, var1, var2, var4, name) 
  ProcedureReturn *this 
EndProcedure 

Procedure Free_Rect1(*this) 
  FreeMemory(*this) 
EndProcedure 

; ---------------------------------- 

RectA.Rect1 = New_Rect1(1, 2, 6, "RectA") 
RectB.Rect1 = New_Rect1(3, 4, 7, "RectB") 

Debug ">> Method Test" 

RectA\Draw() 
RectA\Cut() 
RectA\Erase() 

RectB\Draw() 

Debug"" 
Debug ">> Access Test"

Debug""
*Rect.Rect1_= RectA
Debug " <var1> de "+*Rect\rectname  
Debug *Rect\var1 
Debug RectA\Get_var1()
Debug " <var4> de "+*Rect\rectname
Debug *Rect\var4 
Debug RectA\Get_var4() 

Debug""
*Rect.Rect1_= RectB
Debug " <var1> de "+*Rect\rectname  
Debug *Rect\var1 
Debug RectB\Get_var1() 
Debug " <var4> de "+*Rect\rectname 
Debug *Rect\var4 
Debug RectB\Get_var4()

Debug"" 
Debug ">> Destruction Test" 
Free_Rect1(RectA) 
Free_Rect1(RectB) 

;Rect\Draw(); --> Impossible car l'objet Rect n'existe plus! / Impossible to do because Rect object doesn't exist anymore! 

