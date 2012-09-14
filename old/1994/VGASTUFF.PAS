unit vgastuff;
interface

 procedure setmode( mode : word );
 procedure putpixel( x, y : integer; c : byte );
 procedure drawline( a, b, c, d : integer; color : byte );
 procedure rectangle( a1, b1, a2, b2 : integer; c : byte );
 procedure box( a1, b1, a2, b2 : integer; c : byte );

type
 vgascreen = array[ 0..63999 ] of byte;

var
 vga : vgascreen absolute $a000:0000;
 drawto,tempvga : ^vgascreen;

implementation
uses crtstuff;

procedure SetMode (Mode : word);
begin
  asm
    mov ax,Mode;
    int 10h
  end;
end;


procedure putpixel( x, y : integer; c : byte );
 begin
  drawto^[ y * 320 + x ] := c;
 end;


procedure drawline( a, b, c, d : integer; color : byte );
 var
  m : real;
  x,y,lasty : integer;
 procedure drawvertical( a2, b2, d2 : integer );
  var count : integer;
  begin
   for count := min( b2, d2 ) to max( b2, d2 ) do putpixel( a2, count, color );
  end;
 begin
  if min( a, c ) = a then lasty := b else lasty := d;
  if
   ( a - c ) <> 0
  then
   begin
    m := (b-d) / (a-c);
    for x := max( 0, min( a, c )) to min( 319, max( a, c )) do
    begin
     y := round (m * ( x - a )) + b;
     if
      abs( y - lasty ) > 1
     then
      if
       min( y, lasty ) = y
      then
       drawvertical( x, lasty-1, y )
      else
       drawvertical( x, lasty+1, y );
     lasty := y;
     Putpixel( x, y, color );
    end; { for x.. }
   end { if..then }
  else
   drawvertical( a, b, d );
 end; { procedure }

procedure rectangle( a1, b1, a2, b2 : integer; c: byte );
 var
  l, r, t, b : integer;
 begin
  l := min( a1, a2 );
  r := max( a1, a2 );
  t := min( b1, b2 );
  b := max( b1, b2 );
  drawline( l, t, r, t, c );
  drawline( r, t, r, b, c );
  drawline( r, b, l, b, c );
  drawline( l, b, l, t, c );
 end;

procedure box( a1, b1, a2, b2 : integer; c: byte );
 var
  l, r, t, b, count : integer;
 begin
  l := min( a1, a2 );
  r := max( a1, a2 );
  t := min( b1, b2 );
  b := max( b1, b2 );
  for count := t to b do
   fillchar( drawto^[ 320 * count + l ], r - l + 1, c );
 end;

var
  Dum : ^byte;
begin
  repeat
    new (tempvga);
    if ofs (tempvga^) <> 0 then begin
      dispose (tempvga);
      new (Dum);
    end;
  until ofs (tempvga^) = 0;
 drawto := @vga;
end.