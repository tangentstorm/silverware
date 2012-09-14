Program Cube1;
Uses Crt,CrtStuff,Grafx,Graph,ThreeD,Math;

Type
  Point3D = Object
    x, y, z : Real;
    Constructor Init( a, b, c : real );
    Procedure Move( a, b, c : real ); virtual;
    Procedure MoveRel ( a, b, c : real ); virtual;
    Procedure PArray( var A : TDA );
    Function XCoord : Real;
    Function YCoord : Real;
    Function ZCoord : Real;
  End;
  Camera3D = Object (Point3D)
    angle, tilt : integer;
    distance : real;
    Perspective : Boolean;
    Constructor Init( a, b, c, d : real; ang, tlt : integer; P : Boolean );
    Procedure On;
    Procedure Move( a, b, c : real ); virtual;
    Procedure Moverel( a, b, c : real ); virtual;
    Procedure Yaw( a : integer );
    Procedure Roll( t : integer );
    Procedure Line ( F, T : Point3D; Col : byte );
    Procedure Plot ( P : Point3D; Col : byte );
  End;
  Camera3DPtr = ^Camera3d;
  Cube3D = Object
    color : byte;
    View : Camera3DPtr;
    Points : Array [0..1,0..1,0..1] of Point3D;
    Constructor Init( CenX, CenY, CenZ, Radius : integer;
                        Cam : Camera3DPtr; Col: byte );
    Procedure Colr( Col : byte );
    Procedure Draw;
  End;

Function IntSqrt( n : integer ) : integer;
  Var
     OddInt, OldArg, FirstSqrt : integer;
  Begin
     OddInt := 1;
     OldArg := n;
     While n >= 0 Do
       Begin
         n := n - OddInt;
         OddInt := OddInt + 2;
       End;
     FirstSqrt := OddInt Shr 1;
     If (Sqr(FirstSqrt) - FirstSqrt + 1 > OldArg) Then
       IntSqrt := FirstSqrt - 1
     Else
       IntSqrt := FirstSqrt;
  End;

Constructor Point3D.Init( a, b, c : real );
  Begin
    x := a;
    y := b;
    z := c;
  End;

Procedure Point3D.Move( a, b, c : real );
  Begin
    x := a;
    y := b;
    z := c;
  End;

Procedure Point3D.MoveRel( a, b, c : real );
  Begin
    x := x + a;
    y := y + b;
    z := z + c;
  End;

Procedure Point3D.PArray( Var A : TDA);
  Begin
    Vec( x, y, z, A );
  End;

Function Point3D.XCoord : Real;
  Begin
    XCoord := X;
  End;

Function Point3D.YCoord : real;
  Begin
    YCoord := Y;
  End;

Function Point3D.ZCoord : real;
  Begin
    ZCoord := Z;
  End;

Constructor Cube3D.Init( CenX, CenY, CenZ, Radius : integer;
                           Cam : Camera3DPtr; Col : byte );
  Begin
    Points[0,0,0].Init( CenX - Radius, CenY - Radius, CenZ - Radius );
    Points[0,0,1].Init( CenX - Radius, CenY - Radius, CenZ + Radius );
    Points[0,1,0].Init( CenX - Radius, CenY + Radius, CenZ - Radius );
    Points[0,1,1].Init( CenX - Radius, CenY + Radius, CenZ + Radius );
    Points[1,0,0].Init( CenX + Radius, CenY - Radius, CenZ - Radius );
    Points[1,0,1].Init( CenX + Radius, CenY - Radius, CenZ + Radius );
    Points[1,1,0].Init( CenX + Radius, CenY + Radius, CenZ - Radius );
    Points[1,1,1].Init( CenX + Radius, CenY + Radius, CenZ + Radius );
    View := Cam;
    Color := Col;
  End;

Constructor Camera3D.Init( a, b, c, d: real; ang, tlt : integer; P : Boolean );
  Begin
    angle := ang;
    tilt := tilt;
    distance := d;
    perspective := P;
    x := a;
    y := b;
    z := c;
    On;
  End;

