Program Yfrac;
uses graph, grafx;

var
 r : integer;

procedure vecline( startx, starty, direction, length : integer );
 var
  newx, newy, newl, newd1, newd2 : integer;

 procedure newxy( x, y : integer );
  begin
    newx := x;
    newy := y;
    newl := length div 4 * 3 { div 2};
    inc( r );
    if r > 15 then r := 1;
    setcolor( r );
  end;

 procedure newdir( direction : integer );
  begin
   case direction of
    1 : begin newd1 := 4; newd2 := 2; end;
    2 : begin newd1 := 1; newd2 := 3; end;
    3 : begin newd1 := 2; newd2 := 6; end;
    4 : begin newd1 := 7; newd2 := 1; end;
    5 : ;
    6 : begin newd1 := 3; newd2 := 9; end;
    7 : begin newd1 := 8; newd2 := 4; end;
    8 : begin newd1 := 9; newd2 := 7; end;
    9 : begin newd1 := 6; newd2 := 8; end;
   end;
  end;

 begin
  case direction of
   1 : newxy( startx - length, starty + length );
   2 : newxy( startx, starty + length );
   3 : newxy( startx + length, starty + length );
   4 : newxy( startx - length, starty );
   5 : ;
   6 : newxy( startx + length, starty );
   7 : newxy( startx - length, starty - length );
   8 : newxy( startx, starty - length );
   9 : newxy( startx + length, starty - length );
  end;
  line( startx, starty, newx, newy );
  if newl > 0 then
{   if r < 16 then}
   begin
    newdir( direction );
    vecline( newx, newy, newd1, newl );
    vecline( newx, newy, newd2, newl );
    dec( r );
   end;
 end;

begin
 r:= 0;
 initgrafx;
 setviewport( getmaxx div 2, getmaxy div 2, getmaxx, getmaxy, false );
 setcolor( 15 );
 vecline( 0, 240, 8, 128  );
end.