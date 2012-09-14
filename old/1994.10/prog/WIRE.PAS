program wireroads;

uses vgastuff,crtstuff,crt,moustuff,math,sndstuff,sprites;

type
 platform = object { platform five pixels thick }
  x1, y1, z1, x2, y2, z2, color : integer;
  procedure init( a1, b1, c1, a2, b2, c2, col : integer );
  procedure draw;
  procedure shift( a, b, c : integer );
 end;

procedure starcar; external;
{$L Starcar.obj}

var
 carx,
 cary : integer;

procedure drawship;
 var
  i,j : integer;
  c : byte;
 begin
  for i := 0 to 10 do
   for j := 0 to 34 do
    begin
     c := mem[ seg(starcar):ofs(starcar)+800+i*35+j ];
     if c > 0 then
       drawto^[ (i+cary)*320+carx+j ] := c;
    end;
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


  procedure platform.init( a1, b1, c1, a2, b2, c2, col : integer );
   begin
    x1 := a1;
    y1 := b1;
    z1 := c1;
    x2 := a2;
    y2 := b2;
    z2 := c2;
    color := col;
   end;


procedure filltop( x1, x2, y1, x3, x4, y2 : integer; c : byte );
 var
  m1, m2 : real;
  count, b1, b2 : integer;
 begin
  m1 := (x3 - x1) / (y2 - y1);
  m2 := (x4 - x2) / (y2 - y1);
  for count := min(199,max(0,min(y1,y2))) to min(199,max(0,max(y1,y2))) do
   begin
   b1 := min( 319, max( 0, trunc( m1 * (count-y1)) + x1));
   b2 := min( 319, max( 0, trunc( m2 * (count-y1)) + x2+1));
   fillchar( drawto^[ count * 320 + b1 ], b2-b1, c );
   end;
 end;

procedure fillside( x1, y1, y2, x2, y3, y4 : integer; c : byte );
 var
  m1, m2 : real;
  count, b1, b2 : integer;
 begin
  m1 := (y3 - y1) / (x2 - x1);
  m2 := (y4 - y2) / (x2 - x1);
  for count := max(0,min(319,min(x1,x2))) to max(0,min(319,max(x1,x2))) do
   begin
   b1 := min( 199, max( 0, trunc( m1 * (count-x1)) + y1));
   b2 := min( 199, max( 0, trunc( m2 * (count-x1)) + y2));
   drawvertical( count, b1, b2, c );
   end;
 end;

  procedure platform.draw;
   var
    a1, b1, a2, b2, a3, b3, a4, b4 : integer ;
   begin
    mapcoordinates( x1, y1, z1, a1, b1 );
    mapcoordinates( x2, y2, z1, a2, b2 );
    mapcoordinates( x1, y1, z2, a3, b3 );
    mapcoordinates( x2, y2, z2, a4, b4 );
    vgastuff.box( a1, b1, a2, b2, color );
    if a3 < a1 then
     fillside( a3, b3, b4, a1, b1, b2, color + 3 )
    else
     if a4 > a2 then
      fillside( a2, b1, b2, a4, b3, b4, color + 3 );
    if b3 >= b1 then exit;
    filltop( a3, a4, b3, a1, a2, b1, color + 5);
   end;

  procedure platform.shift( a, b, c : integer );
   begin
    x1 := x1 + a;
    x2 := x2 + a;
    y1 := y1 + b;
    y2 := y2 + b;
    z1 := z1 + c;
    z2 := z2 + c;
   end;

var
 plat,
 plat2,
 plat3 : platform;
 s : word;
 key : boolean;
 starfield : ^vgascreen;
 speed : integer;

begin
 an := 180;
 tl := 90;
 px := 0;
 py := 0;
 pz := 500;
 pd := -100;
 key := false;
 initplotting( an, tl );
 initperspective( on, px, py, pz, pd );
 setmode( $13 );
 loadcol( '\aa\shades.col');
 new( starfield );
 loadcel( '\aa\starfield.cel', starfield );
 mouseon;
 showmouse( off );
 plat.init( -30,  -20, 25, 0, -25, -25, 5 );
 plat2.init( 30, -20, -75, 45, -25, -100, 136 );
 plat3.init( -35, -20, -150, 35, -25, -155, 45 );
 s := 320*149;
 vgastuff.box( 0, 150, 319, 199, 23 );
 vgastuff.box( 5, 155, 319, 199, 5 );
 vgastuff.box( 5, 155, 314, 194, 16 );
 drawto := tempvga;
 carx := 143;
 cary := 155;
 speed := 0;
 repeat
  tempvga^ := starfield^;
  plat3.draw;
  plat2.draw;
  plat.draw;
  drawship;
  move( tempvga^[320*20], vga, s );
  plat.shift( 0, 0, speed );
  if (plat.z1 > pz-5) then plat.shift (0, 0, -250);
  plat2.shift( 0, 0, speed );
  if (plat2.z1 > pz-5) then plat2.shift (0, 0, -250);
  plat3.shift( 0, 0, speed );
  if (plat3.z1 > pz-5) then plat3.shift (0, 0, -250);
  if cary < 155 then cary := 155;
  if keypressed then
   begin
    case readkey of
     '6' : carx := carx + 10;
     '4' : carx := carx - 10;
     '8' : speed := speed + 1;
     '2' : speed := speed - 1;
     ' ' : cary := cary - 40;
     '~' : savepic( 'MYPIC' );
     #13 : key := true;
    end;
     initperspective( on, px, py, pz, pd );
   end;
 until key or (moustuff.ms and 2 <> 0);
 setmode( 0 );
end.