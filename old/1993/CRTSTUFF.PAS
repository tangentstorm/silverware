Unit Crtstuff;
Interface

Const
{ boolean synonyms }
 Yes      = True;
 No       = False;
 On       = True;
 Fore     = True;
 Back     = False;
 Off      = False;

{ color / symbols }
 bluebox  = $19B1;
 ccolors  : array[ 0..15] of char = 'kbgcrmywKBGCRMYW';

{ string constants }
 Enter      = 'Ù';
 BoNK       = '|WB|Go|WNK|Y!';
 Sterling   = '|KÄ|WS|wÅîâL³NG|KÄ';
 SilverWare = '|KÄ|WS|w³LVîâWêâî|KÄ';

{ cwrite commands }
 cwchangefore = $00;
 cwchangeback = $01;
 cwCR         = $02;
 cwBS         = $03;
 cwclrscr     = $04;
 cwclreol     = $05;
 cwgotoxy     = $06;
 cwgotox      = $07;
 cwgotoy      = $08;
 cwsavexy     = $09;
 cwsavex      = $0A;
 cwsavey      = $0B;
 cursorset    = $0C;
 cwjustify    = $0D;
 cwstorecol   = $0E;
 cwrestorecol = $0F;

{ keyboard shift states }
 rshiftpressed  = $01;
 lshiftpressed  = $02;
 ctrlpressed    = $04;
 altpressed     = $08;
 scrolllockon   = $10;
 numlockon      = $20;
 capslockon     = $40;
 inserton       = $80;

Type
 ScreenType = array[  0..3999 ] of byte;          { 80x25 screen }
 BScreenType = array[ 0..7999 ] of byte;          { 80x50 screen }
 HScreenType = array[ 0..11615 ] of byte;         { 132x44 screen }
 DChar = array[ 1..2 ] of char;                   { double char }
 LongStr = array[ 1 .. 3 ] of string;             { about 7 lines }
 Cel = array[ 0 .. 0 ] of byte;
 PCel = ^Cel;                                     { ^TextPicture }

Var
 Screen : ScreenType absolute $B800:$0000;       { co80 screen  }
 MScreen : ScreenType absolute $B000:$0000;      { Mono Screen  }
 BScreen : BScreenType absolute $B800:$0000;     { ega43  vga50 }
 HScreen : HScreenType absolute $B800:$0000;     { screenmode51 }
 WriteTo : ^ScreenType;                          { Directs Writes }
 tColor,                                         { CWrite color }
 sColor,                                         { saved tColor }
 tXpos,                                          { CWrite X pos }
 tYpos,                                          { CWrite Y pos }
 tXmax,                                          { CWrite X max }
 tYmax,                                          { CWrite Y max }
 tXSav,                                          { saved tXpos }
 tYSav : byte;                                   { saved tYpos }
 CursorOn : boolean;                             { is cursor on? }
 CursorAttr : word;                              { cursorattribs }

{ þ string writing commands }
 procedure colorxy  ( a, b, c : byte; s : string );
 procedure colorxyv ( a, b, c : byte; s : string );
 procedure colorxyc ( a, b, c : byte; s : string );
 Procedure cwcommand( cn : byte; s : string );
 Procedure cwrite   ( s : string );
 Procedure cwriteln ( s : string );
 Procedure cwritexy ( a, b : byte; s : string );
 Procedure ccenterxy( a, b : byte; s : string );
 Procedure StWrite( s : string );
 Procedure StWriteln( s : string );
 Procedure StWritexy( a, b : byte; s : String );

{ þ screen/window handling commands }
 procedure scrollup;
 procedure fillscreen( atch : word ); {ATTR then CHAR}
 procedure fillbox( a1, b1, a2, b2 : byte; atch : word );

{ þ string formatting commands }
 function cLength( s : string ) : byte;                { length - color codes }
 function normaltext( s : string ) : string;
 function strtrunc( s : string; len : byte ) : string;
 function UpStr( s : string ) : String;
 function DnCase( ch : char ) : Char;
 function DnStr( s : string ) : String;
 function chntimes( c : char; n : byte ) : string;
 function flushrt( s : string; n : byte; ch : char ) : string;
 function padstr( s : string; len : byte; ch : char ) : string;
 function unpadstr( s : string; ch : char ) : string;

