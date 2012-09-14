Unit Math;
Interface

{==Mathematical Functions==}

 Const
   Ln10 = 2.30258509299405E+000;        { Ln(10) = 2.3025851  }
   PiOver180 = 1.74532925199433E-002;   { Pi/180 = 0.0174533  }
   PiUnder180 = 5.72957795130823E+001;  { 180/Pi = 57.2957795 }
 Function Radians( Angle : Real ) : Real;
 Function Degrees( Angle : Real ) : Real;
 Function CosD( Angle : Real ) : Real;
 Function SinD( Angle : Real ) : Real;
 Function sec( Angle : Real ) : Real;
 Function csc( Angle : Real ) : Real;
 Function SecD( Angle : real ) : Real;
 Function CscD( Angle : Real ) : Real;

{==Vector and Matrix Stuff==}

  Type
    TDA = Array[0..2] of Real;
    TDIA = Array[0..2] of Integer;
    FDA = Array[0..3] of Real;
    Matx4x4 = Array[0..3,0..3] of Real;
  Procedure Vec( r, s, t : Real; Var A : TDA );
  Procedure UnVec( A: TDA; Var r, s, t : Real );

Implementation

{==Mathematical Functions==}

  Function Radians( Angle : Real ) : Real;
    Begin
      Radians := Angle * PiOver180;
    End;

  Function Degrees( Angle : Real ) : Real;
    Begin
      Degrees := Angle * PiUnder180;
    End;

  Function CosD( Angle : Real ) : Real;
    Begin
      CosD := Cos( Radians( Angle ) );
    End;

  Function SinD( Angle : Real ) : Real;
    Begin
      SinD := Sin( Radians( Angle ) );
    End;

  Function Sec( angle : Real ) : Real;
    begin
      If cos ( angle ) <> 0 then
         Sec := 1 / ( cos ( angle ) )
      else
         Sec := MaxInt;
    end;

  Function Csc( Angle : real ) : Real;
    begin
      If sin( angle ) <> 0 then
         Csc := 1 / ( sin ( angle ) )
      else
         Csc := MaxInt;
    end;

  Function SecD( angle : Real ) : Real;
    begin
       SecD := Sec( Radians( Angle ) );
    end;

  Function CscD( Angle : Real ) : Real;
    begin
      CscD := Csc( Radians( Angle ) );
    end;

{==Vector and Matrix Stuff==}

  Procedure Vec( r, s, t : Real; Var A : TDA );
    Begin
      A[0] := r;
      A[1] := s;
      A[2] := t;
    End;

  Procedure UnVec( A: TDA; Var r, s, t : Real );
    Begin
      r := A[0];
      s := A[1];
      t := A[2];
    End;

End.