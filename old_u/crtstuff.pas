unit Crtstuff;
interface uses num, cw, stri, dos, crt, fx
  {$IFDEF FPC}, fpcstuff, keyboard
  {$ENDIF};

{note: (1,1) is ALWAYS top left corner of a screen or window }

Const
{ boolean synonyms }
 Yes      = True;
 No       = False;
 On       = True;
 Fore     = True;
 Back     = False;
 Off      = False;

{ altkeys }
 alt16to25 : string = 'QWERTYUIOP';
 alt30to38 : string = 'ASDFGHJKL';
 alt44to50 : string = 'ZXCVBNM';

{ days of the week }
 days : array[ 0 .. 6 ] of string[ 3 ] =
        ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');

{ color / symbols }
 bluebox  = $19B1;
 ccolors  : array [0..15] of char = 'kbgcrmywKBGCRMYW';
 ccolstr  : string = 'kbgcrmywKBGCRMYW';
 ccolset  = ['k','b','g','c','r','m','y','w',
              'K','B','G','C','R','M','Y','W'];


{ string constants }
 Enter      = '┘';
 BoNK       = '|WB|Go|WNK|Y!';
 Sterling   = '|K─|WS|w┼εΓL│NG|K─';
 SilverWare = '|K─|WS|w│LVεΓWΩΓε|K─';

{ keyboard shift states }
 rshiftpressed  = $01;
 lshiftpressed  = $02;
 shiftpressed   = $03;
 ctrlpressed    = $04;
 altpressed     = $08;
 scrolllockon   = $10;
 numlockon      = $20;
capslockon     = $40;
 inserton       = $80;

type
 { double char }
 DChar	= array[ 1..2 ] of char;
 { about 7 lines }
 LongStr	= array[ 1 .. 3 ] of string;



  Function Boolchar( bool: boolean; t, f : char ) : Char;

{■ screen/window handling commands }
  
  // procedure setmode( mode : word );
  // procedure settextheight( h : byte );  }

{■ string formatting commands }

  function UpStr( s : string ) : String;
  function DnCase( ch : char ) : Char;
  function DnStr( s : string ) : String;
  function unpadstr( s : string; ch : char ) : string;

  // moved to stri.pas :
  { function chntimes( c : char; n : byte ) : string;  }
  { function flushrt( s : string; n : byte; ch : char ) : string; }
  { function padstr( s : string; len : byte; ch : char ) : string; }
  { function strtrunc( s : string; len : byte ) : string; }

{ ■ number/conversion commands  : moved to num.pas }
{────────────────────────────}
  { function min( p, q : longint ) : longint; }
  { function max( p, q : longint ) : longint; }
  { function inc2( goesto, amt, max : longint ) : longint; }
  { function dec2( from, amt, min : longint ) : longint; }
  { function incwrap( goesto, amt, min, max : longint ) : longint; }
  { function decwrap( from, amt, min, max : longint ) : longint; }
  { function stepwrap( x, amt, min, max : longint ) : longint; }
  { function h2s( w : word ) : string; }
  { function s2h( s : string ) : word; }
  { function n2s( x : longint ) : string; }
  { function s2n( s : string ) : longint; }
  { function truth( p : longint ) : byte; }
  { function power( a, b : longint ) : longint; }
  { function sgn( x : longint ) : shortint; }

{■ ascii graphics -> fx.pas }
{────────────────────────────}  
  { procedure txtline( a, b, x, y, c : byte ); }
  { procedure Rectangle( a, b, x, y, c : byte ); }
  { procedure Bar( a, b, x, y, at: byte ); }
  { procedure metalbar( a1, b1, a2, b2 : byte ); }
  { procedure metalbox( a1, b1, a2, b2 : byte ); }
  { procedure Button( a1, b1, a2, b2 : byte ); }
  { procedure greyshadow( a1, b1, a2, b2 : byte ); }
  { procedure blackshadow( a1, b1, a2, b2 : byte ); }

{ ■ thedraw graphics }
  procedure stamp( a1, b1, a2, b2 : byte; pic : pcel );

{ ■ screen savers }
  procedure rnd;
  procedure rnd2;

