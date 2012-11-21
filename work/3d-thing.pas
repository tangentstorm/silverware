program three_D;
uses moustuff, crtstuff, bgistuff, graph, crt;
var
 angl, elev {,x1,x2,y1,y2}: integer;
 tx, ty, x, y, z, a, b, c : integer;
 quit : boolean;

type
 linrec = record
  x1, y1, z1, x2, y2, z2 : integer;
 end;

const
 linnotthere : linrec = (x1:-1);

var
 linarray : array[ 1 .. 500 ] of linrec;
 lincount : word;
 lintemp  : linrec;


const
 gridsize = 5;
 snapstate : boolean = false;

 procedure line3d( a, b, c, x, y, z:integer);
 var ya, yb : integer;
     ang : real;

 begin
 ang := sin(30)/cos(30);
 ya := c + round( ang * b );
 yb := z + round( ang * b );
 line (a, ya, b, yb)
 end;

 procedure dosnap;
  begin
   if
    (x mod gridsize) > (gridsize div 2)
   then
    inc( x, gridsize - x mod gridsize )
   else
    dec( x, x mod gridsize );
   if
    (y mod gridsize) > (gridsize div 2)
   then
    inc( y, gridsize - y mod gridsize )
   else
    dec( y, y mod gridsize );
   setmpos( moustuff.mx, moustuff.my );
  end;
 procedure doline;
  begin
   x := moustuff.mx;
   y := moustuff.my;
   if snapstate then dosnap;
   if
    a=-1
   then
    begin
     a := x;
     b := y;
     c := z;
    end
   else
    begin
     showmouse( off );
     setcolor( 15 );
      line( a, b, x, y );
     lincount := inc2( lincount, 1, 500 );
     with linarray[lincount] do
      begin
       x1 := a {- paperx};
       y1 := b {- papery};
       x2 := x { - paperx};
       y2 := y { - papery};
       z1 := c;
       z2 := z;
      end;
     showmouse( on );
       a := -1;
    end;
  end;

 procedure ghostline;
  begin
   if a = -1 then exit;
   x := mx;
   y := my;
   if snapstate then dosnap;
   showmouse( off );
   setwritemode( xorput );
   setcolor( 15 );
   line( a, b, x, y  );
   showmouse( on );
   delay( 10 );
   showmouse( off );
   line( a, b, x, y  );
   setwritemode( normalput );
   showmouse( on );
  end;


 begin
  tx := mx;
  ty := my;
  a := -1;
  lincount := 0;
  initgrafx;
  mouseon;
  setcolor( 15 );
  {if boxes then setgcurs( crsbox ) else setgcurs( c_hair );}
{  setmwin( paperx, papery, paperx + 400, papery + 400 );}
{  setmpos( paperx + 200, papery + 200 );}
  quit := false;
  repeat
   getmpos;
   if (lmx <> mx) or (lmy<>my) then
    begin
     x := mx;
     y := my;
     if snapstate then dosnap;
{     announce( 'X : '+n2s(x)+ ' ,  Y : '+n2s(y) );}
    end;
   if keypressed then
    case readkey of
     #0 : begin
           case readkey of
            #72: setmpos( mx, my-gridsize );
            #80: setmpos( mx, my+gridsize );
            #75: setmpos( mx-gridsize, my );
            #77: setmpos( mx+gridsize, my );
           end;
          end;
     #13: doline;
     #27: quit := true;
    end
  else
   if (ms and 1 <> 0) then
    begin
     doline;
     repeat
      getmpos;
      ghostline;
     until (ms and 1 = 0);
    end
   else
    ghostline;
   if ( ms and 2 <> 0 ) then
    begin
     repeat getmpos until ms and 2 = 0;
     if ( a <> -1 ) then a := -1
      else quit := true;
    end;
  until quit;
  setmwin( 0, 0, getmaxx, getmaxy );
{  setgcurs( hplot );}
  setmpos( tx, ty );
{  announce( '' ); }
  closegraph;
   for elev := 1 to lincount do
    with linarray[ elev ] do
      writeln('X1:', x1, '  Y1:',  y1, '  X2:', x2, '  Y2:', y2 );
    writeln;
    writeln( lincount, ' Entries...' );
    readln;

    initgrafx;
    for elev := 1 to lincount do
     with linarray[ elev ] do
      line3d( x1, y1, z1, x2, y2, z2 );
    getenter;
    closegraph;

 end.
