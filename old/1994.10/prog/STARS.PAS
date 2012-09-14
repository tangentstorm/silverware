uses vgastuff,crtstuff,crt,moustuff;

type
 astar = object
  x,y,dx, dy, cx, cy,ly,ty,ny : integer;
  m : real;
  col : byte;
  size : boolean;
  step : shortint;
  procedure init( t: integer );
  procedure draw;
 end;

procedure astar.init( t : integer );
 begin
  x := mx; y := my;
  case t mod 4 of
   0 : begin dx := random( 320 ); dy :=  0; end;
   1 : begin dx := random( 320 ); dy :=  199; end;
   2 : begin dx := 0; dy := random( 200 ); end;
   3 : begin dx := 319; dy := random( 200 ); end;
  end;
  if y - dy = 0 then init( t + 1);
  size := boolean(truth( random( 2 )));
  col := random( 256 );
  cx := x;
  cy := y;
  ly := cy;
  ty := 0;
  if (dx > x) then step := (t mod 4 +1) else step := -(t mod 4 +1);
  m := (x-dx) / (y-dy);
 end;

procedure astar.draw;
 begin
  if ty <> 0 then
   begin
    putpixel( cx, ty, 0 );
    ty := inc2( ty, abs(step)*sgn(ny-ty), ny );
    if (ty = ny) or (ty<=0) or (ty > 199) then ty := 0 else
     begin
      putpixel( cx, ty, col );
      exit;
     end;
   end;
  putpixel( cx, cy, 0 );
  inc( cx, step );
  if
   (cx < 0) or (cx > 319)
  then
   init( random( 4 ) )
  else
   begin
    cy := round (m * ( cx - x )) + y;
    if abs( cy - ly) > 1 then begin
                               ny := (round(m*(cx+step-x))+y);
                               ty := cy;
                              end;
    begin
     if
      (cy < 0) or (cy > 199) then init( random( 4 ))
     else
      putpixel( cx, cy, col );
    end;
    ly := cy;
  end;
 end;

const
 maxstar = 250;
var
 ms,z : integer;
 done : boolean;
 star1 : array[ 1 .. maxstar ] of astar;
begin
 for z := 1 to maxstar do star1[ z ].init( z );
 setmode( $13 );
 setmwin( 10, 5, 620, 190 );
 repeat
  getmpos;
  mx := mx div 2;
  for z := 1 to maxstar do star1[ z ].draw;
 until (keypressed) and (readkey = #27);
 setmode( 0 );
end.