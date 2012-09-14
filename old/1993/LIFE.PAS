program life;
uses crt, crtstuff;

var
 colormatrix : array [1..80, 1..25] of byte;

type
 cell = object
  x, y, c : byte;
  procedure init( a, b, h : byte );
  procedure CalcCol;
  procedure show;
 end;

procedure cell.init( a, b, h : byte );
 begin
  x := a;
  y := b;
  c := h;
  show;
 end;

Procedure cell.CalcCol;
 var
  cu, cl, cd, cr : byte;
  cul, cur, cdl, cdr : byte;
 begin
  if y <>  1 then cu := colormatrix[x,y-1] else cu := 0;
  if y <> 25 then cd := colormatrix[x,y+1] else cd := 0;
  if x <>  1 then cl := colormatrix[x-1,y] else cl := 0;
  if x <> 80 then cr := colormatrix[x+1,y] else cr := 0;
  if x <>  1 and y <> 1 then cul := colormatrix[x-1,y-1] else cul := 0;
  c := (cu + cd + cl + cr + c) mod 15 + 1;
  show;
 end;

procedure cell.show;
 begin
  colormatrix[ x, y ] := c;
  colorxy( x, y, c,  'Û' );
  sound( c * 100 );
  if c <> 0 then delay( 10 );
  nosound;
 end;

var
 matrix : array[1..80,1..25] of cell;
 countX, countY : byte;

begin
 setupcrt;
 for countx := 1 to 80 do
  for county := 1 to 25 do
    matrix[ countx, county].init(countx,county,0);
 matrix[ 1, 1 ].init( 1, 1, 7 );
 repeat until enterpressed;
 repeat
  for county := 1 to 25 do
   for countx := 1 to 80 do
     matrix[ countx, county].Calccol;
 until keypressed;
end.