{ ■ misc other commands }
{────────────────────────────}
  procedure SetupCrt;
  procedure hitakey;
  procedure doscursoroff;
  procedure doscursoron;
  procedure doscursorbig;

{$IFNDEF FPC}
  procedure doscursorshape( top, bottom : byte );
  procedure blinking( b : boolean );
{$ENDIF}

  procedure getenter;
  function alt2normal( ch : char ) : char;
  function peekkey : char;  { doesn't work }
  function shiftstate : byte;
  function enterpressed : boolean;
  function yesno : Boolean;
  function wordn( s : string; index : byte ) : string;
  function nwords( s : string ) : byte;
  function time : string;
  function date : string;
  function stardate : string;
  procedure error( msg : string );
  function thisdir : string;
  function paramline : string;
  procedure installfont( fontseg, fontofs : word );
  procedure installfont2( fontseg, fontofs : word );
  procedure loadfont(s: string);
  procedure SetWidth90;

{$IFDEF FPC}
  function keypressed: boolean;
  function readkey: char;
{$ENDIF}

{────────────────────────────}
  
implementation

  { origin: 0,0 }
  procedure setScreenData( x, y : byte; ch : char; attr : byte );
    var p : integer;
  begin
    p := 2 * (( y * sw ) + x );
    if p < sizeOf(WriteTo^) then
    begin
      WriteTo^[ p ] := byte(ch);
      WriteTo^[ p + 1 ] := attr;
    end
  end;


  function Boolchar( bool: boolean; t, f : char ) : Char;
  begin
    if bool then boolchar := t else boolchar := f;
  end;

{ ■ screen/window handling commands }
  {
    procedure setmode( mode : word );
  begin
    asm
    mov ax,Mode;
    int 10h
   end;
  end;
    }
  procedure settextheight( h : byte );
  begin
    { this just screws up the screen in xp, even in full screen }
    { you wind up with giant gaps between the letters }
    { portw[$3D4] := h * 256 + 9; }
  end;
  
  procedure FillScreen( atch : word ); {ATTR then CHAR}
    var count : word; a : byte; s : string;
  begin
    a := hi( atch );
    s := chntimes( chr( lo( atch )), 80 );
    for count := 1 to 25 do colorxy( 1, count, a, s );
  end;

  procedure fillbox( a1, b1, a2, b2 : byte; atch : word );
    var count : word; a : byte; s : string;
  begin
    a := hi( atch );
    s := chntimes( chr( lo( atch )), a2-a1 + 1);
    For count := b1 to b2 do
      colorxy( a1, count, a, s );
  end;

  procedure slidedown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
    var count, count2 : byte; thingy, offset, len : word;
  begin
    len := (x2-x1+1) * 2;
    for count :=  pred(y1) to pred(y2) do
    begin
      delay(10);
      offset := sw * count + pred(x1);
      {first, slide old screen section down 1 line}
      for count2 := pred(y2) downto count do
      begin
	thingy := sw * count2 + pred( x1 );
	move(  screen[ thingy - sw ], screen[ thingy ], len );
      end;
      {now, add the next line}
      move( offwhat^[ offset ], screen[ offset ], len );
    end;
  end;

  procedure slidedownoff( offwhat : screentypeptr );
  begin
    slidedown( 1, 80, 1, 25, offwhat );
  end;

  procedure scrollup1( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
    var  count : byte; offset,len : word;
  begin
    dec( x1 ); dec( x2 ); dec( y1 ); dec( y2 );
    len := (x2-x1+1) * 2;
    offset := ( y1 * sw + x1 * 2);
    {first, slide old screen section up 1 line}
    for count := 1 to (y2-y1) do
    begin
      move(writeto^[offset+sw], writeto^[offset], len);
      inc(offset, sw);
    end;
    {now, add the next line}
    if offwhat <> nil then
      move( offwhat^[ (sw*y2)+(x1*2) ], writeto^[ (sw*y2)+(x1*2) ], len );
  end;

  procedure scrolldown1( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
    var count : byte; offset,len : word;
  begin
    dec( x1 ); dec( x2 ); dec( y1 ); dec( y2 );
    len := (x2-x1+1) * 2;
    offset :=  sw * y2 + x1 * 2;
    {first, slide old screen section down 1 line}
    for count := pred(y2) downto y1 do
    begin
      move(writeto^[offset-sw], writeto^[offset], len);
      dec(offset, sw);
    end;
    {now, add the next line}
    if offwhat <> nil then
      move( offwhat^[ (sw*y1)+(x1*2) ], writeto^[ (sw*y1)+(x1*2) ], len );
  end;


  procedure scrolldown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
    var count, count2 : byte; thingy,offset,len : word;
  begin
    x1 := pred(x1); x2 := pred(x2);
    y1 := pred(y1); y2 := pred(y2);
    len := (x2-x1+1) * 2;
    for count :=  y1 to y2 do
    begin
      delay(10);
      offset :=  sw * (y2-count+2) + x1 * 2;
      {first, slide old screen section down 1 line}
      for count2 := y2 downto succ(y1) do begin
	thingy := (sw * count2) + (x1*2);
	move(  screen[ thingy-sw ], screen[ thingy ], len );
      end;
      {now, add the next line}
      move( offwhat^[ offset ], screen[ (sw*y1)+(x1*2) ], len );
    end;
  end;

  procedure scrolldownoff( offwhat : screentypeptr );
  begin
    slidedown( 1, 80, 1, 25, offwhat );
  end;

  procedure scrollright(  x1, x2, y1, y2 : byte; offwhat : screentypeptr );
    var count, count2 : byte; thingy, offset, len : word;
  begin
    x1 := pred(x1); x2 := pred(x2);
    y1 := pred(y1); y2 := pred(y2);
    len := (x2-x1) * 2;
    for count := x1 to x2 do
      for count2 := y1 to y2 do
      begin
	thingy := (count2*sw)+(x1*2);
	move( screen[ thingy ], screen[ thingy+2 ], len );
	move( offwhat^[ (count2*sw)+(x2-count)*2 ], screen[ thingy ], 2 );
      end;
  end;

  procedure scrollrightoff( offwhat : screentypeptr );
  begin scrollright( 1, 80, 1, 25, offwhat );
  end;

  function strtrunc( s : string; len : byte ) : string; inline;
  begin result := stri.trunc( s, len );
  end;

  function upstr( s : string ) : string;
    var count : byte;
  begin
    for count := 1 to length( s ) do
      s[ count ] := upcase( s[ count ] );
    upstr := s;
  end;

  function dncase( ch: char ) : char;
  begin
    if ( 'A' <= ch ) and ( ch <= 'Z' )
      then dncase := chr( ord( ch ) + 32 )
      else dncase := ch;
  end;

  function dnstr( s : string ) : string;
    var count : Byte;
  begin
    for count := 1 to length( s ) do
      s[ count ] := dncase( s[ count ] );
    dnstr := s;
  end;

  function chntimes( c : char; n : byte ) : string; inline;
  begin result := stri.chntimes( c, n );
  end;

  function flushrt( s : string; n : byte; ch : char ) : string; inline;
  begin result := stri.flushrt( s, n, ch );
  end;

  function padstr( s : string; len : byte; ch : char ) : string; inline;
  begin result := stri.pad( s, len, ch );
  end;

  function unpadstr( s : string; ch : char ) : string;
  begin
    while s[ length( s ) ] = ch do dec( byte( s[ 0 ] ));
    unpadstr := s;
  end;


{ ■ number/conversion commands }

  function min( p, q : longint ) : longint; inline;
  begin result := num.min( p, q )
  end;

  function max( p, q : longint ) : longint; inline;
  begin result := num.max( p, q )
  end;

  function Inc2( goesto, amt, max : longint ) : longint; inline;
  begin result := num.inc2( goesto, amt, max )
  end;

  function dec2( from, amt, min : longint ) : longint; inline;
  begin result := num.dec2( from, amt, min )
  end;

  function incwrap( goesto, amt, min, max : longint ) : longint; inline;
  begin result := num.incwrap( goesto, amt, min, max );
  end;

  function decwrap( from, amt, min, max : longint ) : longint; inline;
  begin result := num.decwrap( from, amt, min, max );
  end;

  function stepwrap( x, amt, min, max : longint ) : longint; inline;
  begin result := num.stepwrap( x, amt, min, max );
  end;

  function h2s( w : word ) : string; inline;
  begin result := num.h2s( w );
  end;

  function s2h( s : string ) : word; inline;
  begin result := num.s2h( s );
  end;

  function n2s( x : longint ) : string; inline;
  begin result := num.n2s( x );
  end;

  function s2n( s : String ) : longint; inline;
  Begin result := num.s2n( s )
  End;

  function truth( p : longint ) : byte; inline;
  begin result := num.truth( p );
  end;

  function power( a, b : longint ) : longint; inline;
  begin result := num.power( a, b );
  end;

  function sgn( x : longint ) : shortint; inline;
  begin result := num.sgn( x );
  end;

{ ■ ascii graphics }

  procedure txtline( a, b, x, y, c : byte );
  begin
    if a = x then
      colorxyv( a, b, c, stri.ntimes( '│',  y - b + 1 ) )
    else if b = y then
      colorxy( a, b, c, stri.ntimes( '─', x - a + 1 ) );
 end;

  procedure Rectangle( a, b, x, y, c : byte);
    var count : byte;
  begin
    for count := a + 1 to x - 1 do
    begin
      ColorXY( count, b, c, '─' );
      ColorXY( count, y, c, '─' );
    end;
    for count := B+1 to Y-1 do
    begin
      ColorXY( a, count, c, '│' );
      ColorXY( x, count, c, '│' );
    end;
    ColorXY( a, b, c, '┌' );
    ColorXY( a, y, c, '└' );
    ColorXY( x, b, c, '┐' );
    ColorXY( x, y, c, '┘' );
  end;

  procedure Bar(a,b,x,y,at: byte);
    var cx,cy : byte;
  begin
    Rectangle(a,b,x,y, at);
    For cy := b +1  to y-1 do
      For cx := a +1 to x-1 do
	Colorxy(cx,cy,at,' ');
  End;

  procedure metalbar( a1, b1, a2, b2 : byte );
    var i, w, c  : byte; z : string;
  begin
    c := tcolor;
    w := a2 - a1 - 1;
    z := chntimes( ' ', w );
    cwritexy( a1, b1, '|W|!w█' + stri.ntimes( '▀', w ) + '|K█');
    for i := 2 to b2 - b1 do
    begin
      colorxy( a1, b1 + i, $7F ,'█' + z );
      colorxy( a2, b1 + i, $78, '█' );
    end;
    cwritexy( a1, b2, '|W|!w█|K' + stri.ntimes( '▄', w ) + '|K█');
    greyshadow(a1,b1+1,a2,b2+1);
    tcolor := c;
  end;

  procedure metalbox( a1, b1, a2, b2 : byte );
    var i, w  : byte;
  begin
    w := a2 - a1 - 1;
    cwritexy( a1, b1, '|W~w█' + stri.ntimes( '▀', w ) + '|K█');
    for i := 1 to b2 - b1 - 1 do
    begin
      colorxy( a1, b1 + i, $7F ,'█' );
      colorxy( a2, b1 + i, $78, '█' );
    end;
    cwritexy( a1, b2, '|W~w█|K' + stri.ntimes( '▄', w ) + '|K█');
  end;

  procedure Button(A1,B1,A2,B2 : byte);
    var Count : Byte;
  Begin
    Bar(A1,B1,A2,B2,$70);
    For Count := A1 to A2-1 do ColorXY(Count,B1,$7F,'─');
    For Count := B1 to B2-1 do ColorXY(A1,Count,$7F,'│');
    ColorXY(A1,B1,$7F,'┌');
    ColorXY(A1,B2,$7F,'└');
  End;


  procedure blackshadow( a1, b1, a2, b2 : byte );
  begin
    colorxy ( a1 + 1, b2 + 1, $0F, chntimes( ' ', a2 - a1 ) );
    colorxyv( a2 + 1, b1 + 1, $0F, chntimes( ' ', b2 - b1 + 1 ) );
  end;

  procedure stamp( a1, b1, a2, b2 : byte; pic : pcel );
    var h,i,w : byte;
  begin
    h := b2 - b1;
    w := a2 - a1;
    for i := 0 to h - 1 do
      move( pic^[ ( i * w * 2 ) ],
	   writeto^[(( b1 + i ) * sw ) + ( a1 * 2 )], w * 2 );
  end;

{ ■ screen savers }

  procedure rnd;
    var
      tmp : ScreenType;
      t	  : byte;
      ch  : char;
  begin
    tmp := screen;
    t := shiftstate;
    while keypressed do ch := readkey;
    repeat
      colorxy( random( 80 )+1, random( 50 ) +1, random( 15 )+1,
	      chr( random( 255 ) ) );
    until (keypressed) or (t <> shiftstate);
    while keypressed do ch := readkey;
    repeat until shiftstate and ( rshiftpressed or lshiftpressed or
				 ctrlpressed or altpressed ) = 0;
    screen := tmp;
  end;

  procedure rnd2;
    var
      tmp	 : screentype;
      t		 : byte;
      ch	 : char;
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

{ ■ misc other commands }

  Procedure SetUpCrt;
  Begin
    TextAttr := $0F;
    crt.textmode($03);
    DosCursorOff;
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

{$IFDEF FPC}
  procedure doscursoroff;
  begin
    crt.cursoroff;
  end;

  procedure doscursoron;
  begin
    crt.cursoron;
  end;

  procedure doscursorbig;
  begin
    crt.cursorbig;
  end;

{$ELSE}
  procedure doscursoroff;
  begin asm
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
  begin asm
    mov AH,$01;
    mov CH,Top;
    mov CL,Bottom;
    int 10h;
    end;
  end;

  procedure blinking( b : boolean );
  begin asm
    mov ah,$10;
    mov al,$03;
    mov bl,b;
    int 10h;
    end;
  end;
{$ENDIF}

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
      ch  : char;
  begin
    rgs.AH := $01;
    intr( $16, rgs );
    if rgs.flags and dos.FZero = 0 then
      peekkey := chr( rgs.al )
    else
      peekkey := #255;
  end;

{$IFDEF FPC}
  function shiftstate : byte;
    var e : keyboard.TKeyEvent;
  begin
    e := keyboard.pollShiftStateEvent;
    shiftstate := keyboard.GetKeyEventShiftState(e);
  end;
{$ELSE}
  function shiftstate : byte;
    var rgs : registers;
  begin
    rgs.AH := $02;
    intr( $16, rgs );
    shiftstate := rgs.al;
  end;
{$ENDIF}

  function enterpressed : boolean;
    var ch : Char;
  begin
    ch := ' ';
    if KeyPressed then
      ch := Readkey;
    enterPressed := ch = #13;
  end;

  function yesno : boolean;
  begin
    yesno := upcase( readkey ) = 'Y';
  end;

  function wordn( s : string; index:  byte ) : string;
    var c, c2, j : byte;
  begin
    while (s[1] = ' ') and (length(s)>0 )do  delete(s,1,1);
    s := s + ' ';
    while (pos('  ',S) > 0) do delete( s, Pos( '  ', s ), 1 );
    for c := 1 to Index - 1 do delete( s, 1, pos( ' ', s ) );
    if (pos( ' ', s ) > 0) then j := pos( ' ', s ) else j := length(s);
    wordn := copy( s, 1, j-1 );
  end;

  function nwords( s : string ) : byte;
    var c, n : byte;
  begin
    c := 1;
    n := 0;
    while wordn( s, c ) <> '' do
    begin
      inc( c );
      inc( n );
    end;
    nwords := n;
  end;

  function time : string;
    var h, m, s, n : word; ampm : char;
  begin
    gettime( h, m, s, n );
    if h > 12 then ampm := 'p' else ampm := 'a';
    h := h mod 12;
    if h = 0 then h := 12;
    time := flushrt( n2s( h ), 2, '0' ) + ':' +
	    flushrt( n2s( m ), 2, '0') + ampm + 'm';
  end;

  function date : string;
    var y, m, d, w : word;
  begin
    getdate( y, m, d, w );
    date := flushrt( n2s( w ), 1, '0' ) +
	    flushrt( n2s( m ), 2, '0' ) +
	    flushrt( n2s( d ), 4, '0' ) +
	    flushrt( n2s( y ), 4, '0' );
  end;

  function stardate : string;  { Sat 1218.93 12:40:00 }
    var
      w,mo,d,y,h,h2,mi,s,n : word;
  begin
    getdate( y, mo, d, w );
    gettime( h, mi, s, n );
    h2 := h mod 12;
    if h2 = 0 then h2 := 12;
    result := days[ w ] + ' ' +
	      flushrt( n2s( mo ), 2, '0') +
	      flushrt( n2s( d ), 2, '0') + '.' +
	      copy( flushrt( n2s( y ), 4, '0'), 3, 5 ) + ' ' +
	      flushrt( n2s( h2 ), 2, '0' ) + ':' +
	      flushrt( n2s( mi ), 2, '0' )+ ':' +
	      flushrt( n2s( s ), 2, '0' )+
	      boolchar( h < 12, 'a', 'p');
  end;


  procedure error( msg : string );
  begin
    crt.textmode( 3 );
    cwritexy( 1, 1, msg );
    halt( 1 );
  end;

  function thisdir : string;
    var s : string;
  begin
    GetDir(0,s);
    thisdir := s;
  end;

  function paramline : string;
    var
      i	: byte;
      s	: string;
  begin
    s := '';
    for i := 1 to paramcount do
      s := s + paramstr( i )+ ' ';
    paramline := s;
  end;

  procedure installfont( fontseg, fontofs : word );
  begin
   fontofs := fontofs + 16;
   (*  Asm;
     push    bp

     mov     si, 40h
     mov     es, si
     mov     ax, es:[ 60h ]
     push    ax                 // save old cursor style on stack

     mov     ax, fontseg
     mov     es, ax

     mov     ax, 1100h        // Load userdefined charset
     mov     bx, 1000h        // bh = bytes per char ( 10h ); bl = page ( 0h )
     mov     cx, 00FFh        // number of patterns
     mov     dx, 0001h        // dx = first char
     mov     bp, fontofs      // es:bp -> new char table
     int     10h              // install the new chars

     mov     ah, 12h
     mov     bh, 20h
     int     10h              // and set up the printscreen procedure

     mov     ax,0100h
     pop     cx               // get the old cursor style
     int     10h              // and restore it

     pop     bp               // restore bp
   end;
   *)
  end;
  procedure installfont2( fontseg, fontofs : word );
  begin // this was the same excetp for the bytes/char and page
  end;

  procedure loadfont( s : string );
    var
      f	: file;
      t	: array[ 1..4096 ] of byte;
  begin
    {$I-} assign( f, s ); reset( f,1 ); {$I+}
    if ioresult <> 0 then exit;
    blockread( f, t, 4096 );
    close( f );
    installfont(seg(t),ofs(t));
  end;


procedure SetWidth90;
  const
    Vga90 : array [1..9] of word = (
        $6B00,$5901,$5A02,$8E03,$6004,$8D05,$2D13,$0101,$0800);
begin
 {assembler;

asm
        mov     dx,03D4h
        mov     ax,02E11h
        out     dx,ax
        lea     si,[Vga90]
        mov     dx,03D4h
        mov     cx,7
        rep     outsw
        mov     dx,03C4h
        outsw
        lodsw
        mov     dx,03DAh
        in      al,dx
        mov     dx,03C0h
        mov     al,13h
        out     dx,al
        mov     al,ah
        out     dx,al
        mov     al,20h
        out     dx,al
        out     dx,al  }
end;

{$IFDEF FPC}
  function keypressed : boolean;
  begin
    keypressed := keyboard.pollKeyEvent <> 0;
  end;

  var readkeycache : char;
  function readkey : char;
    var
      e	 : keyboard.TKeyEvent;
      ch : char;
  begin
    if readkeycache <> #0 then
    begin
      readkey := readkeycache;
      readkeycache := #0
    end
    else
    begin
      e  := TranslateKeyEvent( GetKeyEvent );
      ch := GetKeyEventChar( e );
      if ch = #0 then
	readkeycache := chr( lo( GetKeyEventCode( e )))
    end;
    readkey := ch;
  end;

{$ENDIF}

begin
  sw := 160;
  new(dosScreen);
  DOSxpos := wherex;
  DOSypos := wherey;
  cursoron := false;
  cursorattr := lightred * 16; // + ord('■');
  WriteTo := @screen;
end.
