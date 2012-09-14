Unit ZokStuff;  { menus, dialogs, input, confirmation boxes, etc }
Interface

 var
  heap : pointer;
 Type
  ZMenuPtr = ^ZMenuRec;
  ZMenuRec = Record
   Next, Last : ZMenuPtr;
   x,y : byte;
   s1,s2 : string;
   on : boolean;
   sc : char;
   v : word;
  end;
  ZMenu = Object
   endloop : boolean;
   Top,High: ZMenuPtr;
   EscExits : boolean;
   Constructor Init( esc : boolean );
   Procedure DrawAChoice( index: ZMenuPtr ); virtual;
   Procedure Add( x, y : byte; s1, s2 : string;
                  on: boolean; sc : char; v: word ); virtual;
   Procedure Show; virtual;
   procedure setto( z : zmenuptr );
   Function ShortCut( ch : char ) : ZmenuPtr;
(*   function find( v : word ) : ZMenuPtr; virtual; *)
(*   procedure turnon( v : word ); virtual;         *)
(*   procedure turnoff( v : word ); virtual;        *)
(*   procedure toggle( v : word ); virtual;         *)
(*   procedure addbefore( v : word ); virtual;      *)
   function value : byte;
   procedure Handle( ch : char ); virtual;
   procedure handlestripped( ch : char ); virtual;
   procedure reset;
   Function Get : byte; virtual;
  end;
 Function NewLine( s1, s2 : string; on:boolean; sc : char; v:word;
                   next: ZMenuPtr ) : ZMenuPtr;
 Function NewBar( next : ZMenuPtr ) : ZMenuPtr;
 Type
  ZBounceMenu = Object( ZMenu )
   tx, ty, width, height : byte;
   constructor init( x, y, w : byte; esc : boolean; menu : ZMenuPtr );
   function topline : string; virtual;
   function format1( s : string ) : string; virtual;
   function format2( s : string ) : string; virtual;
   function barline : string; virtual;
   function bottomline : string; virtual;
   procedure show; virtual;
(*   procedure create;                              *)
(*   procedure move( x, y : byte );                 *)
(*   procedure moverel( x, y : byte );              *)
(*   procedure center;                              *)
  end;
  ZInput = Object
   x, y,               { coordinates }
   tcol,               { text color  }
   acol,               { arrow color (scroller) }
   tlen,               { max text length }
   dlen,               { length of display }
   d1st,               { first display char position }
   cpos : byte;        { cursor position }
   back,               { backup copy }
   strg : string;      { actual string }
   tovr ,              { type over toggle }
   frst ,              { first key to be pressed }
   done : boolean;     { end-loop flag }
   Procedure init(a,b,tl,dl,tc,ac : byte; start : string );
   Procedure default( a, b, tl, dl : byte; start : string );
   procedure reset;
   Procedure show;
   Procedure delete;
   Procedure backspace;
   Procedure movecursor( newpos : byte );
   Procedure Setovr( p : boolean );
   Procedure getkey( ch : char );
   Procedure handle( ch : char );
   Procedure handlestripped( ch : char );
   Procedure finish;
   Function value : string;
   Function get   : string;
  end;
  zcolor = object
   x, y,
   value,
   start,
   acol : byte;
   endloop : boolean;
   procedure init( a, b, ac, strt : byte );
   procedure handle( ch : char );
   procedure show;
   function get : byte;
  end;
  ztoggle = object
   x, y,
   tcol  : byte;
   start,
   value,
   endloop : boolean;
   truestr, falsestr : string;
   procedure init( a, b, tc : byte; ts, fs : string; startval : boolean );
   procedure show;
   procedure handle( ch : char );
   function toggle : boolean;
   function get : boolean;
  end;
  zyesno = object( ztoggle )
   procedure init( a, b, tc : byte; startval : boolean );
  end;
  Zconfirmbox = object
   x, y : byte;
   str1, str2 : string;
   procedure init( a, b : byte; s1, s2 : string );
   function get : boolean;
  end;
  Zinputbox = object( zconfirmbox )
   i : zinput;
   procedure init( a, b : byte; s1, s2 : string; l : byte );
   function get : string;
  end;

Implementation
uses Crt,CrtStuff,sndstuff;

