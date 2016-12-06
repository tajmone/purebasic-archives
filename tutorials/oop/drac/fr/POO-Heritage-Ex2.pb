; ··············································································
; ··············································································
; ··························· PureBasicPOO Héritage ····························
; ··············································································
; ································· Exemple 2 ··································
; ··············································································
; ··············································································
; by Dräc, (c) Sept 2007.
; ------------------------------------------------------------------------------
; "OOP-Inheritance-Ex2.pb"
; «PureBASIC Archives» release v1.0, December 6, 2016
;
; Minor changes to the original code, by Tristano Ajmone (@tajmone):
;   -- renamed some vars, procedures
;   -- added/changed source comments
;   -- removed English comments
; ------------------------------------------------------------------------------
; Released under Creative Common Attribution (CC BY 4.0) license:
;   -- https://creativecommons.org/licenses/by/4.0/deed.fr
; ------------------------------------------------------------------------------
; original file: "OOP_Inheritance.pb"
;   -- http://drac.site.chez.tiscali.fr/Tutorials Programming PureBasic/indexTutorials.htm#POO 
; ==============================================================================
;                                  DESCRIPTION                                  
; ==============================================================================
; Cet exemple montre comment une Classe concrète ('Rect1') hérite d’une Classe
; abstraite ('Shape'). 
; Elle montre aussi comment accéder aux attributs d’un objet: soit par des méthodes,
; soit par accès « intégré ».
; ------------------------------------------------------------------------------

XIncludeFile "POO.pbi"

;=====================================================
; Abstract Class Shape
;
;=====================================================
Class(Shape)
  Draw() 
  Cut() 
  Get_var1()                ; <-- Class abstraite: la méthode Get_var1() n’est pas impémentée par la classe Shape
  Get_var2()
  Methods(Shape)
    *Draw
    *Cut
    *Get_var1
    *Get_var2
  Members(Shape)
    var1.l 
    var2.l
EndClass(Shape)

Method(Shape, Draw))
  Debug "Draw from Shape Class" 
EndMethod(Shape, Draw)

Method(Shape, Cut))
  Debug "Cut from Shape Class" 
EndMethod(Shape, Cut)

Method(Shape, Get_var2))
  With *this
    ProcedureReturn \var2 
  EndWith
EndMethod(Shape, Get_var2)

New(Shape) 
  With *this
    \var1= *input\var1 
    \var2= *input\var2
  EndWith
EndNew

; New(Shape)                ; <-- Class abstraite: les constructeur New et Free ne sont pas nécéssaires
; Free(Shape)
; EndFree

; ---------------------------------- 

;=====================================================
; Concrete Class Rect1
;
;=====================================================
ClassEx(Rect1,Shape)        ; <-- Héritage
  Erase() 
  Get_var4()
MethodsEx(Rect1,Shape)      ; <-- Héritage
    *Erase
    *Get_var4
MembersEx(Rect1,Shape)      ; <-- Héritage
    var3.l 
    var4.l 
    rectname.s
EndClass(Rect1)

Method(Rect1, Draw))        ; <-- Polymorphisme: la classe Rect1 implémente sa propre méthode Draw()
  Debug "Draw from Rect Class: " + *this\rectname 
EndMethod(Rect1, Draw)

Method(Rect1, Erase))
  Debug "Erase from Rect Class: " + *this\rectname
EndMethod(Rect1, Erase)

Method(Rect1, Get_var1))    ; <-- Class concrète: toute les méthodes de la classe Rect1 sont implémentées
  With *this
    ProcedureReturn \var1 
  EndWith
EndMethod(Rect1, Get_var1)

Method(Rect1, Get_var4))
  With *this
    ProcedureReturn \var4 
  EndWith
EndMethod(Rect1, Get_var4)

NewEx(Rect1,Shape)          ; <-- Class concrète: le constructeur et le destructeur de la classe existent
  With *this
    \var4= *input\var4 
    \rectname= *input\rectname
  EndWith
EndNew

Free(Rect1)
EndFree

; ---------------------------------- 

input.Mbrs_Rect1
With input
  \var1=1
  \var2=2
  \var4=6
  \rectname="RectA"
EndWith
*RectA.Rect1 = New_Rect1(input)

With input
  \var1=3
  \var2=4
  \var4=7
  \rectname="RectB"
EndWith
*RectB.Rect1 = New_Rect1(input)

Debug ">> Method Test" 

*RectA\Md\Draw() 
*RectA\Md\Cut() 
*RectA\Md\Erase() 

*RectB\Md\Draw() 

Debug"" 
Debug ">> Access Test"

Debug""
Debug " <var1> de "+*RectA\Mb\rectname
Debug *RectA\Mb\var1 
Debug *RectA\Md\Get_var1() 
Debug " <var4> de "+*RectA\Mb\rectname
Debug *RectA\Mb\var4 
Debug *RectA\Md\Get_var4() 

Debug""
Debug " <var1> de "+*RectB\Mb\rectname  
Debug *RectB\Mb\var1 
Debug *RectB\Md\Get_var1() 
Debug " <var4> de "+*RectB\Mb\rectname 
Debug *RectB\Mb\var4 
Debug *RectB\Md\Get_var4()  

Debug"" 
Debug ">> Destruction Test" 
Free_Rect1(*RectA) 
Free_Rect1(*RectB) 

;*Rect1\Md\Draw()           ; --> Impossible car l’objet Rect n’existe plus!
