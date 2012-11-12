Unit Threed;
Interface
Uses Math;

 Var
   CenterX, CenterY   : Integer;
   Angl, Tilt          : Integer;
   CosA, SinA         : Real;
   CosB, SinB         : Real;
   CosACosB, SinASinB : Real;
   CosASinB, SinACosB : Real;
 Procedure InitPlotting( Ang, Tlt : Integer );

 Var
   PerspectivePlot : Boolean;
   Mx, My, Mz, ds : Real;
 Procedure InitPerspective( Perspective: Boolean; x, y, z, m : real );
 Procedure MapCoordinates( X, Y, Z : Real; Var Xp, Yp : Integer );
 Procedure CartesianPlot3D( X, Y, Z : Real; Color : Byte );
 Procedure DrawLine3D( Pnt1, Pnt2 : TDA; Color : Byte );
 procedure line3d( x1, y1, z1, x2, y2, z2 : integer; col : byte );

Implementation
Uses Graph;

  Procedure InitPlotting( Ang, Tlt : Integer );
    Begin
      CenterX := GetMaxX Div 2;
      CenterY := GetMaxY Div 2;
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

  Procedure CartesianPlot3D( X, Y, Z : Real; Color : Byte );
    Var
      Xp, Yp : Integer;
    Begin
      MapCoordinates( X, Y, Z, Xp, Yp );
      PutPixel( Xp, Yp, Color );
    End;

  Procedure DrawLine3D( Pnt1, Pnt2 : TDA; Color : Byte );
    Var
      Xp1, Yp1   : Integer;
      Xp2, Yp2   : Integer;
      x1, y1, z1 : Real;
      x2, y2, z2 : Real;
    Begin
      UnVec( Pnt1, x1, y1, z1 );
      UnVec( Pnt2, x2, y2, z2 );
      MapCoordinates( x1, y1, z1, Xp1, Yp1 );
      MapCoordinates( x2, y2, z2, Xp2, Yp2 );
      SetColor( Color );
      Line( Xp1, Yp1, Xp2, Yp2 );
    End;

  procedure line3d( x1, y1, z1, x2, y2, z2 : integer; col : byte );
    Var
      Xp1, Yp1   : Integer;
      Xp2, Yp2   : Integer;
    begin
     MapCoordinates( x1, y1, z1, Xp1, Yp1 );
     MapCoordinates( x2, y2, z2, Xp2, Yp2 );
     SetColor( Col );
     Line( Xp1, Yp1, Xp2, Yp2 );
    end;

End.