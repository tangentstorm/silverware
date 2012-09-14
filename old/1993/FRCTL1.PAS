Program Fractal_1;
uses
  CrtStuff,Graph,Crt,BGIDriv,BGIFont;
var
  Gd, Gm : Integer;
  Col : byte;

Function Colr(g : byte) : Byte;
  Begin
    Case g of
      1,8  : Col := Red;
      2,9  : Col := LightRed;
      3,10 : Col := Yellow;
      4,11 : Col := LightGreen;
      5,12 : Col := LightBlue;
      6,13 : Col := LightMagenta;
      7,14 : Col := Magenta;
    end;
    Colr := Col;
  end;

Procedure Doit(CenX,CenY,R : Integer; g : byte);
 var
   c,r2,m : byte;
 begin
   R2 := R-1;     {alternate radius value}
   m := 2;          {minimum  radius value, must be 1,2,4,8,16,32,or 64}
   c := colr(g);
   Sound(G + Random(10000) + 1000);  {sound effect stuff}
   If (R div 2) >= m then
     begin
       If CenY - R div 2 >= 0
          then Doit(CenX,CenY-R-(r div 2),r div 2,g+1);
       If CenX + R div 2 <= GetMaxX
          then Doit(CenX+R+(R div 2), CenY, R div 2,G+1);
       If CenY + R div 2 <= GetMaxY
          then Doit(CenX,CenY+R+(r div 2),r div 2,g+1);
       If CenX - R div 2 >= 0
          then Doit(CenX-R-(R div 2), CenY, R div 2,G+1);
     end;
   SetColor(c);
   SetFillStyle(1,c);
   Bar(CenX-R2,CenY-R2,CenX+R2,CenY+R2);
   Delay(2);
     Nosound;
 end;

begin
  Col := 13;
  Gd := Detect; InitGraph(Gd, Gm, 'C:\TP\BGI');
  if GraphResult <> grOk then Halt(1);
  ClearDevice;
  SetFillStyle(WideDotFill,DarkGray);     {background}
  Bar(0,0,GetMaxX,GetMaxY);
  SetColor(White);                  {Text Color}
  SetTextStyle(SmallFont,HorizDir,5);
  OutTextXY(1, 0, 'Fractal Box Thing');
  OutTextXY(1,15, '(c) 1992 MJW');
  DoIt(GetMaxX div 2, GetMaxY div 2, 128, 1); {CenX,CenY,Radius,Generation}
   {generation can be 1-7. Used for Colors}
  GetEnter;
  CloseGraph;
end.