Procedure Camera3D.On;
  Begin
    InitPlotting( angle, tilt );
    InitPerspective( Perspective, x, y, z, distance );
  End;

Procedure Camera3d.Yaw( a : integer );
  begin
    Angle := Angle + a;
    On;
  end;

Procedure Camera3D.Roll( t : integer );
  begin
    Tilt := Tilt + t;
    On;
  end;

Procedure Camera3d.Move;
  begin
    Point3d.Move( a, b, c );
    On;
  end;


Procedure Camera3d.MoveRel;
  begin
    Point3d.MoveRel( a, b, c );
    On;
  end;

Procedure Camera3D.Plot( P : Point3D; Col : Byte );
  Begin
    Cartesianplot3D( P.XCoord, P.YCoord, P.ZCoord, Col );
  End;

Procedure Camera3D.Line( F, T : Point3D; Col : byte );
  Var
    fA, tA : TDA;
  Begin
    F.PArray( fA );
    T.PArray( tA );
    DrawLine3D( fA, tA, Col );
  End;

Procedure Cube3D.Colr( Col : byte );
  Begin
    Color := Col;
  End;

Procedure Cube3D.Draw;
  Begin
    View^.Line( Points[0,0,0], Points[0,0,1], Color );
    View^.Line( Points[0,0,1], Points[1,0,1], Color );
    View^.Line( Points[1,0,1], Points[1,0,0], Color );
    View^.Line( Points[1,0,0], Points[0,0,0], Color );
    View^.Line( Points[0,1,0], Points[0,1,1], Color );
    View^.Line( Points[0,1,1], Points[1,1,1], Color );
    View^.Line( Points[1,1,1], Points[1,1,0], Color );
    View^.Line( Points[1,1,0], Points[0,1,0], Color );
    View^.Line( Points[0,0,0], Points[0,1,0], Color );
    View^.Line( Points[0,0,1], Points[0,1,1], Color );
    View^.Line( Points[1,0,1], Points[1,1,1], Color );
    View^.Line( Points[1,0,0], Points[1,1,0], Color );
   End;

Var
  Camera : Camera3D;
  Cube, Cube2   : Cube3D;
  Done   : Boolean;
  Ch     : Char;

Begin
  InitGrafx;
  OutTextXY(1,1,'Neato 3D Cube Thing');
  OutTextXY(1,11,'-=< (C)1992 MJW >=-');
{-----}
  Done := False;
  Camera.Init( 0, 0, 0, 600, 90, 0, TRUE );
  Cube.Init ( 0, 0, 0, 30, @Camera, 9 );
  Cube2.Init( 0, 0, 0, 50, @Camera, 1 );
Repeat
  Cube.Colr(9);  Cube2.Colr(1);
  Cube.Draw;     Cube2.Draw;
    begin
      Ch := Readkey;
      If Ch = #0 then
        begin
          Cube.Colr(0);  Cube2.Colr(0);
          Cube.Draw;     Cube2.Draw;
          Ch := Readkey;
          Case Ch of
            #73 : Camera.MoveRel(   0,   0, -10 );  { PgUp / -Z }
            #81 : Camera.MoveRel(   0,   0,  10 );  { PgDn / +Z }
            #72 : Camera.MoveRel(   0,  10,   0 );  { UpAr / +Y }
            #80 : Camera.MoveRel(   0, -10,   0 );  { DnAr / -Y }
            #77 : Camera.MoveRel(  10,   0,   0 );  { RtAr / +X }
            #75 : Camera.MoveRel( -10,   0,   0 );  { LfAr / -X }
            #71 : Camera.Yaw(  5 );                 { Home / +A }
            #79 : Camera.Yaw( -5 );                 { End  / -A }
            #06 : Camera.Roll(  5 );                { ^Del / +T }
            #83 : Camera.Roll( -5 );                { Del  / -T }
          end;
        end
      else
        Done := True;
    end;
Until Done;
{-----}
  CloseGraph;
End.