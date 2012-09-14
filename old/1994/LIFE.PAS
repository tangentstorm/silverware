program life;
uses crt, crtstuff;

var
 colormatrix,
 newcolormatrix : array [1..132, 1..44] of byte;


type
 cell = object
  h,k,x, y, c : byte;
  procedure init( hv, kv, a, b, hue : byte );
  procedure CalcCol;
  procedure show;
 end;

procedure cell.init( hv, kv, a, b, hue : byte );
 begin
  h := hv;
  k := kv;
  x := a;
  y := b;
  c := hue;
  colormatrix[ x, y ] := c;
  show;
 end;

Procedure cell.CalcCol;
 var
  cu, cl, cd, cr : byte;
  cul, cur, cdl, cdr : byte;
 begin
  show;
  if y <>  1 then cu := colormatrix[x,y-1] else cu := 0;
  if y <> tymax then cd := colormatrix[x,y+1] else cd := 0;
  if x <>  1 then cl := colormatrix[x-1,y] else cl := 0;
  if x <> txmax then cr := colormatrix[x+1,y] else cr := 0;
  if (x <>  1) and (y <> 1) then cul := colormatrix[x-1,y-1] else cul := 0;
  if (x <>  1) and (y <>tymax) then cdl := colormatrix[x-1,y+1] else cdl := 0;
  if (x <> txmax) and (y <> 1) then cur := colormatrix[x+1,y-1] else cur := 0;
  if (x <> txmax) and (y <>tymax) then cdr := colormatrix[x+1,y+1] else cdr := 0;
  c := ( cu + cd + cl + cr + cul + cur + cdl + cdr + c ) mod 16;
  newcolormatrix[ x, y ] := c;
 end;


procedure cell.show;
 begin
  colorxy( h+x, k+y, c,  '±' );
{  sound( c * 32 );
{  if c <> 0 then delay(1);
  nosound;}
 end;

var
 matrix : array[1..132,1..44] of cell;
 countX, countY : byte;
 temp : screentype;

begin
 setupcrt;
{ setmode( 51 );}
 writeto := @screen;
 txmax := 80;
 tymax := 25;
 blinking( off );
 doscursoroff;
 randomize;
{ rectangle( 20, 5, 61, 17, $0F );}
 for countx := 1 to txmax do
  for county := 1 to tymax do
    matrix[ countx, county].init( 0, 0, countx,county,0);
{  matrix[ txmax, tymax ].init( 0, 0, txmax, tymax, 0 );}
 matrix[ random(txmax div 2), random(tymax div 2) ].init( 0, 0, txmax div 2, tymax div 2, random( 15 )+1 );
{ matrix[ txmax div 2+1, tymax div 2 ].init( 0, 0, txmax div 2+1, tymax div 2, 1 );}
 repeat until enterpressed;
 writeto := @temp;
 repeat
  for county := 1 to tymax do
   for countx := 1 to txmax do
    matrix[ countx, county].Calccol;
  colormatrix := newcolormatrix;
  move( temp, screen, sizeof( temp ) );
 until keypressed;
 blinking( on );
 doscursoron;
end.