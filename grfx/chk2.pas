program checkers2;
uses vgastuff,crtstuff,crt;

var
 x, y, z : integer;
 ox, oy : integer;
 r,g,b,ro,go,bo : byte;

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


begin
 setmode( $13 );
 ox := 0;
 oy := 0;
 for z := 1 to 10 do
  begin
   setcolor( z, 63-(z*3), 63-(z*3), 0 );
   setcolor( z+10, 0, 0, 33+(z*3) );
  end;
 for x := 0 to 16 do
 for y := 0 to 18 do
 for z := 1 to 10 do
  if odd( y ) then
   begin
    drawline( (x * 20) + ox, y * 10 + oy+z, (x*20)+ox+9, y*10+oy+z, z+10 );
    drawline( (x * 20) + ox+10, y * 10 + oy+z, (x*20)+ox+19, y*10+oy+z, z );
   end
  else
   begin
    drawline( (x * 20) + ox, y * 10 + oy+z, (x*20)+ox+9, y*10+oy+z, z );
    drawline( (x * 20) + ox+10, y * 10 + oy+z, (x*20)+ox+19, y*10+oy+z, z+10 );
   end;
 getenter;
 x := 1;
 repeat
  getcolor( 20, ro, go, bo );
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  for z := 20 downto 2 do
   begin
    getcolor( z-1, r, g, b );
    setcolor( z, r, g, b );
   end;
   setcolor( 1, ro, go, bo );
 until enterpressed;
 setmode( 2 );
end.