Constructor ZMenu.Init( esc : boolean );
 begin
  New(Top);
  Top^.Last := Top;
  Top^.Next := Top;
  Top^.S1 := '-=>TOP<=-';
  High := Top;
  EscExits := esc;
  endloop := false;
 end;


 Procedure ZMenu.DrawAChoice( index: ZMenuPtr );
   Begin
     with index^ do
      begin
       if index <> high then
        CwriteXY( x, y, s1 )
       else
         CwriteXY( x, y, s2 )
      end;
   End;


 Procedure zmenu.Add( x, y : byte; s1,s2 : string;
                      on: boolean; sc : char; v: word );
   var
      newchoice : zmenuptr;
   begin
     New(NewChoice);
      NewChoice^.Next := Top;
      NewChoice^.Last := Top^.Last;
      NewChoice^.x := x;
      NewChoice^.y := y;
      NewChoice^.s1 := s1;
      NewChoice^.s2 := s2;
      NewChoice^.on := on;
      NewChoice^.sc := sc;
      NewChoice^.v := v;
      Top^.Last^.Next := NewChoice;
      Top^.Last := NewChoice;
      If Top^.Next = Top then Top^.Next := NewChoice;
      High := Top^.Next;
     Newchoice := nil;
   end;

 procedure zmenu.setto( z : zmenuptr );
  begin
   if z <> nil then high := z;
  end;

 Procedure ZMenu.Show;
   var
    index : zmenuptr;
   begin
     Index := Top^.Next;
     While Index <> top do
       begin
         DrawAChoice( Index );
         Index := Index^.Next;
       end;
   end;

 Function ZMenu.Shortcut( ch : char ) : Zmenuptr;
  var
   z,t : zmenuptr;
  begin
   z := nil;
   t := top;
   while ( t^.next <> top ) and (z = nil) do
    begin
     t := t^.next;
     if
      (upcase( t^.sc ) = upcase( ch ))
     then
      If
       (t^.on)
      then
       z := t
      else
       shortcut := nil
     else;
    end;
   shortcut := z;
  end;

 function zmenu.value : byte;
  begin
   if high <> top then value := High^.V else value := 255;
  end;

 procedure Zmenu.Handle( ch : Char );
  begin
   Case Ch of
     #0: handlestripped( Readkey );
     #13,
     #27: handlestripped( ch );
     else
      if shortcut( ch ) <> nil then
       begin
        setto( shortcut( ch ) );
        show;
        endloop := true;
       end; { else }
     end; { case }
  end; { handle }

 procedure Zmenu.Handlestripped( ch : Char );
  begin
   Case Ch of
     #72,{up}#75{rt} : begin;
                        repeat
                         High := High^.Last;
                         If High = Top then High := Top^.Last;
                        until high^.on;
                        Show;
                       end;
     #80,{dn}#77{lf} : begin;
                        repeat
                        High := High^.Next;
                        If High = Top then High := Top^.Next;
                        until high^.on;
                        Show;
                       end;
     #13: EndLoop := True;
     #27: if EscExits then
          begin
           high := top;
           endloop := true;
          end;
     else
      if shortcut( ch ) <> nil then
       begin
        high := shortcut( ch );
        show;
        endloop := true;
       end; { else }
     end; { case }
  end; { handle }

 procedure zmenu.reset;
  begin
   while
    not high^.on
   do
    begin
     High := High^.Next;
     If High = Top then High := Top^.Last;
    end;
   endloop := false;
   Show;
  end;

 Function ZMenu.Get : byte;
  var
    ch: char;
  begin
   reset;
   Repeat
    handle( readkey );
   Until endloop;
   get := value;
  end;

Function NewLine( s1, s2: string; on:boolean; sc : char;
                  v:word; next: ZMenuPtr ) : ZMenuPtr;
var
 zp : zmenuptr;
 begin
  new( zp );
  zp^.s1 := s1;
  if s2 = '' then zp^.s2 := s1 else zp^.s2 := s2;
  zp^.on := on;
  zp^.sc := sc;
  zp^.v := v;
  zp^.next := next;
  newline := zp;
 end;

Function NewBar ( next : zmenuptr ) : ZMenuPtr;
var
 zp : zmenuptr;
 begin
  new( zp );
  zp^.s1 := '';
  zp^.s2 := '';
  zp^.on := false;
  zp^.sc := #255;
  zp^.v := 0;
  zp^.next := next;
  newbar := zp;
  zp := nil;
 end;

