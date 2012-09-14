{
  Michal Wallace
  Pig Latin Program
  October 25, 1992
}

Program PigLatin;
Uses Crt, Dos;

Var
 DataPtr : Integer;
 St      : String;

Const
 DataMax = 6;
 Data : Array[ 0 .. DataMax ] of String =
         ('I''m not a real actor.. But I play one on TV.',
          'Mister Rogers is a Nazi spy! Pass it on!',
          'Your Life is like... an analogy.',
          'We should strive for immortality, or die trying.',
          'Anyone who sees a shrink should have his head examined.',
          'Hey! Isn''t that the evil spawn of Satan''s nephew?',
          'Time is an illusion; lunchtime doubly so.');

Procedure CursorShape(Top, Bottom : Byte);
   Var Regs : Registers;
   Begin
      Regs.AH := $01;
      Regs.CH := Top;
      Regs.CL := Bottom;
      Intr($10,Regs);
   End;

Function UpStr( S : String ) : String;
 Var
  B : Byte;
 Begin
  For B := 1 to Byte( s[0] ) do
    s[ b ] := UpCase( s[ b ] );
  UpStr := s;
 End;

Procedure ClearStr( Var S : String );
 var
  b : byte;
 begin
   for b := 1 to 255 do S[b] := ' ';
   s := '';
 end;

Procedure Line;
 Begin
   TextColor(9);
   Write('컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴');
   TextColor(15);
 End;

Function Read : String;
 Begin
   Read := Data[ DataPtr ];
   Inc( DataPtr );
 End;

Function IsVowel( C : char ) : Boolean;
 begin
   IsVowel := ( c = 'A' ) or ( c = 'E' ) or
              ( c = 'I' ) or ( c = 'O' ) or
              ( c = 'U' ) or ( c = 'Y' );
 end;


Function HasVowels( S : String ) : Boolean;
 var
  b : byte;
  h : boolean;
 begin
  h := false;
  for b := 1 to length( s ) do
   if isvowel( s[ b ] ) then h := true;
  HasVowels := h;
 end;

Function IsConsonant( C : char ) : boolean;
 begin
   IsConsonant := ( c  > 'A' ) and ( c <> 'E' ) and
                  ( c <> 'I' ) and ( c <> 'O' ) and
                  ( c <> 'U' ) and ( c <> 'Y' ) and
                  ( c <= 'Z' );
 end;

Function AllCons( S : String ) : Boolean;
 var
  a : boolean;
  b : byte;
 begin
  a := true;
  for b := 1 to length( S ) do
   if Not IsConsonant( s[ b ] ) then a := false;
  AllCons := a;
 end;

Function Translate( S : String ) : String;
  Var
   T, U, V : String;
   C : Char;
   B : Byte;
  Begin
   T := UpStr( S );
   B := 0;
   U := '';
   V := '';
   While B < Length( T ) do
    begin
     Inc( B );
     If ( T[ B ] >= 'A' ) and ( T[ B ] <= 'Z' ) or ( T[ B ] = '''' )
      then
        U := U + T[ B ]
      else
       begin
        If IsConsonant( U[ 1 ] )
         then
          begin
           if HasVowels( U ) then
           While IsConsonant( U[ 1 ] ) do
            begin
             C := U[ 1 ];
             Delete( U, 1, 1 );
             U := U + C;
            end;
           If IsVowel( U[ 1 ] ) then U := U + 'AY'
            else
           If AllCons( U ) then U := U + 'YAY';
          end
         else
          if IsVowel( U[ 1 ] )
           then
            begin
             if U[ 1 ] = 'Y' then delete( U, 1, 1 );
             U := U + 'YAY';
            end;
        v := V + U + T[ B ];
        ClearStr( U );
       end;
    end;
   Translate := V;
  End;

Begin
 ClrScr;
 CursorShape( $F, 0);
 TextColor( 14 );
 WriteLn('Pig Latin Program   10/25/92    by Michal Wallace            ');
 Line;
 DataPtr := 0;
 Repeat
   St := Read;
   Writeln( St );
   TextColor(10);
   Writeln( Translate( St ) );
   Line;
 Until DataPtr > DataMax;
 TextColor( 14 );
 WriteLn('Press any key to quit. ');
 Repeat Until Keypressed;
 CursorShape( $E, $E );
End.