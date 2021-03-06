program bmptest;
uses graph,bgistuff,filstuff,crt,crtstuff;

var
 a, b, x, y : word;
 ch : char;
 z : byte;
 f : file;

type
 _virtualarray = array[0..0] of byte;
 virtualarray = ^_virtualarray;

const
 fix : array [black..white] of byte =
  ( 0, 4, 2, 6, 1, 5, 3, 7, 8, 12, 10, 14, 9, 13, 11, 15 );
var
 xarray : virtualarray;

begin
 a := 320;
 b := 480;
 getmem( xarray, a*b );
 initgrafx;
 filereset( f, 'dsktop2.bmp' );
{ for x := 0 to 15 do setpalette( x, fix[x] );}
 seek( f, 118 );
 blockread( f, xarray^, a*b );
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
