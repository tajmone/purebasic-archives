;=====================================================
; OOP_Heritage.pb
;
; Cet exemple montre comment une Classe concrète (Rect1)
; hérite d'une Classe abstraite (Shape) 
; Elle montre aussi comment accéder aux attributs d'un
; objet: soit par des méthodes, soit par accès 'intégré'. 
; 
; This example shows how a concrete Class (Rect1)
; inherits from an abstract Class (Shape) 
; It shows also how to access to object attributes:
; either by Methods or by 'embedded' accessor.
;
; Dräc - Sept 2007
; [http://drac.site.chez.tiscali.fr/Tutorials Programming PureBasic/indexTutorials.htm#POO]
;=====================================================
XIncludeFile "OOP.pbi"

;=====================================================
; Abstract Class Shape
;
;=====================================================
Class(Shape)
  Draw() 
  Cut() 
  Get_var1()                ; <-- Abstract class : the Get_var1() method is not implemented into Shape Class
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

; New(Shape)                ; <-- Abstract class : New and Free constructors are not required
; Free(Shape)
; EndFree

; ---------------------------------- 

;=====================================================
; Concrete Class Rect1
;
;=====================================================
ClassEx(Rect1, Shape)       ; <-- Inheritance
  Erase() 
  Get_var4()
  MethodsEx(Rect1, Shape)   ; <-- Inheritance
    *Erase
    *Get_var4
  MembersEx(Rect1, Shape)   ; <-- Inheritance
    var3.l 
    var4.l 
    rectname.s
EndClass(Rect1)

Method(Rect1, Draw))        ; <-- Polymorphism : Rect1 Class implement its own Draw() method
  Debug "Draw from Rect Class: " + *this\rectname 
EndMethod(Rect1, Draw)

Method(Rect1, Erase))
  Debug "Erase from Rect Class: " + *this\rectname
EndMethod(Rect1, Erase)

Method(Rect1, Get_var1))    ; <-- Concrete class : all the methods of the Rect1 Class are implemented
  With *this
    ProcedureReturn \var1 
  EndWith
EndMethod(Rect1, Get_var1)

Method(Rect1, Get_var4))
  With *this
    ProcedureReturn \var4 
  EndWith
EndMethod(Rect1, Get_var4)

NewEx(Rect1, Shape)         ; <-- Concrete class : constructor and destructor exist
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
Debug " <var1> of "+*RectA\Mb\rectname
Debug *RectA\Mb\var1 
Debug *RectA\Md\Get_var1() 
Debug " <var4> of "+*RectA\Mb\rectname
Debug *RectA\Mb\var4 
Debug *RectA\Md\Get_var4() 

Debug""
Debug " <var1> of "+*RectB\Mb\rectname  
Debug *RectB\Mb\var1 
Debug *RectB\Md\Get_var1() 
Debug " <var4> of "+*RectB\Mb\rectname 
Debug *RectB\Mb\var4 
Debug *RectB\Md\Get_var4()  

Debug"" 
Debug ">> Destruction Test" 
Free_Rect1(*RectA) 
Free_Rect1(*RectB) 

;*Rect1\Md\Draw()           ; --> Impossible to do because Rect object doesn't exist anymore! 
