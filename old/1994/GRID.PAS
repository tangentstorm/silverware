uses vgastuff,crtstuff,crt,sndstuff;


Type
 rgb = record
  r, g, b : byte;
 end;
 oneline = array[ 0..15 ] of rgb;
 checkers = array[ 0..7 ] of oneline;
 paltype = array[ 1..128 ] of rgb;
 halfline = array [ 0..7 ] of rgb;
 paltype2 = array[ 0 .. 16 ] of halfline;

const
 rgb1 : rgb = ( r:  0; g:  0; b: 55 );
 rgb2 : rgb = ( r: 63; g: 60; b: 60 );

var
 ch : char;
 currentline : byte;
 slidev,
 slideh : shortint;
 done : boolean;
 r, g, b, ro, go, bo, z : byte;
 x, y : integer;
 templine : oneline;
 grid : checkers;
 pal : paltype absolute grid;
 pal2 : paltype2 absolute grid;

procedure slideleft( var l : oneline );
 var
  i : byte;
  t : rgb;
 begin
  t := l[0];
  for i := 1 to 15 do
   l[ i-1 ] := l[ i ];
  l[15] := t;
 end;

procedure slideright( var l : oneline );
 var
  i : byte;
  t : rgb;
 begin
  t := l[15];
  for i := 15 downto 1 do
   l[ i ] := l[ i-1 ];
  l[0] := t;
 end;

procedure reverse( var l : oneline );
 var
  i : integer;
 begin
  for i := 0 to 15 do
   if (l[ i ].r = rgb1.r) and
      (l[ i ].r = rgb1.r) and
      (l[ i ].r = rgb1.r) then
   l[ i ] := rgb2 else l[i] := rgb1;
 end;

procedure slideup;
 begin
  currentline := incwrap( currentline, 1, 0, 7 );
  reverse( grid[ currentline ]);
 end;

procedure slidedown;
 begin
  reverse( grid[ currentline ]);
  currentline := decwrap( currentline, 1, 0, 7 );
 end;

procedure slide;
 var
  z : byte;
 begin
  case slideh of
   -1 : slidedown;
    1 : slideup;
  end;
  case slidev of
   -1 : for z := 0 to 7 do
         slideleft( grid[ z ] );
    1 : for z := 0 to 7 do
         slideright( grid[ z ] );
  end;
 end;

procedure showgrid;
 var
  i : byte;

 begin
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  for i := 1 to 128 do
   with pal[ i ] do
   setcolor( i, r, g, b );
 end;

begin
 setmode( $13 );
 loadpic( 'Grid.dat' );
  for y := 0 to 7 do
  for z := 0 to 7 do
   begin
    grid[ y ][ z ] := rgb1;
    grid[ y ][ z + 8 ] := rgb2;
   end;
 showgrid;
  spkr2.pop;

done := false;
slidev := 0;
slideh := 0;
currentline := 7;
repeat
 slide;
 showgrid;
 if keypressed then
  begin
   ch := readkey;
   if ch = #0 then ch := readkey else
   if ch in digits then
    case ch of
     '1' : begin slideh := 1;  slidev :=  1; end;
     '2' : begin slideh := 1;  slidev :=  0; end;
     '3' : begin slideh := 1;  slidev := -1; end;
     '4' : begin slideh := 0;  slidev :=  1; end;
     '5' : begin slideh := 0;  slidev :=  0; end;
     '6' : begin slideh := 0;  slidev := -1; end;
     '7' : begin slideh := -1; slidev :=  1; end;
     '8' : begin slideh := -1; slidev :=  0; end;
     '9' : begin slideh := -1; slidev := -1; end;
     else done := true;
   end;
  end;
until done;

 end.
 if keypressed then z := byte( readkey );
{ repeat until (port[$3da] and $08 ) = 0;
 repeat until (port[$3da] and $08 ) <> 0;
 getenter;
end.
 }
repeat
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  for z := 1 to 16 do
   begin
   end;
  getcolor( 1, ro, go, bo );
  for z := 2 to 128 do
   begin
    getcolor( z, r, g, b );
    setcolor( z-1, r, g, b );
   end;
   setcolor( 128, ro, go, bo );
 until enterpressed;
{ savepic( 'grid.dat' );}
 spkr2.beep;
end.
  repeat
  getcolor( 1, ro, go, bo );
  repeat until (port[$3da] and $08 ) = 0;  {r : 128 to 1, z-1, z}
  repeat until (port[$3da] and $08 ) <> 0; {l : 2 to 128, z, z-1}
  for z := 2 to 128 do
   begin
    getcolor( z, r, g, b );
    setcolor( z-1, r, g, b );
   end;
   delay(100 );
   setcolor( 128, ro, go, bo );
 until enterpressed;

 End.