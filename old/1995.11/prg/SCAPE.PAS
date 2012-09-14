program
 scape;

{ Implements a fractal landscape }

uses
 grafx, graph, crt, crtstuff;

var
 sign : integer;

function l( a, b : integer ) : integer;
 begin
  if
   a < b
  then
   l := a
  else
   l := b;
 end;

procedure mountainline( x1, y1, x2, y2, step, c  : integer );
 var
  mx, my : integer;
 begin
  if
   step > 1
  then
   begin
    sign := sign * -1;
    mx := l( x1, x2 ) + (abs( x2 - x1 ) - step * sign ) div 2;
    my := l( y1, y2 ) + (abs( y2 - y1 ) + step * sign ) div 2;
    mountainline( x1, y1, mx, my, step div 2, c + 1 );
    mountainline( mx, my, x2, y2, step div 2, c + 1 );
   end;
{   else}
   begin
    setcolor( c );
    line ( x1, y1, x2, y2 );
   end;
 end;

begin
 InitGrafx;
 sign :=1;
 mountainline( 0, GetMaxY div 2, GetMaxX, GetMaxY div 2, 480, 1 );
 repeat until enterpressed;
 closegraph;
end.