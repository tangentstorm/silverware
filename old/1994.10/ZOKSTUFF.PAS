Unit ZokStuff;  { menus, dialogs, input, confirmation boxes, etc }
Interface
uses crtstuff;

{ NOTE : ZOKSTUFF Considers (0,0) the top left corner! }

 Type
  ZObj = object
   x, y, x2, y2 : byte;
   constructor init( a, b, a2, b2 : byte );
   procedure invert; virtual;
   procedure uninvert; virtual;
   function mouseover : boolean; virtual;
   function pressed : boolean; virtual;
   function click : boolean; virtual;
   destructor done;
  end;
  Ztext = object( Zobj )
   st1, st2 : string;
   constructor init(  a, b : byte; s, s2 : string );
   procedure invert; virtual;
   procedure uninvert; virtual;
  end;
  ZMenuPtr = ^ZMenuObj;
  ZMenuObj = Object( ZObj )
   Next, Last : ZMenuPtr;
   Sub : pointer;
   s1,s2 : string;
   on : boolean;
   sc : char;
   v : byte;
   constructor init( a, b : byte; st1, st2 : string; ison : boolean;
                     shortcut : char; value : word; nxt : zmenuptr );
   procedure draw( switch : boolean ); virtual;
   function click : boolean; virtual;
  end;
  ZMenuObjPtr = ^ZMenu;
  ZMenu = Object
   endloop : boolean;
   Top,High: ZMenuPtr;
   EscExits : boolean;
   Constructor Init( esc : boolean );
   Procedure DrawAChoice( index: ZMenuPtr ); virtual;
   Procedure Add( x, y : byte; s1, s2 : string;
                  on: boolean; sc : char; v: word ); virtual;
   Procedure Show; virtual;
   procedure seton( z : zmenuptr );
   procedure setto( z : zmenuptr ); { sets and draws }
   Function ShortCut( ch : char ) : ZmenuPtr;
(*   function find( v : word ) : ZMenuPtr; virtual; *)
(*   procedure turnon( v : word ); virtual;         *)
(*   procedure turnoff( v : word ); virtual;        *)
(*   procedure toggle( v : word ); virtual;         *)
(*   procedure addbefore( v : word ); virtual;      *)
   function value : byte; virtual;
   procedure Handle( ch : char ); virtual;
   procedure handlestripped( ch : char ); virtual;
   procedure reset; virtual;
   procedure domousestuff; virtual;
   Function Get : byte;
  end;
 Function NewLine( s1, s2 : string; on:boolean; sc : char; v:word;
                   next: ZMenuPtr ) : ZMenuPtr;
 Function NewBar( next : ZMenuPtr ) : ZMenuPtr;
 Type
  ZBounceMenu = Object( ZMenu )
   tx, ty, width, height : byte;
   constructor init( x, y, w : byte; p : string; esc : boolean; menu : ZMenuPtr );
   function topline : string; virtual;
   function format1( s : string ) : string; virtual;
   function format2( s : string ) : string; virtual;
   function barline : string; virtual;
   function bottomline : string; virtual;
   procedure show; virtual;