{ þ number/conversion commands }
 function inc2( goesto, amt, max : longint ) : longint;
 function dec2( from, amt, min : longint ) : longint;
 function incwrap( goesto, amt, min, max : longint ) : longint;
 function decwrap( from, amt, min, max : longint ) : longint;
 function stepwrap( x, amt, min, max : longint ) : longint;
 function n2s( x : longint ) : string;
 function s2n( s : string ) : longint;
 function truth( p : longint ) : byte;
 function power( a, b : longint ) : longint;
 function sgn( x : longint ) : shortint;

{ þ ascii graphics }
 procedure line( a, b, x, y, c : byte );
 procedure Rectangle( a, b, x, y, c : byte );
 procedure Bar( a, b, x, y, at: byte );
 procedure Button( a1, b1, a2, b2 : byte );
 procedure greyshadow( a1, b1, a2, b2 : byte );
 procedure blackshadow( a1, b1, a2, b2 : byte );
 procedure stamp( a1, b1, a2, b2 : byte; pic : pcel );

{ þ screen savers }
 procedure rnd;
 procedure rnd2;

{ þ misc other commands }
 procedure SetupCrt;
 procedure hitakey;
 procedure doscursoroff;
 procedure doscursoron;
 procedure doscursorbig;
 procedure doscursorshape( top, bottom : byte );
 procedure blinking( b : boolean );
 procedure getenter;
 function alt2normal( ch : char ) : char;
