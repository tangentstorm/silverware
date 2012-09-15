{$M 28384,0,655360}
uses vgastuff,crtstuff,crt,moustuff,math,sndstuff,sprites;

procedure starship; external;
{$L Starship.obj}

procedure drawship;
 var
  i : integer;
 begin
  for i := 0 to 9 do
   move( mem[ seg(starship):ofs(starship)+800+i*89 ], drawto^[ (i+90)*320+115 ], 89 );
 end;

type
 astar = object
  a, b, x,y,z : integer;
  c : byte;
  big : boolean;
  procedure init;
  procedure setto( x1, y1, z1 : integer; c1 : byte );
  procedure draw;
 end;

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
      CenterX := 320 Div 2;
      CenterY := 200 Div 2;
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


procedure astar.init;
 begin
  x := random( 400 )-200;
  y := random( 400 )-200;
  a := 0;
  b := 0;
  z := random( 400 );
  c := random( 128 ) +30;
  big := false;
 end;

procedure astar.setto( x1, y1, z1 : integer; c1 : byte );
 begin
  x := x1;
  y := y1;
  z := z1;
  c := c1;
 end;

procedure astar.draw;
 begin
  putpixel(a, b, 0 );
   z := z - step;
  if
   (z < 0)
  then z := 200
   else
    if  ( z > 200)
   then z := 0
  else
   if
    z >= 0 then
   begin
    mapcoordinates( x, y, z, a, b );
    if
     (a<0) or (a>320) or (b<0) or (b>200)
    then
     init
    else
     putpixel( a, b, c );
   end;
 end;

const
 maxstar = 50;
var
 ms,i : integer;
 done : boolean;
 star1 : array[ 1 .. maxstar ] of astar;
 spinstep : shortint;

begin
 step := 0;
 an := 180;
 tl := 90;
 px := 0;
 py := 0;
 pz := -1;
 pd := -100;
 initplotting( an, tl );
 initperspective( on, px, py, pz, pd );
 for i := 1 to maxstar do star1[ i ].init;
 setmode( $13 );
 loadcol( '\aa\shades.col');
 mouseon;
 showmouse( off );
 for i := 1 to maxstar do star1[ i ].draw;
 drawto := tempvga;
 repeat
  getmpos;
      if moustuff.mx <> lmx then
       begin
        spinstep := abs( step )+1;
        if moustuff.mx < lmx then
        spinstep := spinstep * -1;
        for i := 1 to maxstar do
         with star1[ i ] do
          x := incwrap( x, spinstep, -200, 200  )
       end;
  if (moustuff.ms and 1 <> 0) then
   begin
    step := 0;
   end
    else
     begin
      if moustuff.my > lmy then step := dec2( step, 2, -30 );
      if moustuff.my < lmy then step := inc2( step, 2, 30 );
     end;
      initplotting( an, tl );
      setmpos( centerx, centery );
     begin
      fillchar( tempvga^, 320*200, 0 );
      for i := 1 to maxstar do star1[ i ].draw;
      drawship;
      vga := tempvga^;
     end;
 until (moustuff.ms and 2 <> 0) or ((keypressed) and (readkey = #27));
 setmode( 0 );
end.