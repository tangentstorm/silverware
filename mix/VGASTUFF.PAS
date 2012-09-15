unit vgastuff;
interface

type
 pixelproc = procedure( x, y : integer; C: byte );
var
 putpixel : pixelproc;

 procedure setmode( mode : word );
 procedure putpixelvga( x, y : integer; c : byte );
 procedure putpixelcga( x, y : integer; c : byte );
 procedure drawvertical( a2, b2, d2 : integer; color : byte );
 procedure drawline( a, b, c, d : integer; color : byte );
 procedure rectangle( a1, b1, a2, b2 : integer; c : byte );
 procedure box( a1, b1, a2, b2 : integer; c : byte );
 procedure filltop( x1, x2, y1, x3, x4, y2 : integer; c : byte );
 procedure setcolor( c, r, g, b : byte );
 procedure getcolor( c : byte; var r, g, b : byte );
 procedure savepic( fn : string );
 procedure loadpic( fn : string );
 procedure loadcel( fn : string );
 function getmaxx: integer;
 function getmaxy: integer;

type
 vgascreen = array[ 0..63999 ] of byte;

var
 cga : vgascreen absolute $b800:0000;
 vga : vgascreen absolute $a000:0000;
 drawto,tempvga : ^vgascreen;
 yline : array[0..199] of integer;

implementation
uses crtstuff, filstuff;


procedure SetMode (Mode : word);
begin
  asm
    mov ax,Mode;
    int 10h
  end;
end;

{$F+}
procedure putpixelvga( x, y : integer; c : byte );
 begin
  drawto^[ yline[y] + x ] := c;
 end;

procedure putpixelcga( x, y : integer; c : byte );
 var
  b : integer;
  d : byte;
 begin
  b := (y div 2) * 80 + (x div 8);
  d := 1 shl (7-(x mod 8));
  if y mod 2 = 1 then b := b + 8192; { odd offset }
  drawto^[ b ] := drawto^[ b ] AND NOT D XOR C * D;
 end;
{$F-}

procedure drawvertical( a2, b2, d2 : integer; color : byte );
 var count : integer;
 begin
  if (a2 >= 0) and (a2 <= 319) then
  for count := max(0,min( b2, d2 )) to min(199,max( b2, d2 )) do putpixel( a2, count, color );
 end;


procedure drawline( a, b, c, d : integer; color : byte );
 var
  m : real;
  x,y,lasty : integer;
 begin
  if min( a, c ) = a then lasty := b else lasty := d;
  if
   ( a - c ) <> 0
  then
   begin
    m := (b-d) / (a-c);
    lasty := round (m * ( max(0,min(a,c)) - a )) + b;
    for x := max( 0, min( a, c )) to min( getmaxx-1, max( a, c )) do
    begin
     y := round (m * ( x - a )) + b;
     if
      abs( y - lasty ) > 1
     then
      if
       min( y, lasty ) = y
      then
       drawvertical( x, lasty-1, y, color )
      else
       drawvertical( x, lasty+1, y, color );
     lasty := y;
     if (y >= 0) and (y <= 199)  then Putpixel( x, y, color );
    end; { for x.. }
   end { if..then }
  else
   drawvertical( a, b, d, color );
 end; { procedure }

procedure rectangle( a1, b1, a2, b2 : integer; c: byte );
 var
  l, r, t, b : integer;
 begin
  l := min( getmaxx-1, max( 0, min( a1, a2 )));
  r := min( getmaxx-1, max( 0, max( a1, a2 )));
  t := min( 199, max( 0, min( b1, b2 )));
  b := min( 199, max( 0, max( b1, b2 )));
  drawline( l, t, r, t, c );
  drawline( r, t, r, b, c );
  drawline( r, b, l, b, c );
  drawline( l, b, l, t, c );
 end;

procedure box( a1, b1, a2, b2 : integer; c: byte );
 var
  l, r, t, b, count : integer;
 begin
  l := min( getmaxx-1, max( 0, min( a1, a2 )));
  r := min( getmaxx-1, max( 0, max( a1, a2 )));
  t := min( 199, max( 0, min( b1, b2 )));
  b := min( 199, max( 0, max( b1, b2 )));
  for count := t to b do
   fillchar( drawto^[ 320 * count + l ], r - l + 1, c );
 end;

procedure filltop( x1, x2, y1, x3, x4, y2 : integer; c : byte );
 var
  m1, m2 : real;
  count, b1, b2 : integer;
 begin
  drawline( x1, y1, x2, y1, c * 3 );
  drawline( x2, y1, x4, y2, c * 3 );
  drawline( x4, y2, x3, y2, c * 3 );
  drawline( x3, y2, x1, y1, c * 3 );
  getenter;
  m1 := (x3 - x1) / (y2 - y1);
  m2 := (x4 - x2) / (y2 - y1);
  for count := y1 to y2 do
   drawline( trunc(m1 * (count-y1)) + x1, count,
             trunc(m2 * (count-y1)) + x2, count, c );
 end;

procedure setcolor( c, r, g, b : byte );
 begin
  port[ $3c8 ] := c;
  port[ $3c9 ] := r;
  port[ $3c9 ] := g;
  port[ $3c9 ] := b;
 end;

procedure getcolor( c : byte; var r, g, b : byte );
 begin
  port[ $3c7 ] := c;
  r:= port[ $3c9 ];
  g:= port[ $3c9 ];
  b:= port[ $3c9 ];
 end;

 procedure savepic( fn : string );
  var
   f : file;
   c : byte;
  begin
   filerewrite( f, fn );
   for c := 0 to 255 do
     begin
      port[ $3c7 ] := c;
      savebyte( f, port[ $3c9 ] ); {r}
      savebyte( f, port[ $3c9 ] ); {g}
      savebyte( f, port[ $3c9 ] ); {b}
     end;
   blockwrite( f, vga, sizeof( vgascreen ));
   close( f );
  end;

 procedure loadpic( fn : string );
  var
   f : file;
   c : byte;
  begin
   filereset( f, fn );
   for c := 0 to 255 do
     begin
      port[ $3c8 ] := c;
      port[ $3c9 ] := nextbyte( f ); {r}
      port[ $3c9 ] := nextbyte( f ); {g}
      port[ $3c9 ] := nextbyte( f ); {b}
     end;
   blockread( f, vga, sizeof( vgascreen ));
   close( f );
  end;

procedure loadcel( fn : string );
  var
   f : file;
   c,n : byte;
  begin
   filereset( f, fn );
   for c := 1 to 32 do
    n := nextbyte( f );
   for c := 0 to 255 do
     begin
      port[ $3c8 ] := c;
      port[ $3c9 ] := nextbyte( f ); {r}
      port[ $3c9 ] := nextbyte( f ); {g}
      port[ $3c9 ] := nextbyte( f ); {b}
     end;
   blockread( f, vga, sizeof( vgascreen ));
   close( f );
  end;

function getmaxx: integer;
 begin
  if drawto <> @cga then
   getmaxx := 320
  else
   getmaxx := 640;
 end;

function getmaxy: integer;
 begin
  getmaxy := 200;
 end;

var
  Dum : ^byte;
  d : byte;
begin
  for d := 0 to 199 do yline[d] := d * 320;
  repeat
    new (tempvga);
    if ofs (tempvga^) <> 0 then begin
      dispose (tempvga);
      new (Dum);
    end;
  until ofs (tempvga^) = 0;
 drawto := @vga;
 putpixel := putpixelvga;
end.
