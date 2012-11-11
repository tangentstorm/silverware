unit cw; { colorwrite }
interface uses crt, num, stri;

  const
    { cwrite commands }
    cwnotask	 = $00;
    cwchangefore = $01;
    cwchangeback = $02;
    cwCR	 = $03;
    cwBS	 = $04;
    cwclrscr	 = $05;
    cwclreol	 = $06;
    cwgotoxy	 = $07;
    cwgotox	 = $08;
    cwgotoy	 = $09;
    cwsavexy	 = $0A;
    cwloadxy	 = $0B;
    cwsavecol	 = $0C;
    cwloadcol	 = $0D;
    cwchntimes	 = $0E;
    cwspecialstr = $0F;
    cwrenegade	 = $10;

  const //  why do I need both of these?
    ccolors : array [0..15] of char = 'kbgcrmywKBGCRMYW';
    ccolstr : string		    = 'kbgcrmywKBGCRMYW';
    ccolset = [ 'k','b','g','c','r','m','y','w',
		'K','B','G','C','R','M','Y','W' ];

  var
    tColor,                        { CWrite color }
    sColor,                        { saved tColor }
    tXpos, tYpos,                  { CWrite xy pos }
    tXmin, tYmin,                  { CWrite xy min }
    tXmax, tYmax : byte;           { CWrite xy max }
    tXSav, tYSav : byte;           { saved t[xy]pos }
    cwcommandmode      : boolean;  { cwrite command mode? }
    cwcurrenttask      : byte;     { cwrite current task? }
    cwnchexpected      : byte;     { cwrite #chars expected }
    cwchar,                        { cwrite character }
    cwdigit1, cwdigit2,            { 2nd digit of n1 }
    cwdigit3, cwdigit4 : char;     { 2nd digit of n2 }

{ ■ string writing commands }

  { primitives	       : these write text in solid colors }
  procedure colorxy  ( const x, y, c : byte; const s : string );
  procedure colorxyc ( x, y, c : byte; s : string );

  procedure colorxyv ( const x, y, c : byte; const s : string );
  deprecated; // v = 'virtual'? 'vga'?

  { colorwrite : color code interpreter }
  procedure cwcommand( cn : byte; s : string );
  procedure cwrite   ( s : string );
  procedure cwriteln ( s : string );
  procedure cwritexy ( x, y : byte; s : string );
  procedure ccenterxy( x, y : byte; s : string );

  { these do padding operations with color-encoded strings. often
    in console mode, what we really want is width in characters on
    the screen, not the length of the actual string in memory. }
  //  maybe this should be called width?
  function cLength( s : string ) : byte;         { length - color codes }
  function cstrip( s : string ) : string;
  function normaltext( s : string ) : string;
  function cpadstr( s : string; len : byte;ch : char ) : string;

  { these highlight punctuation and box drawing
    characters using a standard palette }
  procedure StWrite( s : string );
  procedure StWriteln( s : string );
  procedure StWritexy( x, y : byte; s : String );

implementation

  procedure colorxy( const x, y, c : byte; const s : string);
    // var count  : word; ox, oy : byte;
  begin
    {  TODO : make colorxy callers (e.g., xmenu) manage own cursor position }
    // ox := crt.wherex; oy := crt.wherey;

    crt.gotoxy( x, y );
    crt.textAttr := c;
    write( s );
    //  crt.gotoxy( ox, oy );
    { this stores a copy in the buffer }
    { TODO: migrate to fpc's video unit, so we can do both. }
    //  for count := 1 to length(s) do
    //  setScreenData( a-1, b-1, s[count], c );
  end;

  procedure Colorxyv( const x, y, c : byte; const s: string );
    inline; deprecated;
  begin colorxy( x, y, c, s );
  end;

 procedure colorxyc( x, y, c : byte; s : string );
  begin
   colorxy( x + 1 - length( s ) div 2, y, c, s );
  end;

 procedure cwcommand( cn : byte; s : string );
   const digits = ['0','1','2','3','4','5','6','7','8','9'];
  begin
   case cn of
    cwchangefore:
     if s[1] in ccolset
      then tcolor := ( tcolor and $F0 ) + pos( s[1], ccolors ) - 1;
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
        //  scrollup1( txmin, txmax, tymin, tymax, writeto );
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
      //  fillbox( txmin, tymin, txmax, tymax, tcolor*256 + 32 );
      txpos := 1;
      typos := 1;
     end;
    cwclreol :
      colorxy( txmin+txpos-1, tymin+typos-1,
	      tcolor, stri.chntimes( ' ', txmax-txpos+1 ) );
    cwsavecol :
     sColor := tColor;
    cwloadcol :
     tColor := sColor;
    cwchntimes :
     begin
      if length(s) <> 3 then exit;
      if (s[2] in digits) and (s[3] in digits) then
	cwrite( normaltext( stri.chntimes( s[1], s2n(s[2]+s[3])) ));
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
      { //  if i want to do things like this i should make it a 'macro' callback
     case upcase(s[1]) of
      'P' : cwrite( thisdir );
      'D' : cwrite( stardate );
     end;
	}
      ;
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

 procedure cwritexy( x, y : byte; s : string );
   var c, d : byte;
  begin
   c := txpos;
   d := typos;
   txpos := x;
   typos := y;
   cwrite( s );
   txpos := c;
   typos := d;
  end;

 procedure ccenterxy( x, y : byte; s : string );
  begin
   cwritexy( x + 1 - clength( s ) div 2, y, s );
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
        //  '░'..'▀' : TColor := $08;
        else TColor := $07;
       end;
       cwrite(s[counter]);
     end;
  end;

 procedure StWriteln( s : string );
  begin
   stwrite( s + #13 );
  end;

 procedure StWritexy( x, y : byte; s : string );
  begin
   txpos := x;
   typos := y;
   stwrite( s );
  end;



{ ■ string formatting commands }

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


 function cpadstr( s : string; len : byte; ch : char ) : string;
  begin
    if clength( s ) > len then s := stri.trunc( s, len );
   while clength( s ) < len do s := s + ch;
   cpadstr := s;
  end;


initialization
 cwcommandmode := false;
 cwcurrenttask := cwnotask;
 cwnchexpected := 0;
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
end.
