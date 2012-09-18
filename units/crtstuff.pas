Unit Crtstuff;
Interface
{$IFDEF FPC}
uses dos, crt, fpcstuff, keyboard; { TODO video }
{$ELSE}
uses dos, crt;
{$ENDIF}

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
 cwrenegade   = $10;

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
 ScreenType  = array[ 0..7999 ] of byte;          { 80x50 screen }
 VGAtype = array [ 0..319, 0..200 ] of byte;
 DChar = array[ 1..2 ] of char;                   { double char }
 LongStr = array[ 1 .. 3 ] of string;             { about 7 lines }
 Cel = array[ 0 .. 0 ] of byte;
 PCel = ^Cel;                                     { ^TextPicture }
 ScreenTypePtr = ^ScreenType;

Var
 sw      : word;                                 { width of screen * 2}
 {$IFDEF TPC}
 Screen  : ScreenType {absolute $B800:$0000};      { co80 screen  }
 {$ELSE}
 Screen  : ScreenType;
 {$ENDIF}
 WriteTo : ScreenTypePtr;                        { Directs Writes }
 DOSscreen : ScreenTypePtr;                      { saved DOS screen }
 DOSxPos,                                        { saved xpos from DOS }
 DOSyPos,                                        { saved ypos from DOS }
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
 procedure colorxy ( a, b, c : byte; s : string );
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
{ procedure setmode( mode : word );
 procedure settextheight( h : byte );  }
 procedure fillscreen( atch : word ); {ATTR then CHAR}
 procedure fillbox( a1, b1, a2, b2 : byte; atch : word );
 procedure slidedown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure slidedownoff( offwhat : screentypeptr );
 procedure scrollup1( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrolldown1( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrolldown( x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrolldownoff( offwhat : screentypeptr );
 procedure scrollright(  x1, x2, y1, y2 : byte; offwhat : screentypeptr );
 procedure scrollrightoff( offwhat : screentypeptr );

{ þ string formatting commands }
 function cLength( s : string ) : byte;                { length - color codes }
 function cstrip( s : string ) : string;
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


Implementation

 { origin: 0,0 }
 procedure setScreenData( x, y : byte; ch : char; attr : byte );
  var
   p : integer;
 begin
  p := 2 * (( y * sw ) + x );
  if p < sizeOf(WriteTo^) then
  begin
   WriteTo^[ p ] := byte(ch);
   WriteTo^[ p + 1 ] := attr;
  end
 end;

{ þ string writing commands }
 procedure ColorXY( a, b, c : byte; s : string);
  var
   count : word;
   ox, oy : byte;
 begin
   { TODO : make colorxy callers (e.g., xmenu) manage own cursor position }
   ox := wherex; oy := wherey;
   { this actually draws it}
   crt.gotoxy( a, b );
   crt.textAttr := c;
   write( s );
   crt.gotoxy( ox, oy );

   { this stores a copy in the buffer }
   { TODO: migrate to fpc's video unit, so we can do both. }
   for count := 1 to length(s) do
     setScreenData( a-1, b-1, s[count], c );
 end;

 procedure Colorxyv( a, b, c : byte; s: string );
  var
   count : integer;
  begin
   for count := 1 to length(s) do
     setScreenData( a-1, b-1 + count, s[count], a );
  end;

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
    cwrenegade : tcolor := s2n( s );
   end; { of case cn }
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
   if s = '' then exit; {0311.95: i never bothered to check that!!}
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
                   '0'..'9': begin
                               cwdigit1 := s[b];
                               cwcurrenttask := cwrenegade;
                               cwnchexpected := 1;
                             end;
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
      cwrenegade : if cwnchexpected = 1 then
                    begin
                     cwcommandmode := false;
                     cwcurrenttask := cwnotask;
                     dec( cwnchexpected );
                     cwcommand( cwrenegade, cwdigit1 + s[b] );
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
        'a'..'z','0'..'9','A'..'Z',' ' : TColor := $0F;
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
  var
   count : byte;
   offset,len : word;
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
  var
   count : byte;
   offset,len : word;
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
     offset :=  sw * (y2-count+2) + x1 * 2;
     {first, slide old screen section down 1 line}
     for count2 := y2 downto succ(y1) do
      begin
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
      thingy := (count2*sw)+(x1*2);
      move( screen[ thingy ], screen[ thingy+2 ], len );
      move( offwhat^[ (count2*sw)+(x2-count)*2 ], screen[ thingy ], 2 );
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

 function cstrip( s : string ) : string;
  var
   i : byte;
   c : string;
  begin
   c := '';
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
      c := c + s[i];
      inc( i );
     end;
   cstrip := c;
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
   writeto^[ (a1 + i) * 2 - 1 + (b2 * sw) ] := $08;
  if
   a2 < txmax-txmin+1
  then
   for
    i := 0 to h
   do
    writeto^[ (a2 * 2) + 1 + ( b1 + i ) * sw ] := $08;
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
    move( pic^[ ( i * w * 2 ) ], writeto^[(( b1 + i ) * sw ) + ( a1 * 2 )], w * 2 );
 end;

{ þ screen savers }

procedure rnd;
 var
  tmp : ScreenType;
  t  : byte;
  ch : char;
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

{$IFDEF FPC}
function shiftstate : byte;
 var e : keyboard.TKeyEvent;
begin
 e := keyboard.pollShiftStateEvent;
 shiftstate := keyboard.GetKeyEventShiftState(e);
end;

{$ELSE}
function shiftstate : byte;
 var
  rgs : registers;
 begin
  rgs.AH := $02;
  intr( $16, rgs );
  shiftstate := rgs.al;
 end;
{$ENDIF}

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

function stardate : string;  { Sat 1218.93 12:40:00 }
 var
  w,mo,d,y,h,h2,mi,s,n: word;
  sdate : string;
 begin
  getdate( y, mo, d, w );
  gettime( h, mi, s, n );
  h2 := h mod 12;
  if h2 = 0 then h2 := 12;
  sdate := days[ w ] + ' ' +
              flushrt( n2s( mo ), 2, '0') +
              flushrt( n2s( d ), 2, '0') + '.' +
              copy( flushrt( n2s( y ), 4, '0'), 3, 5 ) + ' ' +
              flushrt( n2s( h2 ), 2, '0' ) + ':' +
              flushrt( n2s( mi ), 2, '0' )+ ':' +
              flushrt( n2s( s ), 2, '0' )+
              boolchar( h < 12, 'a', 'p');
  stardate := sdate;
 end;


procedure error( msg : string );
 begin
  crt.textmode( 3 );
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

procedure installfont( fontseg, fontofs : word );
 Begin
  (* TODO: installfont
   fontofs := fontofs + 16;
   Asm;

   push    bp

   mov     si, 40h
   mov     es, si
   mov     ax, es:[ 60h ]
   push    ax                 { save old cursor style on stack }

   mov     ax, fontseg
   mov     es, ax

   mov     ax, 1100h           { Load userdefined charset }
   mov     bx, 1000h           { bh = bytes per char ( 10h ); bl = page ( 0h ) }
   mov     cx, 00FFh           { number of patterns }
   mov     dx, 0001h           { dx = first char }
   mov     bp, fontofs         { es:bp -> new char table }

   int     10h                 { install the new chars }

   mov     ah, 12h
   mov     bh, 20h

   int     10h                 { and set up the printscreen procedure }

   mov     ax,0100h
   pop     cx                  { get the old cursor style }
   int     10h                 { and restore it }

   pop     bp                  { restore bp }
 end; {asm}
 *)
End;

procedure installfont2( fontseg, fontofs : word );
 Begin
   fontofs := fontofs + 16;
   Asm;

   push    bp

   mov     si, 40h
   mov     es, si
   mov     ax, es:[ 60h ]
   push    ax                 { save old cursor style on stack }

   mov     ax, fontseg
   mov     es, ax

   mov     ax, 1110h           { Load userdefined charset }
   mov     bx, 1001h           { bh = bytes per char ( 10h ); bl = page ( 0h ) }
   mov     cx, 00FFh           { number of patterns }
   mov     dx, 0001h           { dx = first char }
   mov     bp, fontofs         { es:bp -> new char table }

   int     10h                 { install the new chars }

   mov     ah, 12h
   mov     bh, 20h

   int     10h                 { and set up the printscreen procedure }

   mov     ax,0100h
   pop     cx                  { get the old cursor style }
   int     10h                 { and restore it }

   pop     bp                  { restore bp }
 end; {asm}
End;

 procedure loadfont( s : string );
  var
   f: file;
   t : array[ 1..4096 ] of byte;
  begin
  {$I-} assign( f, s ); reset( f,1 ); {$I+}
   if ioresult <> 0 then exit;
   blockread( f, t, 4096 );
   close( f );
   installfont(seg(t),ofs(t));
  end;

const
    Vga90: array [1..9] of word = (
        $6B00,$5901,$5A02,$8E03,$6004,$8D05,$2D13,$0101,$0800);


procedure SetWidth90;
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
 e : keyboard.TKeyEvent;
 ch: char;
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
 tColor := $0007;
 sColor := $000E;
 tXpos := wherex;
 tYpos := wherey;
 tXsav := 1;
 tYsav := 1;
 tXmin := 1;
 tYmin := 1;
 tXmax := 80;
 tYmax := 50;
 cwcommandmode := false;
 cwcurrenttask := cwnotask;
 cwnchexpected := 0;
 cursoron := false;
 cursorattr := lightred * 16 + ord('þ');
 WriteTo := @screen;
end.