constructor zbouncemenu.init( x,y,w: byte; esc: boolean; menu: zmenuptr );
 var
  b : byte;
  m : zmenuptr;
  s1, s2 : string;
  on : boolean;
  sc : char;
  v : word;
 begin
  zmenu.init( esc );
  new( m );
  m^.next := menu;
  b := 1;
  tx := x;
  ty := y;
  width := w;
  zmenu.add( x, y, topline, '', false, #255, 0 );
  height := 1;
  while m^.next <> nil do
   begin
    m  := m^.next;
    if m^.s1 <> '' then s1 := format1( m^.s1 )  else s1 := barline;
    s2 := format2( m^.s2 );
    on := m^.on;
    sc := m^.sc;
    v  := m^.v;
    zmenu.add( x, y + b, s1, s2, on, sc, v );
    inc( b, 1 );
    inc( height, 1 );
   end;
  zmenu.add( x, y + b, bottomline, '', false, #255, 00 );
  inc( height, 1 );
  inc( width, 1 );
 end;

function zbouncemenu.topline : string;
 begin
  topline := '|KÚ' + chntimes( 'Ä', width ) + '¿'
 end;

function zbouncemenu.format1( s : string ) : string;
 begin
  format1 := '|K³~k|w' + s + '|K³';
 end;

function zbouncemenu.format2( s : string ) : string;
 begin
  format2 := '|K³~r|Y' + s + '~k|K³';
 end;

function zbouncemenu.bottomline : string;
 begin
  bottomline := '|KÀ' + chntimes( 'Ä', width ) + 'Ù'
 end;

function zbouncemenu.barline : string;
 begin
  barline := '|KÃ' + chntimes( 'Ä', width ) + '´'
 end;

procedure zbouncemenu.show;
 begin
  zmenu.show;
  greyshadow( tx, ty, tx+width, ty+height - 1 );
 end;

Procedure ZInput.Init(a,b,tl,dl,tc,ac : byte; start : string );
 begin
  x := a;
  y := b;
  tlen := tl;
  dlen := dl;
  tcol := tc;
  acol := ac;
  cpos := 1;
  back := start;
  strg := start;
  done := false;
  frst := true;
  Setovr( false );
  d1st := 1;
 end;

Procedure ZInput.Default( a, b, tl, dl : byte; start : string );
 begin
  init( a, b, tl, dl, $4E, $07, start );
 end;

Procedure Zinput.reset;
 begin
  strg := back;
  frst := true;
  cpos := 1;
  d1st := 1;
  setovr( false );
  done := false;
 end;

Procedure ZInput.Show;
 var
  v : string;
 begin
  if tovr then doscursorbig else doscursoron;
  if
   d1st < tlen - dlen + 1
  then
   begin
    colorxy( x + dlen, y, acol, '¯' );
   end
  else
   begin
    colorxy( x + dlen, y, acol, ' ' );
    if cpos = tlen+1 then doscursoroff;
   end;
  while cpos > d1st + dlen do d1st := d1st + 1;
  while cpos < d1st do d1st := d1st - 1;
  v := copy( strg, d1st, dlen );
  while length( v ) < dlen do v := v + ' ';
  colorxy( x, y, tcol, v );
  gotoxy( x + cpos - d1st, y );
 end;

Procedure ZInput.Delete;
 begin
  system.delete( strg, cpos, 1 );
  show;
 end;

Procedure ZInput.BackSpace;
 begin
  if
   cpos <> 1
  then
   begin
    movecursor( cpos - 1 );
    delete;
   end;
 end;

Procedure zinput.movecursor( newpos : byte );
 begin
  if
   newpos = 0
  then
   cpos := 1
  else
   if
    ( newpos <= tlen + 1 )
   then
    if
     ( newpos <= length( strg ) + 1 )
    then
     cpos := newpos
    else
     cpos := length( strg ) + 1
   else
    cpos := tlen;
   show;
 end;

Procedure Zinput.Setovr( p : boolean );
 begin
  tovr := p;
  show;
 end;

Procedure Zinput.getkey( ch : char );
 begin
  if
   frst
  then
   begin
    strg := ch;
    cpos := 2;
    show;
   end
  else
   if
    tovr
   then
    begin
     if
      cpos <= length( strg )
     then
      strg[ cpos ] := ch
     else
      strg := strg + ch;
      movecursor( cpos + 1 );
    end
   else
    begin
     if
      length( strg ) < tlen
     then
      begin
       insert( ch, strg, cpos );
       movecursor( cpos + 1 );
      end;
    end;
   show;
 end;

Procedure zinput.handle( ch : char );
 begin
  case ch of
    #0 : handlestripped( readkey );
    #8 ,
   #13 ,
   #27 : handlestripped( ch );
   else
    getkey( ch );
  end;
  if frst then frst := false;
 end;

Procedure zinput.handlestripped( ch : char );
 begin
  case ch of
    #8 : backspace;
   #13 : begin
          back := strg;
          finish;
         end;
   #27 : begin
          strg := back;
          finish;
         end;
   #71 : movecursor( 1 ); { home }
   #75 : movecursor( cpos-1 ); { left }
   #77 : movecursor( cpos+1 ); { right }
   #79 : movecursor( tlen + 1 ); { end }
   #82 : setovr( not tovr );
   #83 : delete;
  end;
  if frst then frst := false;
 end;

Procedure Zinput.Finish;
 begin
  done := true;
  doscursoroff;
 end;

Function zinput.value : string;
 begin
  value := strg;
 end;

Function ZInput.Get : string;
  var
    ch : char;
    ex : boolean;
  begin
   reset;
   Repeat
    handle( readkey );
   Until done;
   get := strg;
 end;

procedure zcolor.init( a, b, ac, strt : byte );
 begin
  x := a;
  y := b;
  acol := ac;
  value := strt;
  start := start;
  endloop := false;
 end;

procedure zcolor.handle( ch : char );
 begin
  case ch of
    #0 : handle( readkey );
   #75 : value := dec2( value, 1, 0 );
   #77 : value := inc2( value, 1, 15 );
   #13: EndLoop := True;
   #27: begin
         value := start;
         endloop := true;
        end;
  end;
  show;
 end;

procedure zcolor.show;
 var
  s : string;
 begin
  if
   value > 0
  then
   colorxy( x, y, acol, '®' )
  else
   colorxy( x, y, acol, 'þ' );
  case value of
   $0 : s := 'black';
   $1 : s := 'blue';
   $2 : s := 'green';
   $3 : s := 'cyan';
   $4 : s := 'red';
   $5 : s := 'magenta';
   $6 : s := 'brown';
   $7 : s := 'light grey';
   $8 : s := 'darkgrey';
   $9 : s := 'light blue';
   $A : s := 'lightgreen';
   $B : s := 'light cyan';
   $C : s := 'bright red';
   $D : s := 'lightmagenta';
   $E : s := 'yellow';
   $F : s := 'white';
  end;
  colorxy( x + 1, y, $0F, '            ' );
  if
   value = 0
  then
   colorxyc( x + 6, y, $F, s )
  else
   colorxyc( x + 6, y, value, s );
  if value < 15 then
   colorxy( x + 13, y, acol, '¯' )
  else
   colorxy( x + 13, y, acol, 'þ' );
 end;

function zcolor.get : byte;
 begin
  show;
  repeat
   handle( readkey );
  until endloop;
  get := value;
 end;

procedure ztoggle.init( a, b, tc : byte; ts, fs : string; startval : boolean );
 begin
  x := a;
  y := b;
  tcol := tc;
  truestr := ts;
  falsestr := fs;
  start := startval;
  value := startval;
  endloop := false;
 end;

procedure ztoggle.show;
 begin
  if
   value
  then
   colorxy( x, y, tcol, truestr )
  else
   colorxy( x, y, tcol, falsestr );
 end;

procedure ztoggle.handle( ch : char );
 var
  ts, fs : char;
 begin
  ts := upcase(  truestr[ 1 ] );
  fs := upcase( falsestr[ 1 ] );
  ch := upcase( ch );
  if
   ch = ts
  then
   value := true
  else
   if
    ch = fs
   then
    value := false
   else
    case ch of
     #13 : endloop := true;
     #27 : begin
            value := start;
            endloop := true;
           end;
    end;
  show;
 end;

function ztoggle.toggle : boolean;
 begin
  value := not value;
  show;
  toggle := value;
 end;

function ztoggle.get : boolean;
 var
  ch : char;
 begin
  endloop := false;
  repeat
   show;
   ch := readkey;
   case ch of
    #0  : ch := readkey;
    else handle( ch );
   end;
  until endloop;
  get := value;
 end;

procedure zyesno.init( a, b, tc : byte; startval : boolean );
 begin
  ztoggle.init( a, b, tc, 'Yes', 'No ', startval );
 end;

procedure zconfirmbox.init( a, b : byte; s1, s2 : string );
 begin
  x := a;
  y := b;
  str1 := s1;
  str2 := s2;
 end;

function zconfirmbox.get : boolean;
 begin
  bar( x, y, x + 1 + clength( str1 ), y + 3, $08 );
  greyshadow( x, y, x + 1 + clength( str1 ), y + 3 );
  cwritexy( x + 1, y + 1, str1 );
  ccenterxy( x + clength( str1 ) div 2, y + 2, str2 );
  get := yesno;
 end;

procedure zinputbox.init( a, b : byte; s1, s2 : string; l : byte );
 begin
  zconfirmbox.init( a, b, s1, s2 );
  i.init( x + 1 + clength( s2 ), y + 2, l, l, $4E, $07, '' );
 end;

function zinputbox.get : string;
 begin
  bar( x, y, x + 1 + clength( str1 ), y+3, $08 );
  greyshadow( x, y, x + 1 + clength( str1 ), y+3 );
  cwritexy( x + 1, y + 1, str1 );
  cwritexy( x + 1, y + 2, str2 );
  get := i.get;
 end;

End.