(*   procedure move( x, y : byte );                 *)
(*   procedure moverel( x, y : byte );              *)
(*   procedure center;                              *)
  end;
  ZMenubar = object( Zmenu )
   shownbefore : boolean;
   constructor init( esc : boolean );
   procedure addsub( whatkey : char; submenu : ZMenuobjptr );
   procedure altkey( whatkey : char );
   procedure show; virtual;
   procedure reset; virtual;
   procedure handlestripped(ch:char); virtual;
   procedure domousestuff; virtual;
   function value : byte; virtual;
   function Get : byte;
  end;
  ZInput = Object ( ZObj )
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
   isdone : boolean;   { end-loop flag }
   constructor init(a,b,tl,dl,tc,ac : byte; start : string );
   constructor default( a, b, tl, dl : byte; start : string );
   procedure reset;
   Procedure show; virtual;
   Procedure delete;
   Procedure backspace;
   Procedure movecursor( newpos : byte );
   Procedure Setovr( p : boolean );
   Procedure getkey( ch : char );
   Procedure handle( ch : char ); virtual;
   Procedure handlestripped( ch : char ); virtual;
   Procedure finish;
   Function value : string;
   Function get   : string;
  end;
  zpassword = object( zinput )
   pwchar : char;
   constructor init(a,b,tl,dl,tc,ac : byte; pwc: char;start : string );
   constructor default( a, b, tl, dl : byte; start : string );
   procedure show; virtual;
  end;
  zcounter = object( Zobj )
   acol,
   tcol : byte;
   value,
   start,
   min,
   max : word;
   endloop : boolean;
   constructor init( a, b, tc, ac : byte; mn, mx, strt : word );
   procedure show;
   procedure handle( ch : char );
   procedure domousestuff; 
   function get : word;
   function showstring : string; virtual;
  end;
  zhexcounter = object ( zcounter )
   constructor init( a, b, tc, ac : byte; mn, mx, strt : word );
   function showstring : string; virtual;
  end;
  zcolor = object ( zcounter )
   truecol : byte;
   constructor init( a, b, tc, ac, strt : byte );
   function showstring : string; virtual;
  end;
  ztoggle = object ( ZObj )
   tcol  : byte;
   start,
   value,
   endloop : boolean;
   truestr, falsestr : string;
   constructor init( a, b, tc : byte; ts, fs : string; startval : boolean );
   procedure show;
   procedure handle( ch : char );
   function toggle : boolean;
   function get : boolean;
  end;
  zyesno = object( ztoggle )
   constructor init( a, b, tc : byte; startval : boolean );
  end;
  Zconfirmbox = object ( ZOBj )
   bcol : byte;
   str1, str2 : string;
   constructor init( a, b, border : byte; s1, s2 : string );
   constructor default( a, b : byte; s1, s2 : string );
   function get : boolean;
  end;
  Zinputbox = object( zconfirmbox )
   i : zinput;
   constructor init( a, b, border : byte; s1, s2 : string; l : byte );
   constructor default( a, b : byte; s1, s2 : string; l : byte );
   function get : string;
  end;
  ZVscroller = object( zobj )
   bch, hch: char;
   bat, hat: byte;
   min, max, value: byte;
   constructor init( a, b, _min, _max, strt : byte; bc, hc: char; ba, ha: byte);
   constructor default( a, b, _min, _max, strt : byte );
   procedure domousestuff;
   procedure show; virtual;
   procedure handle( ch : char );
  end;

Implementation
uses Crt,sndstuff,moustuff;

constructor Zobj.init( a, b, a2, b2 : byte );
 begin
  x := a;
  y := b;
  x2 := a2;
  y2 := b2;
 end;

procedure zobj.invert;
 begin
 end;

procedure zobj.uninvert;
 begin
 end;

function zobj.mouseover : boolean;
 begin
  gettextmpos;
  mouseover :=
   (mx >= x ) and (mx <= x2 )
   and (my >= y ) and (my <= y2 )
 end;

function ZObj.pressed : boolean;
 begin
  pressed := mouseover and (ms and 1 <> 0)
 end;


function zobj.click : boolean;
 begin
  if
   pressed
  then
   begin
    invert;
    repeat until not mouseover or (ms and $01 = 0);
    uninvert;
    if
     mouseover 
    then
     click := true { clicked & released on box }
    else
     click := false; { released outside of box }
   end
  else
   click := false; { never even clicked in box }
 end;

destructor ZObj.done;
 begin
 end;

constructor Ztext.init(  a, b : byte; s, s2 : string );
 begin
  zobj.init( a, b, a+clength(s), b );
  st1 := s;
  st2 := s2;
  uninvert;
 end;

procedure ztext.invert;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  cwritexy( x, y, st2 );
  showmouse( mv );
 end;

