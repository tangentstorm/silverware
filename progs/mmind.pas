program mmind;
uses crtstuff,crt;

const
 linecolor = 14;
 namecolor = 10;
 numblanks = 4;
 numchars  = 10;

var
 num1,
 num2 : string[ numblanks ];

type
 gridobj = object
  grid : array[ 1..numblanks, 0 .. numchars-1 ] of boolean;
  constructor init;
  procedure draw( a, b : byte );
 end;
 guesstype = record
  grid : gridobj;
  guess : array [ 1..numblanks ] of byte;
   accurates,
  hits : byte;
 end;

constructor gridobj.init;
 var
  i,j : integer;
 begin
  for i := 1 to numblanks do
   for j := 0 to numchars - 1 do
    grid[ i, j ] := true;
 end;

procedure gridobj.draw( a, b : byte );
 var
  i, j : integer;
 begin
  rectangle( a, b, a + 2 * ( numblanks +1), b + numchars +1, lightgreen );
  for i := 1 to numblanks do
   for j := 0 to numchars - 1  do
    if grid[ i, j ] then
     colorxy( a+ i * 2, a + 1 + j, $F, n2s( j ) )
    else
     colorxy( a+ i * 2, a + 1 + j, $8, 'X' )
 end;
var
 v : gridobj;
begin
 clrscr;
 v.init;
 v.draw( 5, 5 );
end.