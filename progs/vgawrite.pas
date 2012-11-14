Program VGAWrite;
uses vgastuff,crtstuff,crt;

procedure gumbella; external;
{$L gumbella}

procedure gurucel; external;
{$L gurucel}

const
 wx1 = 1;
 wy1 = 41;
 wx2 = 318;
 wy2 = 198;

var
 font : pointer;
 fseg, fofs : word;
 table : array[ 0..15, 0..3 ] of byte;

procedure gentable; { generates a table of bitmaps }
 var
  a, b : byte;
 begin
  for a := 0 to 15 do
   for b := 0 to 3 do
    if (a and power( 2, b )) <> 0 then table[a][3-b] := 1
     else table[a][3-b] := 0;
 end;

procedure init;
 begin
  gentable;
  font := @gumbella;
  fseg := seg(gumbella);
  fofs := ofs(gumbella);
  setmode( $13 );
  directvideo := false;
 end;

procedure vtextxyi( x, y : integer; i : byte; s : string );
 var
  m,c,e : byte;
  d : boolean;
 begin
  c := 1;
  while
   c <= length( s )
  do
   begin
    repeat
     d := cwcommandmode;
     if d then inc( c );
     cwrite( s[ c ] );
    until not cwcommandmode;
    if not d or cwcommandmode then
     begin
      m := mem[ fseg: fofs + ((ord( s[c] )) * 16)+i ];
      for e := 0 to 3 do
       tempvga^[yline[y]+ x + e ] := table[ m div $10][e] * tcolor;
      x := x + 4;
     for e := 0 to 3 do
        tempvga^[yline[y]+ x + e ] := table[ m mod $10][e] * tcolor;
      x := x + 4;
     end;
    inc( c );
   end;
 end;

procedure scrollup;
 var
  i : byte;
  w : integer;
 begin
  w := yline[wy2 - wy1];
  move( tempvga^[ yline[(wy1+1)] ], tempvga^[ yline[wy1] ], w );
  vga := tempvga^;
 end;

procedure vwriteln( s: string);
 var
  i : byte;
 begin
  for i := 0 to 15 do
   begin
    scrollup;
    vtextxyi( wx1, wy2, i, s );
   end;
 end;

Procedure HitAKey;
 var
   ch : char;
   tc : byte;
 begin
  tc := tcolor;
  vwriteln('|r(|R(|Y(|W Hit a Key|G! |Y)|R)|r)');
  While Keypressed do Ch := Readkey;
  Ch := Readkey;
  tcolor := tc;
 end;


procedure showcel;
 var
  p : ^byte;
  c : byte;
 begin
   p := @gurucel;
   for c := 1 to 32 do
    inc(word(p));
   for c := 0 to 255 do
     begin
      port[ $3c8 ] := c;
      port[ $3c9 ] := p^; {r}
      inc(word(p));
      port[ $3c9 ] := p^; {g}
      inc(word(p));
      port[ $3c9 ] := p^; {b}
      inc(word(p));
     end;
   for c := 1 to 69 do
    begin
     move( p^, tempvga^[yline[(wy1+50+c)]+100], 109);
     inc( word(p), 109 );
    end;
 end;


var
 t : text;
 b : byte;
 s : string[39];

begin
 init;
 drawto := tempvga;
 fillchar( tempvga^, 320*200, 0 );
 vgastuff.rectangle( wx1-1, wy1-1, wx2+1, wy2+1, 4 );
 showcel;
 vga := tempvga^;
 writeln('guys! This creeps, but check it out!');
 writeln;
 writeln(':) Hit ' + enter + '... ' );
 getenter;
 vWriteLn('|Wthis is an AUTOEXEC.BAT-lister by...');
 vwriteln('|b[|B[|WS|Ca|WBR|Ce|WN|B]|b]');
 vwriteln('|g─|G───────────────────────────|Y─|w');
 vga := tempvga^;
     assign( t, 'C:\AUTOEXEC.BAT' );
     reset( t );
     Repeat
       For B := 0 to 8 do
        If not EOF(T) then
         begin
           Readln(T,S);
           vwriteLn(S);
         end;
       HitAKey;
     Until Eof(T);
 getenter;
 setmode( 3 );
 cwriteln('|_|_|_|WThat|w''|Ws all|w, |Wfolks|w!');
 cwriteln('|_|C... |b[|B[|WS|Ca|WBR|Ce|WN|B]|b]');
end.