procedure ztext.uninvert;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  cwritexy( x, y, st1 );
  showmouse( mv );
 end;

constructor ZMenuObj.init( a, b : byte; st1, st2 : string; ison : boolean;
                           shortcut : char; value : word; nxt : zmenuptr );
 begin
  zobj.init( a, b, a + clength( st1 ), b );
  s1 := st1;
  s2 := st2;
  on := ison;
  sc := shortcut;
  v  := value;
  next := nxt;
  sub := nil;
 (********  if nxt <> nil then add( nxt ); *********)
 end;

procedure zmenuobj.draw( switch: boolean );
 begin
  if switch then
   cwritexy( x, y, s1 )
  else
   cwritexy( x, y, s2 );
 end;

function zmenuobj.click : boolean;
 var
  c : boolean;
 begin
  c := on and zobj.click;
  if c and (sub <> nil) then zmenuobjptr(sub)^.show;
  click := c;
 end;

Constructor ZMenu.Init( esc : boolean );
 begin
  top := New( zmenuptr, init( 0,0, '-=>TOP<=-', '', off, #255, $FFFF, nil ));
  Top^.Last := Top;
  Top^.Next := Top;
  High := Top;
  EscExits := esc;
  endloop := false;
 end;


 Procedure ZMenu.DrawAChoice( index: ZMenuPtr );
   Begin
    index^.draw( index <> high );
   End;


 Procedure zmenu.Add( x, y : byte; s1,s2 : string;
                      on: boolean; sc : char; v: word );
   var
      newchoice : zmenuptr;
   begin
     newchoice := new( zmenuptr, init( x, y, s1, s2, on, sc, v, nil ));
      newchoice^.next := top;
      newchoice^.last := top^.last;
      Top^.Last^.Next := NewChoice;
      Top^.Last := NewChoice;
      If Top^.Next = Top then Top^.Next := NewChoice;
      High := Top^.Next;
     Newchoice := nil;
   end;

 procedure zmenu.seton( z : zmenuptr );
  begin
   if (z <> nil) and (z^.on) then high := z;
  end;

 procedure zmenu.setto( z : zmenuptr );
  begin
   seton( z );
   show;
  end;

 Procedure ZMenu.Show;
   var
    index : zmenuptr;
    mv : boolean;
   begin
     mv := mvisible;
     showmouse( off );
     Index := Top;
     While Index^.next <> top do
       begin
         Index := Index^.Next;
         DrawAChoice( Index );
       end;
     showmouse( mv );
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
        endloop := true;
       end; { else }
     end; { case }
  end; { handle }

 procedure Zmenu.Handlestripped( ch : Char );
  var
   z : zmenuptr;
  begin
   z := high;
   Case Ch of
     #72,{up}#75{rt} : begin;
                        repeat
                         z := z^.Last;
                         If z = Top then z := Top^.Last;
                        until z^.on;
                        setto( z );
                       end;
     #71 : begin
            z := top^.next;
            while not z^.on do z := z^.next;
            setto( z );
           end;
     #79 : begin
            z := top^.last;
            while not z^.on do z := z^.last;
            setto( z );
           end;
     #80,{dn}#77{lf} : begin;
                        repeat
                         z := z^.Next;
                         If z = Top then z := Top^.Next;
                        until z^.on;
                        setto( z );
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
        setto( shortcut( ch ) );
        endloop := true;
       end; { else }
     end; { case }
  end; { handle }

 procedure zmenu.reset;
  begin
   high := top;
   while
    not high^.on
   do
    begin
     High := High^.Next;
     If High = Top then High := Top^.Last;
    end;
   endloop := false;
  end;

 procedure zmenu.domousestuff;
  var
   z : zmenuptr;
  begin
   if not mpresent then exit;
   getmpos;
   if
    (ms = 2)
   then
    begin
     repeat getmpos until (ms and 2 = 0);
     handle( #27 )
    end
   else
    begin
     z := top;
     while z^.next <> top do
      begin
       z := z^.next;
       if
        z^.mouseover and (ms and 1 <> 0)
       then
        setto( z );
       if
        z^.click
       then
        handle( #13 );
      end;
    end;
  end;

 Function ZMenu.Get : byte;
  var
   ch: char;
  begin
   reset;
   show;
   Repeat
    if not keypressed then
     domousestuff
    else
     handle( readkey );
   Until endloop;
   get := value;
  end;

Function NewLine( s1, s2: string; on:boolean; sc : char;
                  v:word; next: ZMenuPtr ) : ZMenuPtr;
var
 zp : zmenuptr;
 begin
  zp := new( zmenuptr, init( 0, 0, s1, s2, on, sc, v, next ));
  if s2 = '' then zp^.s2 := s1 else zp^.s2 := s2;
  newline := zp;
 end;

Function NewBar ( next : zmenuptr ) : ZMenuPtr;
 begin
  newbar := new( zmenuptr, init( 0, 0, '', '', off, #255, 0, next ));
 end;

const
 zbmb  : char = 'k';
 zbmf  : char = 'K';
 zbmt  : char = 'w';
 zbhb  : char = 'r';
 zbhf  : char = 'Y';

procedure setpal( palstr : string );
 begin
  if length( palstr ) <> 5
  then
   begin
    zbmb  := 'k';
    zbmf  := 'K';
    zbmt  := 'w';
    zbhb  := 'r';
    zbhf  := 'Y';
    exit;
   end;
  zbmb := palstr[ 1 ];
  zbmf := palstr[ 2 ];
  zbmt := palstr[ 3 ];
  zbhb := palstr[ 4 ];
  zbhf := palstr[ 5 ];
 end;

constructor zbouncemenu.init( x,y,w: byte; p : string; esc: boolean; menu: zmenuptr );
 var
  b : byte;
  m : zmenuptr;
  s1, s2 : string;
  on : boolean;
  sc : char;
  v : word;
 begin
  zmenu.init( esc );
  b := 1;
  tx := x;
  ty := y;
  width := w;
  setpal( p );
  zmenu.add( x, y, topline, '', false, #255, 255 );
  height := 1;
  m := new( zmenuptr );
  m^.next := menu;
  while m^.next <> nil do
   begin
    m := m^.next;
    if m^.next <> nil then m^.next^.last := m;
    if m^.s2 = '' then m^.s2 := m^.s1;
    if m^.s1 <> '' then m^.s1 := format1( m^.s1 )  else m^.s1 := barline;
    m^.s2 := format2( m^.s2 );
    m^.x  := x;
    m^.x2 := x + width + 1;
    m^.y  := y+b;
    m^.y2 := y+b;
    inc( b, 1 );
    inc( height, 1 );
   end;
  m^.next := top; { m is now last item }
  menu^.last := top^.last; { <- top of menu's frame }
  top^.last^.next := menu;
  top^.last := m;
  zmenu.add( x, y + b, bottomline, '', false, #255, 255 );
  high := menu;
  inc( height, 1 );
  inc( width, 1 );
 end;

function zbouncemenu.topline : string;
 begin
  topline := '|!'+zbmb+'|'+zbmf+ 'Ú' + chntimes( 'Ä', width ) + '¿'
 end;

function zbouncemenu.format1( s : string ) : string;
 begin
  s := cpadstr(s, width, ' ' );
  format1 := '|!'+zbmb+'|'+zbmf+'³|'+zbmt+ s + '|'+zbmf+'³';
 end;

function zbouncemenu.format2( s : string ) : string;
 begin
  s := cpadstr(s, width, ' ' );
  format2 := '|!'+zbmb+'|'+zbmf+'³|!'+zbhb+'|'+zbhf+s+'|!'+zbmb+'|'+zbmf+'³';
 end;

function zbouncemenu.bottomline : string;
 begin
  bottomline := '|!'+zbmb+'|'+zbmf+'À' + chntimes( 'Ä', width ) + 'Ù'
 end;

function zbouncemenu.barline : string;
 begin
  barline := '|!'+zbmb+'|'+zbmf+'Ã' + chntimes( 'Ä', width ) + '´'
 end;

procedure zbouncemenu.show;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  zmenu.show;
  greyshadow( tx, ty, tx+width, ty+height - 1 );
  showmouse( mv );
 end;

constructor zmenubar.init( esc : boolean );
 begin
  zmenu.init( esc );
  add( 0, 0, ' ', ' ', off, #255, 0 );
  shownbefore := false;
 end;

procedure zmenubar.addsub( whatkey : char; submenu : zmenuobjptr );
 begin
  setto( shortcut( whatkey ) );
  high^.sub := submenu;
 end;

procedure zmenubar.altkey( whatkey : char );
 begin
 end;

procedure zmenubar.show;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  if not shownbefore then
   begin
    zmenu.show;
    shownbefore := true;
   end
  else
   begin
    zmenu.show;
   end;
  if (high^.sub <> nil) then zmenuobjptr( high^.sub )^.show;
  showmouse( mv );
 end;

procedure zmenubar.reset;
 begin
  high := top;
  repeat
   high := high^.next;
   if high^.sub <> nil then zmenuobjptr(high^.sub)^.reset;
  until high = top;
  repeat high := high^.next; until high^.on;
  endloop := false;
  Show;
 end;

procedure zmenubar.handlestripped( ch : char );
 begin
  case ch of
   #72, #80, #79, #71 : if high^.sub <> nil then
              zmenuobjptr( high^.sub )^.handlestripped( ch );
   #75, #77 : zmenu.handlestripped( ch );
   #27 : zmenu.handlestripped( ch );
   #13 : zmenu.handlestripped( ch );
   else
    if high^.sub <> nil then
    begin
     zmenuobjptr( high^.sub )^.handle( ch );
     endloop := zmenuobjptr( high^.sub )^.endloop;
     zmenuobjptr( high^.sub )^.endloop := false;
    end;
   end;
 end;

procedure zmenubar.domousestuff;
 begin
  zmenu.domousestuff;
  if
   (high^.sub <> nil)
  then
   begin
    zmenuobjptr( high^.sub )^.domousestuff;
    endloop := zmenuobjptr( high^.sub )^.endloop;
    zmenuobjptr( high^.sub )^.endloop := false;
   end;
 end;

function Zmenubar.value : byte;
 begin
  if
   high <> top
  then
   if
    (high^.sub <> nil)
   then
    value := zmenuobjptr( high^.sub )^.value
   else
    value := High^.V
  else
   value := 255;
 end;

function Zmenubar.get : byte;
 var
  ch: char;
  mv : boolean;
 begin
  high := top^.next;
  mv := mvisible;
  reset;
  Repeat
   if (shiftstate and altpressed) <> 0 then
    begin
     repeat until (shiftstate and altpressed) = 0;
     if not keypressed then handle( #27 );
    end;
   if not keypressed then
    domousestuff
   else
    handlestripped( readkey );
  Until endloop;
  get := value;
  mv := mvisible;
  showmouse( mv );
 end;

constructor ZInput.Init(a,b,tl,dl,tc,ac : byte; start : string );
 begin
  zobj.init( a, b, a, b );
  tlen := tl;
  dlen := dl;
  tcol := tc;
  acol := ac;
  cpos := 1;
  back := start;
  strg := start;
  isdone := false;
  frst := true;
  tovr := false;
  d1st := 1;
 end;

constructor ZInput.Default( a, b, tl, dl : byte; start : string );
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
  isdone := false;
 end;

Procedure ZInput.Show;
 var
  v : string;
 begin
  if tovr then doscursorbig else doscursoron;
  if
   d1st < tlen - dlen
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
    #6 ,
    #8 ,
   #13 ,
   #20 ,
   #24 ,
   #27 ,
   #127: handlestripped( ch );
   else
    getkey( ch );
  end;
  if frst then frst := false;
 end;

Procedure zinput.handlestripped( ch : char );
 const
  bullets = [' ','/','\','-'];
 begin
  case ch of
    #6,#20 : begin { ^Del <-doesn't seem to work!!,^T }
          while
           (cpos > 1 ) and not (strg[cpos-1] in bullets)
          do
           handlestripped( #75 );
          while
           (cpos <= length(strg)) and (not (strg[cpos] in bullets))
          do
           delete;
           delete;
         end;
    #8 : backspace; { backspace }
   #13 : begin      { enter }
          back := strg;
          finish;
         end;
   #24 : while (cpos > 1) do backspace; { ^X }
   #27 : begin      { esc }
          strg := back;
          finish;
         end;
   #71 : movecursor( 1 ); { home }
   #75 : movecursor( cpos-1 ); { left }
   #77 : movecursor( cpos+1 ); { right }
   #79 : movecursor( tlen + 1 ); { end }
   #82 : setovr( not tovr );
   #83 : delete;
   #115: begin { ^Left}
          while (cpos > 1) and (strg[cpos-1] in bullets)
          do handlestripped( #75 );
          while
           (cpos > 1) and (not (strg[cpos-1] in bullets))
          do
           handlestripped( #75 );
         end;
   #116: begin { ^Right}
          while (cpos <= length( strg )) and (strg[cpos-1] in bullets)
          do handlestripped( #77 );
          while
           (cpos < length( strg)) and (not (strg[cpos-1] in bullets))
          do
           handlestripped( #77 );
         end;
   #117: while cpos <= length( strg ) do delete; { ^End }
   #127: begin { ^BS }
          while
           (cpos <= length(strg)) and not (strg[cpos] in bullets)
          do
           handlestripped( #77 );
          while   
           (cpos > 1) and (not (strg[cpos-1] in bullets))
          do
           backspace;
          backspace;
         end;
  end;
  if frst then frst := false;
 end;

Procedure Zinput.Finish;
 begin
  isdone := true;
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
   Until isdone;
   get := strg;
 end;

constructor zpassword.init(a,b,tl,dl,tc,ac : byte; pwc: char;start : string );
 begin
  zinput.init(a,b,tl,dl,tc,ac,start);
  pwchar := pwc;
 end;

constructor zpassword.default( a, b, tl, dl : byte; start : string );
 begin
  init( a, b, tl, dl, $0A, $0E, 'þ', start );
 end;

procedure zpassword.show;
 var
  temp : string;
 begin
  temp := value;
  fillchar( strg[1], byte(strg[0]), pwchar );
  zinput.show;
  strg := temp;
 end;

constructor zcounter.init( a, b, tc, ac: byte; mn, mx, strt : word );
 begin
  zobj.init( a, b, a+6, b );
  acol := ac;
  tcol := tc;
  value := strt;
  start := strt;
  min := mn;
  max := mx;
  endloop := false;
 end;

procedure zcounter.show;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  if
   value > min
  then
   colorxy( x, y, acol, '®' )
  else
   colorxy( x, y, acol, 'þ' );
  colorxy( x + 1, y, tcol, chntimes( ' ', x2-x ));
  colorxyc( x + (x2-x)div 2-1, y, tcol, showstring );
  if value < max then
   colorxy( x2, y, acol, '¯' )
  else
   colorxy( x2, y, acol, 'þ' );
  showmouse( mv );
 end;

procedure zcounter.handle( ch : char );
 begin
  case ch of
    #0 : handle( readkey );
   #75 : value := dec2( value, 1, min );
   #77 : value := inc2( value, 1, max );
   #13: EndLoop := True;
   #27: begin
         value := start;
         endloop := true;
        end;
  end;
  show;
 end;

function zcounter.get : word;
 begin
  endloop := false;
  show;
  repeat
   handle( readkey );
  until endloop;
  get := value;
 end;

procedure zcounter.domousestuff;
 begin
  if
   pressed
  then
   begin
    delay( 50 );
    if mx = x then handle( #75 );
    if mx = x2 then handle( #77 );
   end;
 end;

function zcounter.showstring : string;
 begin
   showstring := n2s( value );
 end;

constructor zhexcounter.init( a, b, tc, ac: byte; mn, mx, strt : word );
 begin
  zcounter.init( a, b, tc, ac, mn, mx, strt );
  x2 := a+8;
 end;

function zhexcounter.showstring : string;
 begin
  showstring := h2s( value );
 end;

constructor zcolor.init( a, b, tc, ac, strt : byte );
 begin
  zcounter.init( a, b, tc, ac, 0, $f, strt );
  x2 := a+8;
  truecol := tcol;
 end;

function zcolor.showstring : string;
 var
  s : string;
 begin
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
  if
   value = truecol shr 4
  then
   tcol := truecol and $F0 + not value and $0F
  else
   tcol := truecol and $F0 + value
 end;

constructor ztoggle.init( a, b, tc : byte; ts, fs : string; startval : boolean );
 begin
  zobj.init( a, b, a, b );
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

constructor zyesno.init( a, b, tc : byte; startval : boolean );
 begin
  ztoggle.init( a, b, tc, 'Yes', 'No ', startval );
 end;

constructor zconfirmbox.init( a, b, border : byte; s1, s2 : string );
 begin
  x := a;
  y := b;
  bcol := border;
  str1 := s1;
  str2 := s2;
 end;

constructor zconfirmbox.default( a, b : byte; s1, s2 : string );
 begin
  zconfirmbox.init( a, b, $08, s1, s2 );
 end;

function zconfirmbox.get : boolean;
 begin
  bar( x, y, x + 1 + clength( str1 ), y + 3, bcol );
  greyshadow( x, y, x + 1 + clength( str1 ), y + 3 );
  cwritexy( x + 1, y + 1, str1 );
  ccenterxy( x + clength( str1 ) div 2, y + 2, str2 );
  get := yesno;
 end;

constructor zinputbox.init( a, b, border : byte; s1, s2 : string; l : byte );
 begin
  zconfirmbox.init( a, b, border, s1, s2 );
  i.init( x + 1 + clength( s2 ), y + 2, l, l, $4E, $07, '' );
 end;

constructor zinputbox.default( a, b : byte; s1, s2 : string; l : byte );
 begin
  zinputbox.init( a, b, $08, s1, s2, l );
 end;

function zinputbox.get : string;
 begin
  bar( x, y, x + 1 + clength( str1 ), y+3, bcol );
  greyshadow( x, y, x + 1 + clength( str1 ), y+3 );
  cwritexy( x + 1, y + 1, str1 );
  cwritexy( x + 1, y + 2, str2 );
  get := i.get;
 end;


constructor zvscroller.init( a, b, _min, _max, strt : byte; bc, hc: char; ba, ha: byte);
 begin
  zobj.init( a, b, a, b+_max-_min );
  bch := bc;
  bat := ba;
  hch := hc;
  hat := ha;
  min := _min;
  max := _max;
  value := strt;
  show;
 end;

constructor zvscroller.default( a, b, _min, _max, strt : byte );
 begin
  init( a, b, _min, _max, strt, '³', 'þ', $08, $0A);
 end;

procedure zvscroller.domousestuff;
 begin
  if
   pressed and (my = y + value - min)
  then
   while pressed do
    begin
     value  := my - y + min;
     show;
    end;
  end;

procedure zvscroller.show;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  colorxyv(x, y, bat, chntimes( bch, max-min+1 ) );
  colorxy( x, y+ value, hat, hch );
  showmouse( mv );
 end;

procedure zvscroller.handle( ch : char );
 begin
  case ch of
    #0 : handle( readkey );
    #72 : value := decwrap( value, 1, min, max );
    #80 : value := incwrap( value, 1, min, max );
   end;
  show;
 end;

End.