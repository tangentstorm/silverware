Unit Crtstuff;
Interface

{note: (1,1) is ALWAYS top left corner of a screen or window }


type
 _virtualarray = array[0..0] of byte;
 virtualarray = ^_virtualarray;

Const
{ boolean synonyms }
 Yes      = True;
 No       = False;
 On       = True;
 Fore     = True;
 Back     = False;
 Off      = False;

{ days of the week }
 days : array[ 0 .. 6 ] of string[ 3 ] =
        ('Sun','Mon','Tue','Wed','Thu','Fri','Sat');

{ color / symbols }
 bluebox  = $19B1;
 ccolors  : array [0..15] of char = 'kbgcrmywKBGCRMYW';
 ccolstr  : string = 'kbgcrmywKBGCRMYW';
 ccolset  = ['k','b','g','c','r','m','y','w',
              'K','B','G','C','R','M','Y','W'];
 digits = ['0','1','2','3','4','5','6','7','8','9'];

{ string constants }
 Enter      = 'Ù';
 BoNK       = '|WB|Go|WNK|Y!';
 Sterling   = '|KÄ|WS|wÅîâL³NG|KÄ';
 SilverWare = '|KÄ|WS|w³LVîâWêâî|KÄ';

{ cwrite commands }
 cwnotask     = $00;
 cwchangefore = $01;
 cwchangeback = $02;
 cwCR         = $03;
 cwBS         = $04;
 cwclrscr     = $05;
 cwclreol     = $06;
 cwgotoxy     = $07;
 cwgotox      = $08;
 cwgotoy      = $09;
 cwsavexy     = $0A;
 cwloadxy     = $0B;
 cwsavecol    = $0C;
 cwloadcol    = $0D;
 cwchntimes   = $0E;
 cwspecialstr = $0F;

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

Type
 ScreenType = array[  0..3999 ] of byte;          { 80x25 screen }
 BScreenType = array[ 0..7999 ] of byte;          { 80x50 screen }
 HScreenType = array[ 0..11615 ] of byte;         { 132x44 screen }
 VGAtype = array [ 0..319, 0..200 ] of byte;
 DChar = array[ 1..2 ] of char;                   { double char }
 LongStr = array[ 1 .. 3 ] of string;             { about 7 lines }
 Cel = array[ 0 .. 0 ] of byte;
 PCel = ^Cel;                                     { ^TextPicture }
 screentypeptr = ^screentype;

