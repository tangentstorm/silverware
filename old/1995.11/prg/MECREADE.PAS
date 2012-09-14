program mecreader;
uses crtstuff, vgastuff, moustuff;

{$I mec.cur}

procedure sabrenfont; external;
{$L SABFNT}

var
 table : array[ 0..$F, 0..3 ] of byte;

procedure gentable( back, fore : byte );
 var
  a, b : byte;
 begin
  for a := 0 to $f do
   for b := 0 to 3 do
    begin
     if (power( 2, 3-b) and a) = 0 then table[ a ][ b ] := back
      else table[ a ][ b ] := fore;
    end;
 end;

procedure vwritexy( x,y: integer; font : pointer; s: string);
 var
  a, b, c : byte;
  fseg, fofs : word;
 begin
  fseg := seg( font^ );
  fofs := ofs( font^ );
  for b := 0 to 15 do
   for a := 0 to length( s )-1 do
    begin
     c := mem[ fseg: fofs + ((ord( s[a+1] )) * 16)+b ];
     move( table[ c div $10 ],  vga[ (y+b) * 320 + 4*(x+(a*2))], 4 );
     move( table[ c mod $10 ], vga[ (y+b) * 320 + 4*(x+(a*2))+4], 4 );
    end;
 end;


procedure init;
 var
  x, c : integer;
 begin
  setmode( $13 );
  setcolor( 1, 50, 50, 50 );
  setcolor( 2, 10, 10, 10 );
  setcolor( 3, 2, 3, 3 );
  setcolor( 4, 63, 63, 63 );
  setcolor( 5, 0, 0, 5 );
  setcolor( 6, 30, 0, 0 );
  setcolor( 7, 60, 60, 0 );
  for x := 0 to 180 do
   begin
    c := x mod 2 + 1;
    drawline( 0, 200-x, 160, 200, c );
    drawline( 320, 200-x, 160, 200, c );
    if x < 160 then
     begin
      drawline( 160, 200, x, 20, c );
      drawline( 160, 200, 320-x, 20, 3-c );
     end;
   end;
  gentable( 6, 7 );
  vwritexy( 5, 3, @sabrenfont, '      (Imagine some menus up here)   ');
  vgastuff.box( 152, 27, 302, 192, 3 );
  vgastuff.box( 150, 25, 300, 190, 4 );
  vgastuff.rectangle( 150, 25, 300, 190, 5 );
  gentable( 4, 5 );
  vwritexy( 120, 30, @sabrenfont, 'This would be a');
  vwritexy( 119, 50, @sabrenfont, 'SCROLLING* window');
  vwritexy( 119, 70, @sabrenfont, 'with smaller fonts');
  vwritexy( 119, 90, @sabrenfont, 'and several colors');
  vwritexy( 119,110, @sabrenfont, 'of text.');
  vwritexy( 119,145, @sabrenfont, '*with scroll bars');
  vwritexy( 119, 170, @sabrenfont, '( '+ enter+' quits )');
  mouseon;
  setmpos( 15, 10 );
  setgcurs( mec );
 end;

procedure run;
 var
  done : boolean;
 begin
  done := false;
  repeat
   getmpos;
   done := enterpressed;
   if not done then done := (ms and $02 <> 0);
  until done;
 end;

procedure shutdown;
 begin
  setmode( 3 );
  cwriteln('|$|wa |RParadox magazine|w reader by '+
   '|b[|B[|WS|Ca|WBR|Ce|WN|B]|b]|w.. (thanks)');
 end;

begin
 init;
 run;
 shutdown;
end.