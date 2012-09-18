program icons;

uses graph, crtstuff, moustuff, bgistuff;


type
 icon = object ( button )
  procedure getnorm; virtual;
  function depressed : boolean;
 end;


procedure icon.getnorm;
 begin
  if norm <> nil then free( norm );
  setfillstyle( 1, 15 );
  showmouse( off );
  graph.bar( x1, y1, x2, y2 );
  graph.rectangle( x1, y1, x2, y2 );
  setcolor( 4 );
  circle( x1 + 10, y1+ 10, 5 );
  showmouse( on );
 end;

function icon.depressed : boolean;
 begin
  getmpos;
  depressed :=
   (ms and $01 <> 0)
   and (mx > x1 ) and (mx < x2 )
   and (my > y1 ) and (my < y2 )
 end;


var
 quit : boolean;
 icn : icon;

begin
 quit := false;
 initgrafx;
 setfillstyle( 1, 1 );
 graph.bar( 0, 0, getmaxx, getmaxy );
 mouseon;
 icn.init( 0, 0, 25, 25, '' );
 icn.draw;
 repeat
  getmpos;
  if icn.depressed then
   repeat
    getmpos;
    if mousemoved and (ms and $01 <> 0) then icn.move( mx, my );
   until ms and $01 = 0;
  quit := ms = 2;
 until quit;
end.