Var
 Screen : ScreenType absolute $B800:$0000;       { co80 screen  }
 MScreen : ScreenType absolute $B000:$0000;      { Mono Screen  }
 BScreen : BScreenType absolute $B800:$0000;     { ega43  vga50 }
 HScreen : HScreenType absolute $B800:$0000;     { screenmode51 }
 WriteTo : ScreenTypeptr;                        { Directs Writes }
 DOSscreen : screentype;                         { saved DOS screen }
 DOSxpos,                                        { saved xpos from DOS }
 DOSypos,                                        { saved ypos from DOS }
 tColor,                                         { CWrite color }
 sColor,                                         { saved tColor }
 tXpos,                                          { CWrite X pos }
 tYpos,                                          { CWrite Y pos }
 tXmin,                                          { CWrite X min }
 tYmin,                                          { CWrite Y min }
 tXmax,                                          { CWrite X max }
 tYmax,                                          { CWrite Y max }
 tXSav,                                          { saved tXpos }
 tYSav : byte;                                   { saved tYpos }
 CursorOn : boolean;                             { is cursor on? }
 CursorAttr : word;                              { cursorattribs }
 cwcommandmode : boolean;                        { cwrite command mode? }
 cwcurrenttask : byte;                           { cwrite current task? }
 cwnchexpected : byte;                           { cwrite #chars expected }
 cwchar,                                         { cwrite character }
 cwdigit1,                                       { 1st digit of n1 }
 cwdigit2,                                       { 2nd digit of n1 }
 cwdigit3,                                       { 1st digit of n2 }
 cwdigit4 : char;                                { 2nd digit of n2 }

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
 Function Boolchar( bool: boolean; t, f : char ) : Char;

{ þ screen/window handling commands }
 procedure setmode( mode : word );
 procedure fillscreen( atch : word ); {ATTR then CHAR}
 procedure fillbox( a1, b1, a2, b2 : byte; atch : word );
 procedure slidedown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure slidedownoff( offwhat : screentypeptr );
 procedure scrollup1( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrolldown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrolldownoff( offwhat : screentypeptr );
 procedure scrollright(  x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrollrightoff( offwhat : screentypeptr );

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
 function cpadstr( s : string; len : byte; ch : char ) : string;

{ þ number/conversion commands }
 function min( p, q : longint ) : longint;
 function max( p, q : longint ) : longint;
 function inc2( goesto, amt, max : longint ) : longint;
 function dec2( from, amt, min : longint ) : longint;
 function incwrap( goesto, amt, min, max : longint ) : longint;
 function decwrap( from, amt, min, max : longint ) : longint;
 function stepwrap( x, amt, min, max : longint ) : longint;
 function h2s( w : word ) : string;
 function s2h( s : string ) : word;
 function n2s( x : longint ) : string;
 function s2n( s : string ) : longint;
 function truth( p : longint ) : byte;
 function power( a, b : longint ) : longint;
 function sgn( x : longint ) : shortint;

{ þ ascii graphics }
 procedure txtline( a, b, x, y, c : byte );
 procedure Rectangle( a, b, x, y, c : byte );
 procedure Bar( a, b, x, y, at: byte );
 procedure metalbar( a1, b1, a2, b2 : byte );
 procedure metalbox( a1, b1, a2, b2 : byte );
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
 procedure adl( cline : string );

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
   xcount, ycount : byte;
  begin
   case cn of
    cwchangefore:
     if s[1] in ccolset
      then tcolor := (tcolor and $F0) + pos( s[1], ccolors ) - 1;
    cwchangeback:
     if s[1] in ccolset
      then tcolor := (tcolor and $0F) + (pos( s[1], ccolors ) - 1) * 16;
    cwCR :
     begin
      tXpos := 1;
      typos := inc2( tYpos, 1, tYmax-tymin +2);
      if
       tYpos > tYmax - tymin + 1
      then
       begin
        scrollup1( txmin, txmax, tymin, tymax, writeto );
        tYpos := tYmax - tymin + 1;
        txpos := 1;
        cwrite('|%');
       end;
     end;
    cwBS :
     begin
      if
       tXpos <> 1
      then
       begin
        colorxy( txmin+tXpos - 1, tymin+tYpos, tColor, ' ' );
        dec( tXpos );
       end;
     end;
    cwclrscr :
     begin
      fillbox( txmin, tymin, txmax, tymax, tcolor*256 + 32 );
      txpos := 1;
      typos := 1;
     end;
    cwclreol :
      colorxy( txmin+txpos-1, tymin+typos-1,
               tcolor, chntimes( ' ', txmax-txpos+1 ) );
    cwsavecol :
     sColor := tColor;
    cwloadcol :
     tColor := sColor;
    cwchntimes :
     begin
      if length(s) <> 3 then exit;
      if (s[2] in digits) and (s[3] in digits) then
      cwrite( normaltext( chntimes( s[1], s2n(s[2]+s[3])) ));
     end;
    cwgotoxy :
     begin
      if length( s ) <> 4 then exit;
      if (s[1] in digits) and
         (s[2] in digits) and
         (s[3] in digits) and
         (s[4] in digits)
      then
       begin
        txpos := s2n( s[1]+s[2] );
        typos := s2n( s[3]+s[4] );
        gotoxy( txpos + txmin -1 , typos + tymin - 1 );
       end;
     end;
    cwsavexy :
     begin
      txsav := txpos;
      tysav := typos;
     end;
    cwloadxy :
     begin
      txpos := txsav;
      typos := tysav;
      gotoxy( txpos + txmin -1 , typos + tymin - 1 );
   end;
    cwspecialstr :
     case upcase(s[1]) of
      'P' : cwrite( thisdir );
      'D' : cwrite( stardate );
     end;
   end; { of case nc }
  end; { of cwcommand }

 procedure cwrite( s : string );
  var
   b : byte;
  procedure write( s : string );
   begin
    colorxy( tXmin+tXpos-1, tYmin+tYpos-1, tColor, s );
    inc( tXpos );
    if
     tXpos > tXmax-txmin+1
    then
     cwrite( #13 );
   end;
  begin
   b := 0;
   repeat
    inc( b );
    if
     not cwcommandmode
    then
     case s[b] of
      '|' : cwcommandmode := true;
      #13 : cwcommand( cwcr, '' );
      #08 : cwcommand( cwbs, '' );
      else write( s[b] );
     end
    else
     case cwcurrenttask of
      cwnotask : begin
                  case s[b] of
                   '|': write('|');
                   '_': begin
                         cwcommandmode := false;
                         cwrite(#13);
                        end;
                   '!': cwcurrenttask := cwchangeback;
                   '@': begin
                         cwcurrenttask := cwgotoxy;
                         cwnchexpected := 4;
                        end;
                   '#': begin
                         cwcurrenttask := cwchntimes;
                         cwnchexpected := 3;
                        end;
                   '$': begin
                         cwcommandmode := false;
                         cwcommand( cwclrscr, '' );
                        end;
                   '%': begin
                         cwcommandmode := false;
                         cwcurrenttask := cwnotask;
                         cwcommand( cwclreol, '' );
                        end;
                   '^': begin
                         cwcurrenttask := cwspecialstr;
                         cwnchexpected := 1;
                        end;
                   ')': cwcommand( cwsavecol, '' );
                   '(': cwcommand( cwloadcol, '' );
                   ']': cwcommand( cwsavexy, '' );
                   '[': cwcommand( cwloadxy, '' );
                   else
                    if s[b] in ccolset then cwcommand( cwchangefore, s[b] );
                  end;
                  if (cwcurrenttask = cwnotask) then cwcommandmode := false;
                 end;
      cwchangeback : begin
                      if
                       s[b] in ccolset
                      then
                       cwcommand( cwchangeback, s[b] );
                      cwcurrenttask := cwnotask;
                      cwcommandmode := false;
                     end;
      cwgotoxy : begin
                  case cwnchexpected of
                   4 : cwdigit1 := s[b];
                   3 : cwdigit2 := s[b];
                   2 : cwdigit3 := s[b];
                   1 : begin
                        cwcommandmode := false;
                        cwcurrenttask := cwnotask;
                        cwcommand( cwgotoxy,
                                   cwdigit1+cwdigit2+cwdigit3+s[b] );
                       end;
                  end;
                  dec( cwnchexpected );
                 end;
      cwchntimes : begin
                    case cwnchexpected of
                     3 : cwchar := s[b];
                     2 : cwdigit1 := s[b];
                     1 : begin
                          cwcommandmode := false;
                          cwcurrenttask := cwnotask;
                          cwcommand( cwchntimes, cwchar+cwdigit1+s[b] );
                         end;
                    end;
                    dec( cwnchexpected );
                   end;
      cwspecialstr : if cwnchexpected = 1 then
                     begin
                      cwcommandmode := false;
                      cwcurrenttask := cwnotask;
                      dec( cwnchexpected );
                      cwcommand( cwspecialstr, s[b] );
                     end;
     end;
   until b = length(s);
  gotoxy( txmin+txpos-1, tymin+typos-1 );
  textattr := tcolor;
 end;



 procedure cwriteln( s : string );
  begin
   cwrite( s + #13 );
  end;

 procedure cwritexy( a, b : byte; s : string );
  var
   c, d : byte;
  begin
   c := txpos;
   d := typos;
   txpos := a;
   typos := b;
   cwrite( s );
   txpos := c;
   typos := d;
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

 Function Boolchar( bool: boolean; t, f : char ) : Char;
  begin
   if bool then boolchar := t else boolchar := f;
  end;

{ þ screen/window handling commands }

 procedure setmode( mode : word );
  begin
   asm
    mov ax,Mode;
    int 10h
   end;
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

 procedure slidedown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
  var
   count, count2 : byte;
   thingy,offset,len : word;
  begin
   len := (x2-x1+1) * 2;
   for count :=  pred(y1) to pred(y2) do
    begin
     delay(10);
     offset := 160 * count + pred(x1);
     {first, slide old screen section down 1 line}
     for count2 := pred(y2) downto count do
      begin
       thingy := 160 * count2 + pred( x1 );
       move(  screen[ thingy - 160 ], screen[ thingy ], len );
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
  var
   count, count2 : byte;
   thingy,offset,len : word;
  begin
   x1 := pred(x1); x2 := pred(x2);
   y1 := pred(y1); y2 := pred(y2);
   len := (x2-x1+1) * 2;
   offset :=  160 * (y2-count+2) + x1 * 2;
   {first, slide old screen section up 1 line}
    for count2 := succ(y1) to y2 do
     begin
      thingy := (160 * count2) + (x1*2);
      move(  screen[ thingy ], screen[ thingy-160 ], len );
     end;
    {now, add the next line}
     if offwhat <> @screen then
      move( offwhat^[ offset ], screen[ (160*y1)+(x1*2) ], len );
    end;



 procedure scrolldown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
  var
   count, count2 : byte;
   thingy,offset,len : word;
  begin
   x1 := pred(x1); x2 := pred(x2);
   y1 := pred(y1); y2 := pred(y2);
   len := (x2-x1+1) * 2;
   for count :=  y1 to y2 do
    begin
     delay(10);
     offset :=  160 * (y2-count+2) + x1 * 2;
     {first, slide old screen section down 1 line}
     for count2 := y2 downto succ(y1) do
      begin
       thingy := (160 * count2) + (x1*2);
       move(  screen[ thingy-160 ], screen[ thingy ], len );
      end;
     {now, add the next line}
     move( offwhat^[ offset ], screen[ (160*y1)+(x1*2) ], len );
    end;
  end;

 procedure scrolldownoff( offwhat : screentypeptr );
  begin
   slidedown( 1, 80, 1, 25, offwhat );
  end;

 procedure scrollright(  x1, x2, y1, y2 : byte; offwhat : screentypeptr );
  var
   count, count2 : byte;
   thingy,offset,len : word;
  begin
   x1 := pred(x1); x2 := pred(x2);
   y1 := pred(y1); y2 := pred(y2);
   len := (x2-x1) * 2;
   for count := x1 to x2 do
    for count2 := y1 to y2 do
     begin
      thingy := (count2*160)+(x1*2);
      move( screen[ thingy ], screen[ thingy+2 ], len );
      move( offwhat^[ (count2*160)+(x2-count)*2 ], screen[ thingy ], 2 );
     end;
   end;

 procedure scrollrightoff( offwhat : screentypeptr );
  begin
   scrollright( 1, 80, 1, 25, offwhat );
  end;



{ þ string formatting commands }

 function clength( s : string ) : byte;
  var
   i,c : byte;
  begin
   c := 0;
   i := 1;
   while i <= length(s) do
    if
     s[ i ] = '|'
    then
     case s[i+1] of
      '@' : inc( i, 5 );
      '#' : inc( i, 4 );
      else inc( i, 2 );
     end
    else
     begin
      inc( c );
      inc( i );
     end;
   clength := c;
  end;

 function normaltext( s : string ) : string;
   var
    c : byte;
    t : string;
   begin
    t := '';
    for c := 1 to length( s ) do
     if
      s[c] = '|'
     then
      t := t + '|' + s[c]
     else
      t := t + s[c];
     normaltext := t;
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
    clength( s ) < n
   then
    insert( chntimes( ch, n-clength(s)), s, 1 );
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

 function cpadstr( s : string; len : byte; ch : char ) : string;
  begin
   if clength( s ) > len then s := strtrunc( s, len );
   while clength( s ) < len do s := s + ch;
   cpadstr := s;
  end;

{ þ number/conversion commands }

 function min( p, q : longint ) : longint;
  begin
   if p > q then min := q else min := p;
  end;

 function max( p, q : longint ) : longint;
  begin
   if p < q then max := q else max := p;
  end;

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

 function h2s( w : word ) : string;
  var
   h : string;
  begin
   h := '0123456789ABCDEF';
   h2s := '$' + h[ w shr 12 and $000F + 1 ] +
                h[ w shr  8 and $000F + 1 ] +
                h[ w shr  4 and $000F + 1 ] +
                h[ w mod 16 + 1 ];
  end;

 function s2h( s : string ) : word;
  var
   c : byte;
   v : word;
  begin
   v := 0;
   if s[ 1 ] = '$' then delete( s, 1, 1 );
   for c := 1 to length( s ) do
    begin
     v := v shl 4;
     case s[ 1 ] of
      '0'..'9' : v := v + ord( s[1] ) - 48;
      'A'..'F' : v := v + ord( s[1] ) - 55;  { ord('A') -55 = 10 }
     end;
     delete( s, 1, 1 );
    end;
   s2h := v;
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
    i, e : Integer;
  Begin
    val( s, i, e );
    if e <> 0 then s2n := 0 else s2n := i;
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

procedure txtline( a, b, x, y, c : byte );
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

procedure metalbar( a1, b1, a2, b2 : byte );
 var
  i, w, c  : byte;
  z : string;
 begin
  c := tcolor;
  w := a2 - a1 - 1;
  z := chntimes( ' ', w );
  cwritexy( a1, b1, '|W|!wÛ' + chntimes( 'ß', w ) + '|KÛ');
  for i := 2 to b2 - b1 do
   begin
    colorxy( a1, b1 + i, $7F ,'Û' + z );
    colorxy( a2, b1 + i, $78, 'Û' );
   end;
  cwritexy( a1, b2, '|W|!wÛ|K' + chntimes( 'Ü', w ) + '|KÛ');
  greyshadow(a1,b1+1,a2,b2+1);
  tcolor := c;
 end;

procedure metalbox( a1, b1, a2, b2 : byte );
 var
  i, w  : byte;
 begin
  w := a2 - a1 - 1;
  cwritexy( a1, b1, '|W~wÛ' + chntimes( 'ß', w ) + '|KÛ');
  for i := 1 to b2 - b1 - 1 do
   begin
    colorxy( a1, b1 + i, $7F ,'Û' );
    colorxy( a2, b1 + i, $78, 'Û' );
   end;
  cwritexy( a1, b2, '|W~wÛ|K' + chntimes( 'Ü', w ) + '|KÛ');
 end;



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
  if
   a2 < txmax-txmin+1
  then
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
  while (s[1] = ' ') and (length(s)>0 )do  delete(s,1,1);
  s := s + ' ';
  while (pos('  ',S) > 0) do delete( s, Pos( '  ', s ), 1 );
  for c := 1 to Index - 1 do delete( s, 1, pos( ' ', s ) );
  if (pos( ' ', s ) > 0) then j := pos( ' ', s ) else j := length(s);
  wordn := copy( s, 1, j-1 );
 end;

function nwords( s : string ) : byte;
 var
  c, n : byte;
 begin
  c := 1;
  n := 0;
  while
   wordn( s, c ) <> ''
  do
   begin
    inc( c );
    inc( n );
   end;
  nwords := n;
 end;

function time : string;
 var
  h, m, s, n : word;
  ampm : char;
 begin
  gettime( h, m, s, n );
  if h > 12 then ampm := 'p' else ampm := 'a';
  h := h mod 12;
  if h = 0 then h := 12;
  time := flushrt( n2s( h ), 2, '0' ) + ':' +
          flushrt( n2s( m ), 2, '0') + ampm + 'm';
 end;

function date : string;
 var
  y, m, d, w : word;
 begin
  getdate( y, m, d, w );
  date := flushrt( n2s( w ), 1, '0' ) +
          flushrt( n2s( m ), 2, '0' ) +
          flushrt( n2s( d ), 4, '0' ) +
          flushrt( n2s( y ), 4, '0' );
 end;

function stardate : string;  { Sat 1218.93 21:40:00 }
 var
  w,mo,d,y,h,mi,s,n: word;
  sdate : string;
 begin
  getdate( y, mo, d, w );
  gettime( h, mi, s, n );
  sdate := days[ w ] + ' ' +
              flushrt( n2s( mo ), 2, '0') +
              flushrt( n2s( d ), 2, '0') + '.' +
              copy( flushrt( n2s( y ), 4, '0'), 3, 5 ) + ' ' +
              flushrt( n2s( h ), 2, '0' ) + ':' +
              flushrt( n2s( mi ), 2, '0' )+ ':' +
              flushrt( n2s( s ), 2, '0' );
  stardate := sdate;
 end;


procedure error( msg : string );
 begin
  setmode( 3 );
  cwritexy( 1, 1, msg );
  halt( 1 );
 end;

function thisdir : string;
 var
  s : string;
 begin
   GetDir(0,s);
   thisdir := s;
 end;

function paramline : string;
 var
  i : byte;
  s : string;
 begin
  s := '';
  for i := 1 to paramcount do
  s := s + paramstr( i )+ ' ';
  paramline := s;
 end;

procedure adl( cline : string );
 Var
  DirInfo: Searchrec;
  SearchStr : String;
  Thing : Word;
  D : DirStr;
  na : NameStr;
  ex : extstr;
  pstr, N,E : String;
  T : DateTime;
  X,
  Wide,
  Pause,
  Hid,
  prgsonly : Boolean;
  TA,
  TA2 : Byte;
  C,
  C2,
  C3 : Integer;
  CD : string;
  Pchk : integer;
  S2 : string;
  nl : byte;

 Function LZ( w : Word ) : String;
  var
   s : String;
  begin
   Str( w:0, s );
   if
    length( s ) = 1
   then
    s := '0' + s;
   lz := s;
  end;

 Function LastPart( S : String ) : String;
  var
   counter : byte;
  begin
   s := '\' + s;
   counter := length( s );
   While
    S[counter] <> '\'
   do
    dec( counter, 1 );
   Delete( S, 0, counter+1 );
   Lastpart := S;
  end;

 Begin
  SearchStr := '';
  cwriteln('');
  cwriteln('');
  Thing := Directory;
  X := False;
  C := 0;
  C2 := 0;
  C3 := 0;
  Wide := False;
  Hid := False;
  Pause := False;
  GetDir(0,CD);
  pstr := '';
  if
   nwords( cline ) > 0
  then
   for
    pchk := 1 to nwords( cline )
   do
    pstr := pstr + ' ' + wordn( cline, pchk );
  If
   CD[length(cd)]='\'
  then
   Delete(CD,length(cd),1);
  If (pos('/?', pstr) > 0) or  (pos('/H', upstr(pstr)) > 0) then
   begin
    cwriteln('');
    Cwriteln('|!k|WA|wdvanced |WD|wir |WL|wister |B5|w.|B0 ' +
     '|K(|Wc|K)|w1994 '+SilverWare );
    Cwriteln('|K|#Ä73');
    CWrite('|Wxxxxxxxx |wxxx');
    stWriteLn(' Ä> regular file (generic text or binary)');
    CWrite('|Yxxxxxxxx |yxxx');
    StWriteLn(' Ä> executable program (*.com *.exe)');
    CWrite('|Gxxxxxxxx |gxxx');
    StWriteLn(' Ä> executable batch file (*.bat)');
    CWrite('|Mxxxxxxxx |mxxx');
    StWriteLn(' Ä> compressed file or archive (*.arj *.zip *.arc *.pak *.zoo)');
    CWrite('|Rxxxxxxxx |rxxx');
    StWriteLn(' Ä> graphics file (*.gif *.jpg *.gl *.fli *.pic *.bmp *.pcx)');
    CWrite('|Cxxxxxxxx |cxxx');
    StWriteLn(' Ä> source code (*.bas *.pas *.asm *.inc *.c *.h *.cpp *.lsp)');
    CWrite('|bxxxxxxxx xxx');
    StWriteLn(' Ä> hidden file of any type (must use /a option)');
    CWrite('|BXXXXXXXXXXX ');
    StWriteLn(' Ä> subdirectory');
    CWrite('|bXXXXXXXXXXX ');
    StWriteLn(' Ä> hidden subdirectory (with /a option)');
    Cwriteln('|K|#Ä73');
    StWRiteln('Switches (type after "ADL" from the command line):');
    Cwriteln('|K|#Ä73');
    StWriteln(' /a Ä> shows all files in the directory, including hidden files. ');
    StWriteln(' /w Ä> allows for a wider display of filenames.');
    StWriteln(' /p Ä> pauses after each screenful of information.');
    StWriteln(' /e Ä> show only executable files.');
    StWriteln(' /h Ä> this help screen.');
    Cwriteln('|K|#Ä73');
    exit;
   end;
  hid   := pos( '/A', upstr(pstr)) > 0;
  wide  := pos( '/W', upstr(pstr)) > 0;
  pause := pos( '/P', upstr(pstr)) > 0;
  prgsonly := pos( '/E', upstr(pstr)) > 0;
  If
   wordn( cline, 1) = ''
  then
   begin
    SearchStr := cd+'\'
   end
  else
   for
    Pchk := 1 to nwords( cline )
   do
    if
     pos( '/', wordn( cline, pchk )) = 0
    then
     SearchStr := wordn( cline, pchk);
  If
   SearchStr = ''
  then
   SearchStr := CD+'\';
  If
   Searchstr[Length(searchstr)] = ':'
  then
   begin
    getdir( ord(upcase(searchstr[1]))-ord('A')+1, searchstr );
    if searchstr[length(searchstr)] <> '\'
     then searchstr := searchstr + '\';
   end;
  {$I-}
  chdir( copy( searchstr , 1, length(searchstr)-1 ) );
  {$I+}
  If
   Searchstr[Length(searchstr)] = '\'
  then
   searchstr := searchstr + '*.*';
  Findfirst( SearchStr, Thing, DirInfo );
  s2 := Upstr( lastpart( SearchStr ) );
  If
   ( ( DirInfo.Attr = Directory ) and
   ( DirInfo.Name = s2 ) ) or
   ( Searchstr = '..' )
  then
   searchstr := searchstr + '\*.*';
  If
   Hid
  then
   Thing := Anyfile;
  Findfirst( SearchStr, Thing, DirInfo );
  Stwrite( 'Looking at : '+dnstr( SearchStr ) );
  cwriteln('');
  cwriteln('');
  nl := 4;
  While DosError = 0 do
   begin
    FSplit( DirInfo.Name, d, na, ex );
    n := na;
    e := ex;
    Delete( E, 1, 1 );
    n := dnstr( normaltext( n ) );
    e := dnstr( normaltext( e ) );
    If
     ( dirInfo.Attr and VolumeID <> 0 )
    then
     begin
      TColor := $08;
      cwrite( flushrt( DirInfo.Name, 12, ' ' ) );
      if
       (not wide)
      then
       if
        x
       then
        cwriteLn('    |B[|WVolume ID|B]')
      else
       cwrite('    |B[|WVolume ID|B]            ');
      C3 := 1;
     end
    else
     If
      ( DirInfo.Attr and Hidden ) <> 0
     then
      begin
       ta := 1;
       TColor := $01;
       if
        (dirInfo.Attr and Directory) <> 0
       then
        cwrite( flushrt( DirInfo.Name, 12, ' ' ))
       else
       cwrite( flushrt( N, 8, ' ' ) + ' ' + flushrt( E, 3, ' ' ) );
       if
        (not Wide)
       then
        if
         (dirinfo.Attr and Directory <> 0)
        then
         cwrite('    |B[|WDir|B]')
       else
        cwrite(' ' + flushrt( n2s( DirInfo.Size ), 8, ' ' ) );
       if
        not wide
       then
        If
         X
        then
         cWriteLn(' |B[|WHid|B]')
        else
         cwrite(' |B[|WHid|B]            ');
        if
         dirinfo.attr and directory <> 0
        then
         inc( c2, 1 )
        else
         inc( c, 1 );
      end
     else
      Case DirInfo.Attr of
       Directory :
        begin
         Ta := $09;
         TColor := $09;
         cwrite( flushrt( DirInfo.Name, 12, ' ' ) );
         if
          ( not wide )
         then
          if
           x
          then
           cwriteln('    |B[|WDir|B]')
          else cwrite('    |B[|WDir|B]                  ');
         Inc(C2,1);
        end;
       Else
        begin
         TA := $0F; TA2 := $07;
         if
          ( e = 'exe' ) or
          ( e = 'com' )
         then
           TA := $0E;
         if
          e = 'bat'
         then
          TA := LightGreen;
         if (ta = $0F) and prgsonly then ta := 0 else
         begin
          if
           ( e = 'zip' ) or
           ( e = 'arc' ) or
           ( e = 'lzh' ) or
           ( e = 'pak' ) or
           ( e = 'zoo' ) or
           ( e = 'arj' )
          then
           TA := $0D;
          if
           ( e = 'gif' ) or
           ( e = 'jpg' ) or
           ( e = 'gl'  ) or
           ( e = 'fli' ) or
           ( e = 'pic' ) or
           ( e = 'bmp' ) or
           ( e = 'pcx' )
          then
           TA := $0C;
          if
           ( e = 'bas' ) or
           ( e = 'pas' ) or
           ( e = 'asm' ) or
           ( e = 'inc' ) or
           ( e = 'c' ) or
           ( e = 'h' ) or
           ( e = 'cpp' ) or
           ( e = 'lsp' )
          then
           TA := $0B;
         end;
         Case TA of
          $0A : TA2 := $02;
          $0D : TA2 := $05;
          $0C : TA2 := $04;
          $0B : TA2 := $03;
          $0E : TA2 := $06;
         end;
         if ta <> 0 then
         begin
          TColor := TA;
          cwrite( flushrt( N, 8, ' ' ) );
          TColor := TA2;
          cwrite( flushrt( E, 4, ' ' ) );
          If
           Not Wide
          then
           begin
            TColor := TA;
            UnPacktime(DirInfo.Time,T);
            cwrite( ' ' + flushrt( n2s( DirInfo.Size ), 8, ' ' ) + ' ' );
            TColor := TA2;
            cwrite(LZ(T.Hour)+':'+LZ(T.Min));
            TColor := TA;
            If X then
             cwriteLn(' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+n2s(T.Year))
            else
             cwrite((' '+LZ(T.Month)+'/'+LZ(T.Day)+'/'+N2S(T.Year))+' ');
           end; { if not wide }
          Inc(c,1);
         end; { if ta <> 0 }
        end; { if ta <> 0 }
       end;  { case dirinfo }
      FindNext(DirInfo);
      if ta <> 0
      then
       begin
        TColor := $08;
        If
         Wide
        then
         if
          ((C + C2 + C3) mod 5 = 0)
         then
          cwriteln('')
         else cwrite( ' ³ ')
        else
         if
          (Not X)
         then
          cwrite('³ ');
        if
         txpos = 1
        then
         begin
          inc( nl );
          if (nl mod 22 = 0) and pause then hitakey;
         end;
        X := Not X;
       end;
      end;
  If
   txpos > 1
  then
  cwriteln('');
  cwriteln('');
  StWriteLn( N2S(C)+' file(s), '+N2s(c2)+' directories in this listing, '+
  N2S(DiskFree(0))+' bytes free.');
  Cwrite('|WA|wdvanced |WD|wir |WL|wister |B5|w.|B0 |K(|Wc|K)|w1994' + SilverWare );
  StWriteLn(' Type "ADL /h" for help.');
  {$I-}
  chdir(cd);
  {$I+}
 End; {of adl}



Begin
 DOSscreen := screen;
 DOSxpos := wherex;
 DOSypos := wherey;
 tColor := $000F;
 sColor := $000E;
 tXpos := wherex;
 tYpos := wherey;
 tXsav := 1;
 tYsav := 1;
 tXmin := 1;
 tYmin := 1;
 tXmax := 80;
 tYmax := 25;
 cwcommandmode := false;
 cwcurrenttask := cwnotask;
 cwnchexpected := 0;
 cursoron := false;
 cursorattr := lightred * 16 + ord('þ');
 If
  Lastmode in [BW40,BW80,Mono]
 then
  WriteTo := @MScreen
 else
  writeto := @Screen;
End.