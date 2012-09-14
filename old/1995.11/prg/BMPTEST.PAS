program bmptest;
uses vgastuff{graph,bgistuff},filstuff,crt,crtstuff;

var
 a, b, x, y : word;
 ch : char;
 z : byte;
 f : file;

const
 fix : array [black..white] of byte =
  ( 0, 4, 2, 6, 1, 5, 3, 7, 8, 12, 10, 14, 9, 13, 11, 15 );
var
 xarray : virtualarray;

begin
 a := 320;
 b := 200;
 getmem( xarray, a*b );
 setmode($13);
 filereset( f, 'C:\tp\inc\grid.bmp' );
{ for x := 0 to 15 do setpalette( x, fix[x] );}
 seek( f, 1078 );
 blockread( f, xarray^, a*b);
 for y := b-1 downto 0 do
  move( xarray^[ (199-y) * 320  ], vga[ y * 320 ], 320 );  {256colors}
 directvideo := false;
 for y := 1 to 1078 do
  begin
   seek( f, y );
   for x := 0 to 255 do setcol( x, nextbyte(f), nextbyte(f), nextbyte(f) );
   getenter;
  end;
 close(f);
 getenter;
 setmode(2);
end.
 for y := b downto 1 do
  begin
   for x := 0 to (a-1) do
    begin
     putpixel( 2*x, y, fix[xarray^[(b-y+1)*320+x] div 16]);
     putpixel( 2*x+1, y, fix[xarray^[(b-y+1)*320+x] mod 16]);
     if keypressed then exit;
    end;
   end;
end.
