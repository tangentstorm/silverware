Program Elmer;
Uses Graph, BGIFont, BGIDriv, Crt;
{Le Cartoon Thingie}

Function EnterPressed : Boolean;
 Begin
   Enterpressed := Keypressed AND (Readkey = #13);
 End;

Procedure InitGraphics;
 Var
   Gd, Gm : Integer;
 Begin
   Gd := Detect;
   InitGraph(Gd,Gm,'C:\TP\BGI');
   SetTextStyle(SmallFont,HorizDir,4);
   OutTextXY(2, 1,'Elmer''s Walk ][ ( The Return )');
   OutTextXY(2,11,'(c) 1992 MJW');
 End;

Procedure MakeFrame1;
  Begin
    SetColor(7); Rectangle(50,50,200,200);
    SetColor(0);
    SetFillStyle(SolidFill,LightBlue);
    FillEllipse( 120, 85, 25,25);   { head }
    SetFillStyle(SolidFill,White);
    FillEllipse( 140, 80, 5, 5);  { right Eyeball }
    PutPixel(138,80,0); Circle(138,80,1); { right Eye }
    FillEllipse( 130, 80, 5, 5);  { left Eyeball }
    PutPixel(133,80,0); Circle(133,80,1);  {left Eye}
    Ellipse( 130, 95, 180, 360, 5, 5);  { smile }
    SetColor(15); OutTextXY(108,52,'\/\/');
    Line( 120, 110, 120, 150);
  End;

Var
 X,Y : Integer;
 Frame1, Frame2, Frame3, Frame4 : Pointer;

Begin
  InitGraphics;
  MakeFrame1;
  Repeat Until EnterPressed;
End.