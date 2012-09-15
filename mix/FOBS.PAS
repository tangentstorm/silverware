program fobs; { fun bobs }

uses bgistuff, graph, crtstuff, crt, math;

var
  step : shortint;
 an, tl,px,py,pz,pd : integer;
 ang : real;
   CenterX, CenterY   : Integer;
   Angl, Tilt          : Integer;
   CosA, SinA         : Real;
   CosB, SinB         : Real;
   CosACosB, SinASinB : Real;
   CosASinB, SinACosB : Real;
   PerspectivePlot : Boolean;
   Mx, My, Mz, ds : Real;

  Procedure InitPlotting( Ang, Tlt : Integer );
    Begin
      CenterX := getmaxx Div 2;
      CenterY := getmaxy Div 2;
      Angl := Ang;
      Tilt := Tlt;
        { View Direction is Angle around and Tilt off the Z axis }
      CosA := CosD( Angl );
      SinA := SinD( Angl );
      CosB := CosD( Tilt );
      SinB := SinD( Tilt );
      CosACosB := CosA * CosB;
      SinASinB := SinA * SinB;
      CosASinB := CosA * SinB;
      SinACosB := SinA * CosB;
    End;

  Procedure InitPerspective( Perspective : Boolean; x, y, z, m : real );
    Begin
      PerspectivePlot := Perspective;
      Mx := x;
      My := y;
      Mz := z;
      ds := m;
    End;

  function round( x : real ) : longint;
   begin
    if
     (abs(x) > maxlongint)
    then
     if
      x > 0 then
       round := maxlongint
     else
      round := -maxlongint
    else
     round := system.round( x );
   end;

  Procedure MapCoordinates( X, Y, Z : Real; Var Xp, Yp : Integer );
    Var
      Xt, Yt, Zt : Real;
    Begin
      Xt := ( Mx + X * CosA - Y * SinA );
      Yt := ( My + X * SinASinB + Y * CosASinB + Z * CosB );
      If PerspectivePlot Then
        Begin
          Zt := Mz + X * SinACosB + Y * CosACosB - Z * SinB;
          Xp := CenterX + Round( ds * Xt / Zt );
          Yp := CenterY - Round( ds * Yt / Zt );
        End
      Else
        Begin
          Xp := CenterX + Round( Xt );
          Yp := CenterY - Round( Yt );
        End;
    End;

var
 u, v, x, y, z : real;
 w, sx, sy : integer;
 t : integer;

begin
 initgrafx;
 ctextxy( 1, 1, '|RFobs |wby |b[|B[|WS|Ca|WBR|Ce|WN|B]|b]');
{ an := 30;
 tl := 120;
 px := 2;
 py := 5;
 pz := -1;
 pd := 0; }
 initplotting( an, tl );
{ initperspective( on, px, py, pz, pd );}
w := 0;
 u := -8; repeat
  v := 0; repeat
   v := v + 0.1;
   w := w + 1;
   x :=  15*( u * cos( v ) );
   y :=  15*( u * sin( v ) );
   z :=  15*( v * cos( u ) );
{   mapcoordinates( x, y, z, sx, sy );}
setcolor( 0 );
setfillstyle( 1, (w mod 2) * 8 +7 );
t := 180;
fillellipse( centerx+round(x * cos(t) + y * sin(t)),
              centery+round( -x * sin(t) + y * cos( t) * sin(t) + z* cos(t)),
               12, 12 );
  until keypressed or (v >= 12.56);
  u := u + 0.15;
 until keypressed or (u >= 16);
 getenter;
 closegraph;
end.