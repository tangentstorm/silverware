uses graph, bgistuff, moustuff, crt, crtstuff;

const
 gridnum =  10;
var
 x,
 maxx,
 maxy,
 center,
 horizon : integer;
 grid : array[ 1 .. gridnum ] of integer;

procedure updatelines;
 begin
  for x := 1 to gridnum do
   begin
    grid[ x ] := grid[x] + 2;
    if grid[ x ] > maxy then grid[ x ] := horizon;
   end;
 end;

procedure gridlines;
 var
  a : integer;
 begin
  for a := 1 to gridnum do
   line( 0, grid[ a ], maxx, grid[ a ] );
 end;

begin
 initgrafx;
 mouseon;
 showmouse( off );
 horizon := getmaxy div 2;
 center  := getmaxx div 2;
 maxy    := getmaxy;
 maxx    := getmaxx;
 setfillstyle( 0, 1 );
 for x := 1 to gridnum do grid[ x ] := horizon + power( 2, x+3 );
 repeat
  getmpos;
  if mousemoved then
   begin
    setcolor( 0 );
    for x := - 10 to 10 do
     line( center * x, maxy, maxx-lmx, horizon );
    setcolor( 9 );
    horizon := maxy - my;
    for x := - 10 to 10 do
     line( center * x, maxy, maxx-mx, horizon );
   { graph.bar( 0, horizon, maxx, horizon + 20 );}
   end;
 until (ms <> 0) or keypressed and (readkey = #27);
 closegraph;
end.