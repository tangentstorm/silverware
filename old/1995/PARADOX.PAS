program paradox;
uses vgastuff, crtstuff, crt;

var x,y : integer;
type vgaptr = ^vgascreen;

procedure ploader; external;
{$L Ploader}

type
 bp = ^byte;

  var
    p : bp;
    c : byte;

begin
 cwriteln('|_|_|_|_|WLoading|B...');
 randomize;
 p := @ploader;
 inc(word(p),768);
 move( p^, tempvga^, sizeof( vgascreen ));
 for x := 0 to 319 do
  for y := 0 to 199 do
   if (tempvga^[(320 * y) + x] = 0)
    then tempvga^[(320 * y) + x] := 255-random( 64 );
 setmode($13);
   p := @ploader;
   for c := 0 to 255 do
     begin
      port[ $3c8 ] := c;
      port[ $3c9 ] := p^; {r}
      inc( word( p ));
      port[ $3c9 ] := p^; {g}
      inc( word( p ));
      port[ $3c9 ] := p^; {b}
      inc( word( p ));
     end;
  move( tempvga^, vga, sizeof(vgascreen) );
  repeat
   x := random ( 64 );
   setcolor(255-random( 64 ), x, x, x  );
  until enterpressed;
  setmode( 3 );
end.