(* function peekkey : char; *) { doesn't work }
 function shiftstate : byte;
 function enterpressed : boolean;
 function yesno : Boolean;
 function wordn( s : string; index : byte ) : string;

Implementation

Uses
 Crt, Dos;

{ þ string writing commands }
 Procedure ColorXY( a, b, c : byte; s : string);
  Var
   count : word;
  Begin
   for count := 1 to length(s) do
    begin
     WriteTo^[(2*(A+Count-2))+((B-1)*160)  ] := Byte(s[count]);
     WriteTo^[(2*(A+Count-2))+((B-1)*160)+1] := c;
    end;
  End;

 Procedure Colorxyv( a, b, c : byte; s: string );
  Var
   count : word;
  Begin
   for count := 1 to length(s) do
    begin
     WriteTo^[(2*(A-1))+((B+count-2)*160)  ] := Byte(s[count]);
     WriteTo^[(2*(A-1))+((B+count-2)*160)+1] := c;
    end;
   End;

 procedure colorxyc( a, b, c : byte; s : string );
  begin
   colorxy( a + 1 - length( s ) div 2, b, c, s );
  end;

 procedure cwcommand( cn : byte; s : string );
  var
   ground : boolean;
  begin
   case cn of
    cwchangefore:
     case s[ 1 ] of
      'k' : tColor := ( tcolor and $F0 ) + $00;
      'b' : tColor := ( tcolor and $F0 ) + $01;
      'g' : tColor := ( tcolor and $F0 ) + $02;
      'c' : tColor := ( tcolor and $F0 ) + $03;
      'r' : tColor := ( tcolor and $F0 ) + $04;
      'm' : tColor := ( tcolor and $F0 ) + $05;
      'y' : tColor := ( tcolor and $F0 ) + $06;
      'w' : tColor := ( tcolor and $F0 ) + $07;
      'K' : tColor := ( tcolor and $F0 ) + $08;
      'B' : tColor := ( tcolor and $F0 ) + $09;
      'G' : tColor := ( tcolor and $F0 ) + $0A;
      'C' : tColor := ( tcolor and $F0 ) + $0B;
      'R' : tColor := ( tcolor and $F0 ) + $0C;
      'M' : tColor := ( tcolor and $F0 ) + $0D;
      'Y' : tColor := ( tcolor and $F0 ) + $0E;
      'W' : tColor := ( tcolor and $F0 ) + $0F;
     end; { of case s / cwchangefore }
    cwchangeback:
     case s[ 1 ] of
      'k' : tColor := ( tcolor and $0F ) + $00;
      'b' : tColor := ( tcolor and $0F ) + $10;
      'g' : tColor := ( tcolor and $0F ) + $20;
      'c' : tColor := ( tcolor and $0F ) + $30;
      'r' : tColor := ( tcolor and $0F ) + $40;
      'm' : tColor := ( tcolor and $0F ) + $50;
      'y' : tColor := ( tcolor and $0F ) + $60;
      'w' : tColor := ( tcolor and $0F ) + $70;
      'K' : tColor := ( tcolor and $0F ) + $80;
      'B' : tColor := ( tcolor and $0F ) + $90;
      'G' : tColor := ( tcolor and $0F ) + $A0;
      'C' : tColor := ( tcolor and $0F ) + $B0;
      'R' : tColor := ( tcolor and $0F ) + $C0;
      'M' : tColor := ( tcolor and $0F ) + $D0;
      'Y' : tColor := ( tcolor and $0F ) + $E0;
      'W' : tColor := ( tcolor and $0F ) + $F0;
     end;
    cwCR :
     begin
      tXpos := 1;
      typos := inc2( tYpos, 1, tYmax + 1 );
      if
       tYpos > tYmax
      then
       begin
        scrollup;
        tYpos := tYmax;
       end;
     end;
    cwBS :
     begin
      if
       tXpos <> 1
      then
       begin
        colorxy( tXpos - 1, tYpos, tColor, ' ' );
        dec( tXpos );
       end;
     end;
    cwclrscr :
     begin
      clrscr;
      txpos := 1;
      typos := 1;
     end;
    cwclreol :
     begin
      clreol;
     end;
    cwstorecol :
     sColor := tColor;
    cwrestorecol :
     tColor := sColor;
   end; { of case nc }
  end; { of cwcommand }

var
 ta  : byte;
 cwx,cwy : byte;

 procedure cwrite( s : string );
  var
   b : byte;
  procedure write( s : string );
   begin
    colorxy( tXpos, tYpos, tColor, s );
    inc( tXpos );
    if
     tXpos > tXmax
    then
     begin
      inc( tYpos );
      tXpos := 1;
     end;
   end;
  begin
   textattr := tcolor;
   b := 1;
   while b <= length(s) do
    begin
     case s[ b ] of
      '|' : begin cwcommand( cwchangefore, s[ b + 1 ] ); inc(b); end;
      '~' : begin cwcommand( cwchangeback, s[ b + 1 ] ); inc(b); end;
      '!' : cwcommand( cwstorecol, '' );
      '@' : cwcommand( cwrestorecol, '' );
      '#' : begin write( s[ b + 1 ] ); inc( b ); end;
      '$' : cwcommand( cwclreol, '' );
      #13 : cwcommand( cwcr, '' );
(*         #7 : cwcommand( cwDel, '' ) *)
      #08 : cwcommand( cwbs, '' );
      else write( s[b] );
     end; { case }
     inc( b );
    end; { while }
   gotoxy( txpos, typos );
 end;

 procedure cwriteln( s : string );
  begin
   cwrite( s + #13 );
  end;

 procedure cwritexy( a, b : byte; s : string );
  begin
   txpos := a;
   typos := b;
   cwrite( s );
  end;

 procedure ccenterxy( a, b : byte; s : string );
  begin
   cwritexy( a + 1 - clength( s ) div 2, b, s );
  end;

 Procedure StWrite(S: string);
  var
    counter : byte;
  begin
    for counter := 1 to Length(S) do
     begin
       case S[counter] of
        'a'..'z','A'..'Z',' ' : TColor := $0F;
        '0'..'9' : TColor := $09;
        '[',']','(',')','{','}','<','>','"' : TColor := $09;
        '°'..'ß' : TColor := $08;
        else TColor := $07;
       end;
       cwrite(s[counter]);
     end;
  end;

 procedure StWriteln( s : string );
  begin
   stwrite( s + #13 );
  end;

 procedure StWritexy( a, b : byte; s : string );
  begin
   txpos := a;
   typos := b;
   stwrite( s );
  end;


{ þ screen/window handling commands }

 procedure scrollup;
  begin
   move( Writeto^[ ( 2 * tXMax ) ], Writeto^[ 0 ], sizeof( Writeto^ ) - 2 * tXMax );
   colorxy( 1, tYMax, tColor, chntimes( ' ', tXMax ) );
  end;

 procedure FillScreen( atch : word ); {ATTR then CHAR}
  var
    count : word;
    a : byte;
    s : string;
  begin
   a := hi( atch );
   s := chntimes( chr( lo( atch )), 80 );
   For
    count := 1 to 25
   do
    colorxy( 1, count, a, s );
  end;

 procedure fillbox( a1, b1, a2, b2 : byte; atch : word );
  var
    count : word;
    a : byte;
    s : string;
  begin
   a := hi( atch );
   s := chntimes( chr( lo( atch )), a2-a1 + 1);
   For
    count := b1 to b2
   do
    colorxy( a1, count, a, s );
  end;

{ þ string formatting commands }

 function clength( s : string ) : byte;
  var
   i,c : byte;
  begin
   c := 0;
   i := 1;
   while i <= length(s) do
     case s[ i ] of
      '|' : inc(i,2);
      '~' : inc(i,2);
      '!' : inc( i );
      '@' : inc( i );
      '#' : begin inc( c ); inc( i,2 ); end;
      '$' : inc( i );
      #13 : inc( i );
      #08 : begin dec( c ); inc( i ); end;
      else begin inc( c ); inc( i ); end;
     end; { case }
   clength := c;
  end;

 function normaltext( s : string ) : string;
   var
    i,c : byte;
   begin
    c := 0;
    i := 1;
    while pos('#',S) > 0 do insert( '#', s, pos('#',S));
    while pos('!',S) > 0 do insert( '#', s, pos('!',S));
    while pos('|',S) > 0 do insert( '#', s, pos('|',S));
    while pos('~',S) > 0 do insert( '#', s, pos('~',S));
    while pos('@',S) > 0 do insert( '#', s, pos('@',S));
    while pos('$',S) > 0 do insert( '#', s, pos('$',S));
    normaltext := s;
  end;

 function strtrunc( s : string; len : byte ) : string;
  begin
   if ord( s[ 0 ] ) > len then s[ 0 ] := chr( len );
   strtrunc := s;
  end;

 function upstr( s : string ) : string;
  var
   count : byte;
  begin
   for count := 1 to length( s ) do
    s[ count ] := upcase( s[ count ] );
   upstr := s;
  end;

 function dncase( ch: char ) :char;
  begin
   if
    ( 'A' <= ch ) and ( ch <= 'Z' )
   then
    dncase := chr( ord( ch ) + 32 )
   else
    dncase := ch;
  end;

 function dnstr( s : string ) : string;
  var
   count : Byte;
  begin
   for count := 1 to length( s ) do
    s[ count ] := dncase( s[ count ] );
   dnstr := s;
   end;


 function chntimes( c : char; n : byte ) : string;
  var
   i : byte;
   s : string;
  begin
   s := '';
   if n <> 0 then for i := 1 to n do s := s + c;
   chntimes := s;
  end;

 function flushrt( s : string; n : byte; ch : char ) : string;
  begin
   if
    length( s ) < n
   then
    insert( chntimes( ch, n-length(s)), s, 1 );
   flushrt := s;
  end;

 function padstr( s : string; len : byte; ch : char ) : string;
  begin
   if length( s ) > len then s := strtrunc( s, len );
   while length( s ) < len do s := s + ch;
   padstr := s;
  end;

 function unpadstr( s : string; ch : char ) : string;
  begin
   while s[ length( s ) ] = ch do dec( byte( s[ 0 ] ));
   unpadstr := s;
  end;

{ þ number/conversion commands }

 function Inc2( goesto, amt, max : longint ) : longint;
  begin
   if
    goesto + amt <= max
   then
    Inc( goesto, amt )
   else
    goesto := max;
    inc2 := goesto;
  end;

 function dec2( from, amt, min : longint ) : longint;
  begin
   if
    from - amt >= min
   then
    dec( from, amt )
   else
    from := min;
    dec2 := from;
  end;

 function incwrap( goesto, amt, min, max : longint ) : longint;
  begin
   if
    goesto + amt <= max
   then
    Inc( goesto, amt )
   else
    goesto := min;
    incwrap := goesto;
  end;

 function decwrap( from, amt, min, max : longint ) : longint;
  begin
   if
    from - amt >= min
   then
    dec( from, amt )
   else
    from := max;
    decwrap := from;
  end;

 function stepwrap( x, amt, min, max : longint ) : longint;
  begin
   if
    x + amt <= max
   then
    if
     x + amt >= min
    then
     x := x + amt
    else
     x := max
   else
    x := min;
    stepwrap := x;
  end;

 function n2s( x : longint ) : string;
  var
   s : string;
  begin
   str( x, s );
   n2s := s;
  end;

 function s2n( s : String ) : longint;
  var
    i, d : Integer;
  Begin
    val( s, i, d );
    s2n := i;
  End;

 function truth( p : longint ) : byte;
  begin
   if
    boolean( p )
   then
    truth := 1
   else
    truth := 0;
  end;

 function power( a, b : longint ) : longint;
  var
   c, d : longint;
  begin
   d := 1;
   if
    b > 0
   then
    for c := 1 to b do
     d := d * a;
   power := d;
  end;

function sgn( x : longint ) : shortint;
 begin
  if x > 0 then sgn :=  1;
  if x = 0 then sgn :=  0;
  if x < 0 then sgn := -1;
 end;

{ þ ascii graphics }

procedure line( a, b, x, y, c : byte );
 begin
  if
   a = x
  then
   colorxyv( a, b, c, chntimes( '³',  y - b + 1 ) )
  else
   if
    b = y
   then
    colorxy( a, b, c, chntimes( 'Ä', x - a + 1 ) );
 end;

Procedure Rectangle( a, b, x, y, c : byte);
 var
  count : byte;
 begin
  for count := a + 1 to x - 1 do
   begin
    ColorXY( count, b, c, 'Ä' );
    ColorXY( count, y, c, 'Ä' );
   end;
  for count := B+1 to Y-1 do
   begin
    ColorXY( a, count, c, '³' );
    ColorXY( x, count, c, '³' );
   end;
  ColorXY( a, b, c, 'Ú' );
  ColorXY( a, y, c, 'À' );
  ColorXY( x, b, c, '¿' );
  ColorXY( x, y, c, 'Ù' );
 end;

Procedure Bar(a,b,x,y,at: byte);
  Var
    cx,cy : byte;
  Begin
    Rectangle(a,b,x,y, at);
    For cy := b +1  to y-1 do
      For cx := a +1 to x-1 do
        Colorxy(cx,cy,at,' ');
  End;


Procedure Button(A1,B1,A2,B2 : byte);
 Var
  Count : Byte;
 Begin
  Bar(A1,B1,A2,B2,$70);
  For Count := A1 to A2-1 do ColorXY(Count,B1,$7F,'Ä');
  For Count := B1 to B2-1 do ColorXY(A1,Count,$7F,'³');
  ColorXY(A1,B1,$7F,'Ú');
  ColorXY(A1,B2,$7F,'À');
 End;

procedure greyshadow( a1, b1, a2, b2 : byte );
 var
  i, w, h : byte;
 begin
  w := a2 - a1;
  h := b2 - b1;
  for
   i := 1 to w
  do
   writeto^[ (a1 + i) * 2 - 1 + (b2 * 160) ] := $08;
  for
   i := 0 to h
  do
   writeto^[ (a2 * 2) + 1 + ( b1 + i ) * 160 ] := $08;
 end;

procedure blackshadow( a1, b1, a2, b2 : byte );
 begin
  colorxy ( a1 + 1, b2 + 1, $0F, chntimes( ' ', a2 - a1 ) );
  colorxyv( a2 + 1, b1 + 1, $0F, chntimes( ' ', b2 - b1 + 1 ) );
 end;

procedure stamp( a1, b1, a2, b2 : byte; pic : pcel );
 var
  h,i,w : byte;
 begin
  h := b2 - b1;
  w := a2 - a1;
  for i := 0 to h - 1 do
    move( pic^[ ( i * w * 2 ) ], writeto^[(( b1 + i ) * 160 ) + ( a1 * 2 )], w * 2 );
 end;

{ þ screen savers }

procedure rnd;
 var
  tmp : screentype;
  t  : byte;
  ch : char;
 begin
  tmp := screen;
  t := shiftstate;
  while keypressed do ch := readkey;
  repeat
   colorxy( random( 80 )+1, random( 25 ) +1, random( 15 )+1,
            chr( random( 255 ) ) );
  until (keypressed) or (t <> shiftstate);
  while keypressed do ch := readkey;
  repeat until shiftstate and ( rshiftpressed or lshiftpressed or
                                ctrlpressed or altpressed ) = 0;
  screen := tmp;
 end;

procedure rnd2;
 var
  tmp : screentype;
  t : byte;
  ch : char;
  x, y, w, c : word;
 begin
  tmp := screen;
  t := shiftstate;
  y := 0;
  x := 0;
  w := 2;
  c := 0;
  while keypressed do ch := readkey;
  repeat
   inc( c ); if c = 100 then begin c := 1; y := y + 1; x := x + 1; end;
   if x > 80 - w then x := 0;
   if y > 25 - w then y := 0;
   colorxy( random( w ) + x, random( 25 ) + 1, random( 15 ) + 1,
            chr( random( 256 ) ));
   colorxy( random( 80 )+1, random( w div 2 ) + y, random( 15 ) + 1,
            chr( random( 256 ) ));
   colorxy( 80 - ( random( w ) + x ), random( 25 ) + 1, random( 15 ) + 1,
            chr( random( 256 ) ));
   colorxy( random( 80 )+1, 25 - ( random( w div 2 ) + y), random( 15 ) + 1,
            chr( random( 256 ) ));
  until (keypressed) or (t <> shiftstate);
  while keypressed do ch := readkey;
  repeat until shiftstate and ( rshiftpressed or lshiftpressed or
                                ctrlpressed or altpressed ) = 0;
  screen := tmp;
 end;


{ þ misc other commands }

Procedure SetUpCrt;
 Begin
  DosCursorOff;
  TextAttr := $0F;
  ClrScr;
  txpos := 1;
  typos := 1;
 End;

Procedure HitAKey;
 var
   ch : char;
   tc : byte;
 begin
  tc := tcolor;
  cwrite('|r(|R(|Y(|W Hit a Key|G! |Y)|R)|r)');
  While Keypressed do Ch := Readkey;
  Ch := Readkey;
  cwrite('');
  txpos := 1;
  tcolor := tc;
 end;


procedure doscursoroff;
  Begin
   asm
     mov ah, $01;
     mov ch, $FF;
     mov cl, $FF;
     int 10h
   end;
  end;

procedure doscursoron;
 begin
  doscursorshape( 7, 8 );
 end;

procedure doscursorbig;
 begin
  doscursorshape( 1, 8 );
 end;

procedure doscursorshape( top, bottom :  byte );
 begin
  asm
   mov AH,$01;
   mov CH,Top;
   mov CL,Bottom;
   int 10h;
  end;
 end;

procedure blinking( b : boolean );
 begin
  asm
   mov ah,$10;
   mov al,$03;
   mov bl,b;
   int 10h;
  end;
 end;

procedure getenter;
 begin
  repeat until enterpressed;
 end;

function alt2normal( ch : char ) : char;
 const
  set1 : string = 'QWERTYUIOP';
  set2 : string = 'ASDFGHJKL';
  set3 : string = 'ZXCVBNM';
  set4 : string = '1234567890-=';
 begin
  case ord( ch ) of
   16..25   : alt2normal:= set1[ ord( ch ) -  15 ];
   30..38   : alt2normal:= set2[ ord( ch ) -  29 ];
   44..50   : alt2normal:= set3[ ord( ch ) -  43 ];
   120..131 : alt2normal:= set4[ ord( ch ) - 119 ];
   else alt2normal := #255;
  end; { case }
 end;

function peekkey : char;
 var
  rgs : registers;
  ch : char;
 begin
  rgs.AH := $01;
  intr( $16, rgs );
  if
   rgs.flags and dos.FZero = 0
  then
   peekkey := chr( rgs.al )
  else
   peekkey := #255;
 end;

function shiftstate : byte;
 var
  rgs : registers;
 begin
  rgs.AH := $02;
  intr( $16, rgs );
  shiftstate := rgs.al;
 end;

function enterpressed : boolean;
 var
  ch : Char;
 begin
  ch := ' ';
  if
   KeyPressed
  then
   ch := Readkey;
  enterPressed := ch = #13;
 end;

function yesno : boolean;
 begin
  yesno := upcase( readkey ) = 'Y';
 end;

function wordn( s : string; index:  byte ) : string;
 var
  c, c2, j : byte;
 begin
  while
   s[1] = ' '
  do
   delete(s,1,1);
  s := s + ' ';
  if
   pos('  ',S) > 0
  then
   delete( s, Pos( '  ', s ), 1 );
  for
   c := 1 to Index -1
  do
   begin
    for
     c2 := 1 to pos( ' ', s )
    do
     delete(s,1,1);
   end;
  if
   pos( ' ', s ) > 0
  then
   j := pos( ' ', s )
  else
   j := length(s);
  wordn := copy( s, 1, j );
 end;

Begin
 tColor := $000F;
 sColor := $000E;
 tXpos := wherex;
 tYpos := wherey;
 tXsav := 1;
 tYsav := 1;
 tXmax := 80;
 tYmax := 25;
 cursoron := false;
 cursorattr := lightred * 16 + ord('þ');
 If
  Lastmode in [BW40,BW80,Mono]
 then
  WriteTo := @MScreen
 else
  writeto := @Screen;
End.