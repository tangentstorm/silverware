Program Frac1;

{ Program to Display a Fractal Pattern Based on Squares }
{ (c)1992 MJW }

Uses Crt,Graph,BGIDriv,BGIFont;

Procedure InitGraphics;
 Var
   Gd, Gm : Integer;
 Begin
   Gd := Detect;
   InitGraph(Gd,Gm,'C:\TP\BGI');
   SetFillStyle(WideDotfill,8);
   Bar(0,0,GetMaxX,GetMaxY);
   SetTextStyle(SmallFont,HorizDir,4);
   OutTextXY(2, 1,'Fractal Box Thing');
   OutTextXY(2,11,'(c) 1992 MJW');
 End;

Function Col(G: Byte) : byte;
 Var
   Cl : byte;
 Begin
   Case G of
     1: Cl := Red;
     2: Cl := LightRed;
     3: Cl := Yellow;
     4: Cl := Green;
     5: Cl := LightBlue;
     6: Cl := Blue;
     7: Cl := LightMagenta;
     8: Cl := Magenta;
     9: Cl := White;
   end;
   Col := Cl;
 End;

Procedure DoIt( CenX, CenY : integer; R, g: byte);
 Var
   C : byte;
 Begin
   If R Div 2 >= 1 Then
     Begin
       Doit( CenX, CenY - R - R div 2, R div 2, g + 1);
       Doit( CenX + R + R div 2, CenY, R div 2, g + 1);
       Doit( CenX, CenY + R + R div 2, R div 2, g + 1);
       Doit( CenX - R - R div 2, CenY, R div 2, g + 1);
     End;
   C := Col(g);
   SetFillStyle( SolidFill, C );
   setcolor(c);
   bar( CenX - R + 1, CenY - R+1, CenX + R-1, CenY + R-1 );
 End;

Function EnterPressed : Boolean;
 Begin
   Enterpressed := Keypressed AND (Readkey = #13);
 End;

Begin
  InitGraphics;
  Doit( GetMaxX div 2, GetMaxY div 2, 128, 1);
  Repeat Until EnterPressed;
End.