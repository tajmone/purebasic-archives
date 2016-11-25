;=====================================================
; OOP_Heritage.pb
;
; Cet exemple montre comment une Classe concrète (Rect1)
; hérite d'une Classe abstraite (Form) 
; Elle montre aussi comment accéder aux attributs d'un
; objet: soit par des méthodes, soit par accès 'intégré'. 
; 
; This example shows how a concrete Class (Rect1)
; inherits from an abstract Class (Form) 
; It shows also how to access to object attributes:
; either by Methods or by 'embedded' accessor.
;
; Dräc - Sept 2007
; [http://drac.site.chez.tiscali.fr/Tutorials Programming PureBasic/indexTutorials.htm#POO]
;=====================================================
XIncludeFile "OOP.pbi"

;=====================================================
;Abstract Class Form
;
;=====================================================
Class(Form)
  Draw() 
  Cut() 
  Get_var1() ; <-- Class abstraite: la méthode Get_var1() n'est pas impémentée par la classe Form
  Get_var2() ;     Abstract class : the Get_var1() method is not implemented into Form Class
Methods(Form)
  *Draw
  *Cut
  *Get_var1
  *Get_var2
Members(Form)
  var1.l 
  var2.l
EndClass(Form)

Method(Form, Draw))
    Debug "Draw from Form Class" 
EndMethod(Form, Draw)

Method(Form, Cut))
    Debug "Cut from Form Class" 
EndMethod(Form, Cut)

Method(Form, Get_var2))
  With *this
    ProcedureReturn \var2 
  EndWith
EndMethod(Form, Get_var2)

New(Form) 
  With *this
    \var1= *input\var1 
    \var2= *input\var2
  EndWith
EndNew

; New(Form); <-- Class abstraite: les constructeur New et Free ne sont pas nécéssaires
;                Abstract class : New ans Free constructors are not required
; Free(Form)
; EndFree

; ---------------------------------- 

;=====================================================
;Concrete Class Rect1
;
;=====================================================
ClassEx(Rect1,Form); <-- Héritage/Inheritance
  Erase() 
  Get_var4()
MethodsEx(Rect1,Form); <-- Héritage/Inheritance
  *Erase
  *Get_var4
MembersEx(Rect1,Form); <-- Héritage/Inheritance
  var3.l 
  var4.l 
  rectname.s
EndClass(Rect1)

Method(Rect1, Draw)); <-- Polymorphisme: la classe Rect1 implémente sa propre méthode Draw()
                    ;     Polymorphism : Rect1 Class implement its own Draw() method
    Debug "Draw from Rect Class: " + *this\rectname 
EndMethod(Rect1, Draw)

Method(Rect1, Erase))
    Debug "Erase from Rect Class: " + *this\rectname
EndMethod(Rect1, Erase)

Method(Rect1, Get_var1)); <-- Class concrète: toute les méthodes de la classe Rect1 sont implémentées
                        ;     Concrete class : all the methods of the Rect1 Class are implemented
  With *this
    ProcedureReturn \var1 
  EndWith
EndMethod(Rect1, Get_var1)

Method(Rect1, Get_var4))
  With *this
    ProcedureReturn \var4 
  EndWith
EndMethod(Rect1, Get_var4)

NewEx(Rect1,Form); <-- Class concrète: le constructeur et le destructeur de la classe existent
  With *this     ;     Concrete class : constructor and destructor exist
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

;*Rect1\Md\Draw(); --> Impossible car l'objet Rect n'existe plus! / Impossible to do because Rect object doesn't exist anymore! 
