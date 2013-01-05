program static;
uses vgastuff, crtstuff, crt;

var x,y : integer;

begin
 checkbreak := false;
 randomize;
 setmode($13);
 for x := 1 to 64 do setcolor( x, 0, 0, 0 );
 for x := 1 to 320 do
  for y := 1 to 200 do
   vga[ y*320 + x] := random( 64 )+1;
 if paramcount = 0 then
  repeat
   x := random ( 64 );
   setcolor(random( 64 )+1, x, x, x  );
  until enterpressed
 else
  repeat
   sound(random( $FFF ) + 500 );
   x := random ( 64 );
   setcolor(random( 64 )+1, x, x, x  );
  until enterpressed;
 nosound;
 setmode(3);
end.