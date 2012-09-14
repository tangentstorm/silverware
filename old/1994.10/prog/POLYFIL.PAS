program polyfil;

uses crtstuff, vgastuff;

const
 x1 = 5;
 x2 = 200;
 y1 = 5;
 x3 = 100;
 x4 = 150;
 y2 = 150;
 c = 20;

procedure filltop( x1, x2, y1, x3, x4, y2 : integer; c : byte );
 var
  m1, m2 : real;
  count, b1, b2 : integer;
 begin
  m1 := (x3 - x1) / (y2 - y1);
  m2 := (x4 - x2) / (y2 - y1);
  for count := y1 to y2 do
   begin
   b1 := trunc( m1 * (count-y1)) + x1;
   b2 := trunc( m2 * (count-y1)) + x2+1;
   fillchar( vga[ count * 320 + b1 ], b2-b1, c );
   end;
 end;

procedure fillside( x1, y1, y2, x2, y3, y4 : integer; c : byte );
 var
  m1, m2 : real;
  count, b1, b2 : integer;
 begin
{  drawline( x1, y1, x1, y2, 45 );
  drawline( x1, y1, x2, y3, 45 );
  drawline( x1, y2, x2, y4, 45 );
  drawline( x2, y3, x2, y4, 45 );
  getenter;}
  m1 := (y3 - y1) / (x2 - x1);
  m2 := (y4 - y2) / (x2 - x1);
  for count := x1 to x2 do
   begin
   b1 := trunc( m1 * (count-x1)) + y1 -1;
   b2 := trunc( m2 * (count-x1)) + y2;
   drawvertical( count, b1, b2, c );
   end;
 end;

begin
 setmode( $13 );
{ box( 50, 75, 100, 90, 15 );
 filltop( 120, 150, 50, 50, 100, 75, 7 );}
 fillside( 100, 75, 90, 150, 50, 60, 8 );
 getenter;
end.