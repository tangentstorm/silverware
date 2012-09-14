Unit ZokStuff;  { menus, dialogs, input, confirmation boxes, etc }
Interface
uses crtstuff, pntstuff;
{ NOTE : ZOKSTUFF Considers (0,0) the top left corner! }

{ newsepbar( next : pzchoice ) }
{ newchoicexy( x, y, s1, s2, on, shortcut, value, submenu, next }
{ newchoice( s1, s2, on, shortcut, value, submenu, next }
{ newmenu( e, a, menu )  }
{ newbouncemenu( x, y, w, palstr, esc, alt, menu ) }
{ newmenubar( x, y, palette, esc, alt, menu ) }

var
 ZokWork : screentype absolute $B800:$2000;
 ZokBack : screentype absolute $B800:$3000;

 Type

  pzobj = ^zobj;
  ZObj = object ( node ) { a clickable rectangle onscreen }
   x, y, x2, y2 : byte;
   constructor init( a, b, a2, b2 : byte );
   procedure shownormal; virtual;
   procedure showinvert; virtual;
   function mouseover : boolean; virtual;
   function pressed : boolean; virtual;
   function click : boolean; virtual;
  end;

  pztext = ^ztext;
  ztext = object( zobj )
   st1, st2 : string;
   constructor init(  a, b : byte; s, s2 : string );
   procedure shownormal; virtual;
   procedure showinvert; virtual;
  end;

  pzchoice = ^zchoice;
  zchoice = object( ztext )
   sub : plist;                     { sumbmenus }
   on : boolean;                    { active? }
   sc : char;                       { shortcut character }
   v : byte;                        { return value }
   constructor init( a, b : byte; s, s2 : string; ison : boolean;
                     shortcut : char; value : word; submen : plist;
                     nxt : pzchoice );
   procedure draw( high : boolean ); virtual;
  end;

  function newsepbar( next : pzchoice ) : pzchoice;
  function newchoicexy( x, y : byte; s1, s2 : string; on : boolean;
                        sc : char; v : word; sub : plist;
                        next : pzchoice ) : pzchoice;
  function newchoice( s1, s2 : string; on : boolean; sc : char; v : word;
                      sub : plist; next : pzchoice ) : pzchoice;

 Type
  pzmenu = ^zmenu;
  zmenu = object ( list )
   tx, ty,
   height,
   width : byte; { updated constantly in reformatting loop }
   high : pzchoice;
   topmenu,
   endloop,
   escexits,
   altexits,
   subactive,
   usetempscreen : boolean;
   constructor init( esc, alt, usetemp : boolean; menu : pzchoice );
   procedure insert( z : pzchoice ); virtual;
   procedure add( z : pzchoice ); virtual;
   procedure show; virtual;
   procedure seton( z : pzchoice );
   procedure setto( z : pzchoice );
   procedure setonfirst;
   procedure settofirst;
   procedure handle( ch : char ); virtual;
   procedure handlestripped( ch : char ); virtual;
   procedure reset; virtual;
   procedure domousestuff; virtual;
   procedure dowhilelooping; virtual;
   procedure format( choice : pzchoice ); virtual;
   function normalstr( s: string ) : string; virtual;
   function invertstr( s: string ) : string; virtual;
   function submenu : pzmenu;
   function shortcut( ch : char ) : pzchoice;
   function valuecut( v : word ) : pzchoice;
   function value : byte;
   function get : byte;
  end;

  function newmenu( e, a : boolean; menu : pzchoice ) : pzmenu;

 const
  zbmb  : char = 'k';
  zbmf  : char = 'K';
  zbmt  : char = 'w';
  zbhb  : char = 'r';
  zbhf  : char = 'Y';
  zbmw : byte = 1;

 type
  pzbouncemenu = ^zbouncemenu;
  ZBounceMenu = Object( ZMenu )
   constructor init( x, y, w : byte; p : string;
                     e, a : boolean; menu : pzchoice );
   procedure show; virtual;
   procedure format( choice : pzchoice ); virtual;
   function normalstr( s: string ) : string; virtual;
   function invertstr( s: string ) : string; virtual;
   function top : string; virtual;
   function sepbar : string; virtual;
   function bottom : string; virtual;
  end;

 function newbouncemenu( x, y, w : byte; p:string; e, a : boolean;
                         menu : pzchoice ) : pzbouncemenu;

 type
 pzmenubar = ^zmenubar;
 ZMenubar = object( ZMenu )
   constructor init( x, y : byte; p : string; e, a : boolean;
                     menu : pzchoice );
   procedure handle( ch : char ); virtual; { ð menu - #32 }
   procedure handlestripped(ch:char); virtual;
    { uses alt keys, plus the up+right are reversed for submenus }
   procedure format( choice : pzchoice ); virtual;
  end;

 function newmenubar( x, y : byte; p : string; e, a : boolean;
                      menu : pzchoice ) : pzmenubar;

type
  ZInput = Object ( ZObj )
   tcol,               { text color  }
   acol,               { arrow color (scroller) }
   tlen,               { max text length }
   dlen,               { length of display }
   d1st,               { first display char position }
   cpos : byte;        { cursor position }
   back,               { backup copy }
   strg : string;      { actual string }
   escexits,
   tovr ,              { type over toggle }
   frst ,              { first key to be pressed }
   isdone : boolean;   { end-loop flag }
   constructor init(a,b,tl,dl,tc,ac : byte; esc : boolean; start : string );
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
uses crt,sndstuff,moustuff;

constructor Zobj.init( a, b, a2, b2 : byte );
 begin
  x := a;
  y := b;
  x2 := a2;
  y2 := b2;
 end;

procedure zobj.shownormal;
 begin
 end;

procedure zobj.showinvert;
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
    showinvert;
    repeat until not pressed;
    shownormal;
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

constructor Ztext.init(  a, b : byte; s, s2 : string );
 begin
  zobj.init( a, b, a+clength(s), b );
  st1 := s;
  st2 := s2;
 end;

procedure ztext.shownormal;
 var
  mv : boolean;
 begin
  mv := mvisible;
  if mv then showmouse( off );
  cwritexy( x, y, st1 );
  if mv then showmouse( on );
 end;

procedure ztext.showinvert;
 var
  mv : boolean;
 begin
  mv := mvisible;
  if mv then showmouse( off );
  cwritexy( x, y, st2 );
  if mv then showmouse( on );
 end;

constructor zchoice.init( a, b : byte; s, s2 : string; ison : boolean;
            shortcut : char; value : word; submen : plist; nxt : pzchoice );
 begin
  ztext.init( a, b, s, s2 );
  st1 := s;
  st2 := s2;
  on := ison;
  sc := upcase( shortcut );
  v  := value;
  sub := submen;
  next := nxt;
 end;

procedure zchoice.draw( high: boolean );
 begin
  if high then
   showinvert
  else
   shownormal;
 end;

function newchoicexy( x, y : byte; s1, s2 : string; on : boolean;
                      sc : char; v : word; sub : plist;
                      next : pzchoice ) : pzchoice;
var
 zp : pzchoice;
 begin
  zp := new( pzchoice, init( x, y, s1, s2, on, sc, v, sub, next ));
  newchoicexy := zp;
  end;

function newchoice( s1, s2 : string; on : boolean; sc : char; v : word;
                    sub : plist; next : pzchoice ) : pzchoice;
 begin
  newchoice := newchoicexy( 0, 0, s1, s2, on, sc, v, sub, next );
 end;

function newsepbar( next : pzchoice ) : pzchoice;
 begin
  newsepbar := new( pzchoice, init( 0, 0, '', '', off, #255, 0, nil, next ));
 end;

constructor zmenu.init( esc, alt, usetemp : boolean; menu : pzchoice );
 var
  m : pzchoice;
 begin
  list.init;
  add( menu );
  m := pzchoice( first );
  while (m <> nil) do   { post-setformat }
   begin
    format( m );
    m := pzchoice( next( m ) );
   end;
  setonfirst;
  escexits := esc;
  altexits := esc;
  usetempscreen := usetemp;
  endloop := false;
  topmenu := false;
  subactive := false;
 end;

procedure zmenu.insert( z : pzchoice );
 var
  l : pzchoice;
 begin
  if z = nil then exit;
  l := z;
  while l^.next <> nil do l := pzchoice( l^.next );
  if last = nil then last := l else l^.next := last^.next;
  last^.next := z;
 end;


procedure zmenu.add( z : pzchoice );
 var
  l,t : pzchoice;
 begin
  if z = nil then exit; { has to add in all the nexts! }
  l := z;
  while l^.next <> nil do
   begin
    t := l;
    l := pzchoice( l^.next );
    if l <> nil then l^.prev := t;
   end;
  if last = nil then last := l else l^.next := last^.next;
  first^.prev := l;
  last^.next := z;
  z^.prev := last;
  last := l;
 end;

procedure zmenu.show;
 var
  mv : boolean;
  p, q : pzchoice;
  oldwriteto : pointer;
 begin
  if topmenu then zokwork := zokback;
  oldwriteto := writeto;
  writeto := @zokwork;
  p := pzchoice( first );
  while p <> nil do
   begin
    q := p;
    p := pzchoice( next( p ) );
    q^.draw( q = high );
   end;
  if high^.sub <> nil then submenu^.show;
{  if topmenu then}
   begin
    mv := mvisible;
    if mv then showmouse( off );
    writeto := oldwriteto;
    writeto^ := zokwork;
    if mv then showmouse( on );
   end;
 end;

procedure zmenu.seton( z : pzchoice );
 begin
  if (z <> nil) and (z^.on) then high := z;
  subactive := submenu <> nil;
  if subactive then
   begin
    submenu^.reset;
    subactive := submenu^.high <> nil;
   end;
 end;

procedure zmenu.setto( z : pzchoice );
 begin
  seton( z );
  show;
 end;

procedure zmenu.setonfirst;
 begin
  high := pzchoice( first );
  while (high <> pzchoice(last)) and ( not high^.on )
   do high := pzchoice( next( high ));
 end;

procedure zmenu.settofirst;
 begin
  setonfirst;
  show;
 end;

procedure zmenu.handle( ch : char );
 begin
  if (ch = #0) then
    begin handlestripped( readkey ); exit; end;
  if (ch = #27) then { hitting esc anywhere will exit }
    begin
     if escexits then begin high := nil; endloop := true; end;
     exit; { quit handling regardless of whether esc exits the menu }
    end;
  { since we're still here.. }
  if subactive then { just letters, so the submenu handles it }
   begin
    submenu^.handle( ch );
    endloop := submenu^.endloop;
    submenu^.endloop := false;
   end { sub <> nil }
  else
   Case Ch of
    #13: EndLoop := True;
    else
    if shortcut( ch ) <> nil then
     begin
      setto( shortcut( ch ) );
      if not subactive then endloop := true;
     end; { else }
   end; { case }
 end; { handle }

procedure Zmenu.Handlestripped( ch : Char );
 var
  l : pzchoice;
 begin
  if (subactive) and ( ch in [#71,#72,#73,#77,#79,#80,#81] )
   then submenu^.handlestripped( ch )
  else
   Case Ch of
    #72 : begin                                                { up }
           repeat
             if (high = pzchoice(first)) then high := pzchoice(last);
             if high <> nil then high := pzchoice(prev(high))
            until (high^.on) or (high = nil);
            if high = nil then halt;
            show;
           end;
    #75 : if subactive then                                    { left }
           if submenu^.subactive
            then submenu^.handlestripped( ch )
           else
            begin
             subactive := no;
             submenu^.high := nil;
            end;
    #80 : begin                                                 { down }
            repeat
             if (high = pzchoice(last)) then high := pzchoice(first);
             if high <> nil then high := pzchoice(next(high))
            until (high^.on) or (high = nil);
            if high = nil then halt;
            show;
           end;
    #77 : if high^.sub <> nil then                             { right }
            begin
             subactive := true;
             submenu^.reset;
             subactive := submenu^.high <> nil;
            end;
     #71,#73 : begin                                           { home }
                l := pzchoice( first );
                while (not l^.on) do l := pzchoice(l^.next);
                setto( pzchoice( l ) );
               end;
     #79,#81 : begin                                           { end }
                l := pzchoice( last );
                while (not l^.on) do l := pzchoice(l^.prev);
                setto( pzchoice( l ) );
               end;
    else
     handle( ch );
   end; { case }
  end; { handlestripped }

procedure zmenu.reset;
 begin
  if empty then exit;
  setonfirst;
   repeat
    high := pzchoice( next( high ));
    if high^.sub <> nil then submenu^.reset;
   until high = pzchoice( last );
   setonfirst;
   subactive := submenu <> nil;
  endloop := false;
 end;

procedure zmenu.domousestuff;
  var
   p, q : pzchoice;
 begin
  if not mpresent then exit;
  getmpos;
  if
   high^.sub <> nil
  then
   begin
    submenu^.domousestuff;
    endloop := submenu^.endloop;
    submenu^.endloop := false;
   end;
  if endloop then exit;
  if (ms = 2) then
   begin
    repeat getmpos until (ms and 2 = 0);
    handle( #27 )
   end
  else { no right click, procede as usual }
   begin
    p := pzchoice( first );
    while p <> nil do
     begin
      q := p;
      p := pzchoice( next( p ) );
      if (q^.on) and (q^.pressed) then
       begin
        setto( q );
        if q^.click then handle( #13 );
        show;
       end; { clicked }
     end; { while }
    end; { else }
 end; { domousestuff }

procedure zmenu.dowhilelooping;
 begin
  { this is to allow the menu to update clocks or screen savers, }
  { or to allow other controls to be onscreen at the same time.. }
  { multi-tasking in other words.. }
 end;

procedure zmenu.format( choice : pzchoice );
 begin
  { virtual procedure }
  if choice^.st2 = '' then choice^.st2 := invertstr( choice^.st1 )
   else choice^.st2 := invertstr( choice^.st2 );
  if choice^.st1 <> '' then choice^.st1 := normalstr( choice^.st1 );
 end;

function zmenu.normalstr( s: string ) : string;
 begin
  normalstr := '|!'+zbmb+'|'+zbmt+ s;
 end;

function zmenu.invertstr( s: string ) : string;
 begin
  invertstr := '|!'+zbhb+'|'+zbhf+s
 end;

function zmenu.submenu : pzmenu;
 begin
  if high^.sub <> nil
   then submenu := pzmenu( high^.sub ) else submenu := nil;
 end;

function zmenu.shortcut( ch : char ) : pzchoice;
 var
  p : pzchoice;
 begin
  if empty then exit;
  ch := upcase( ch );
  p := pzchoice( first );
  while ( p^.sc <> ch ) and (p <> pzchoice(last)) do p := pzchoice( next( p ) );
  if (p^.sc = ch) and (p^.on) then shortcut := p else shortcut := nil;
  end;

function zmenu.valuecut( v : word ) : pzchoice;
 var
  p : pzchoice;
 begin
  p := pzchoice( first );
  while (p <> nil) and ( p^.v <> v ) do p := pzchoice( next( p ) );
  if (p <> nil) and (p^.on) then valuecut := p else valuecut := nil;
 end;

function zmenu.value : byte;
 begin
  if high = nil then value := 255
   else if high^.sub = nil then value := high^.v
   else value := submenu^.value;
 end;

function zmenu.get : byte;
 var
  ch: char;
  ta : byte;
  mv : boolean;
 begin
  ta := textattr;
  if empty then begin get := 0; exit; end;
  topmenu := true;
  mv := mvisible;
  if mv then showmouse( off );
  zokback := writeto^;
  if mv then showmouse( on );
  endloop := false;
  reset;
  if high = nil then high := pzchoice( first );
  show;
  Repeat
   writeto := @screen;
   dowhilelooping;
   if ((shiftstate and altpressed) <> 0) then
    begin
     repeat until (shiftstate and altpressed) = 0;
     if (altexits) and (not keypressed) then handle( #27 );
    end;
   if keypressed then handle( readkey )
    else domousestuff;
  until endloop;
  get := value;
  topmenu := false;
  mv := mvisible;
  if mv then showmouse( off );
  zokback := writeto^;
  if mv then showmouse( on );
  writeto := @screen;
  textattr := ta;
  tcolor := ta;
 end;

 function newmenu( e, a : boolean; menu : pzchoice ) : pzmenu;
  begin
   newmenu := new( pzmenu, init( e, a, true, menu ));
  end;

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

constructor zbouncemenu.init( x, y, w : byte; p : string; e, a : boolean;
                              menu : pzchoice );
 var
  m : pzchoice;
 begin
  tx := x;
  ty := y;
  width := w;
  setpal( p );
  height := 1;
  zmenu.init( e, a, on, menu );
  insert( newchoicexy( x, y, top, '', off,
                       #255, 255, nil, nil ) );
  add( newchoicexy( x, y + height, bottom, '', off,
                    #255, 255, nil, nil ) );
  high := menu;
  inc( height, 1 );
  inc( width, 1 );
 end;

procedure zbouncemenu.show;
 var
  mv : boolean;
  old : pointer;
 begin
  mv := mvisible;
  old := writeto;
  if mv then showmouse( off );
  writeto := @zokwork;
  greyshadow( tx, ty, tx+width, ty+height - 1 );
  writeto := old;
  zmenu.show;
  if mv then showmouse( on );
 end;

procedure zbouncemenu.format( choice : pzchoice );
 begin
  if choice^.st2 = '' then choice^.st2 := invertstr( choice^.st1 );
  if choice^.st1 <> '' then choice^.st1 := normalstr( choice^.st1 )
    else choice^.st1 := sepbar;
  choice^.x  := tx;
  choice^.x2 := tx + width + 1;
  choice^.y  := ty+height;
  choice^.y2 := ty+height;
  inc( height, 1 );
 end;

function zbouncemenu.normalstr( s: string ) : string;
 begin
   s := cpadstr(s, width, ' ' );
   normalstr := '|!'+zbmb+'|'+zbmf+'³|'+zbmt+ s + '|'+zbmf+'³';
 end;

function zbouncemenu.invertstr( s: string ) : string;
 begin
   s := cpadstr(s, width, ' ' );
   Invertstr :=
      '|!'+zbmb+'|'+zbmf+'³|!'+zbhb+'|'+zbhf+s+'|!'+zbmb+'|'+zbmf+'³';
 end;

function zbouncemenu.top : string;
 begin
   top := '|!'+zbmb+'|'+zbmf+ 'Ú' + chntimes( 'Ä', width ) + '¿';
 end;

function zbouncemenu.sepbar : string;
 begin
  sepbar := '|!'+zbmb+'|'+zbmf+'Ã' + chntimes( 'Ä', width ) + '´';
 end;

function zbouncemenu.bottom : string;
 begin
  bottom := '|!'+zbmb+'|'+zbmf+'À' + chntimes( 'Ä', width ) + 'Ù';
 end;

function newbouncemenu( x, y, w : byte; p:string; e, a : boolean;
                        menu : pzchoice ) : pzbouncemenu;
 begin
  newbouncemenu := new( pzbouncemenu, init( x, y, w, p, e, a, menu ));
 end;


constructor zmenubar.init( x, y : byte; p : string; e, a : boolean;
                           menu : pzchoice );
 var
  m : pzchoice;
 begin
  tx := x;
  ty := y;
  width := 0;
  setpal( p );
  zmenu.init( e, a, on, menu );
 end;

procedure zmenubar.handle( ch : char );
 begin
  if ch <> #32 then
   zmenu.handle( ch )
  else
   if shortcut( ' ' ) <> nil then
    begin
     setto( shortcut( ' ' ));
     if submenu <> nil then
      begin
       subactive := true;
       submenu^.reset;
       subactive := submenu^.high <> nil;
     end;
    end;
 end;

procedure zmenubar.handlestripped( ch : char );
 begin
  case ch of
   #2 : handle( #32 ); {alt-space}
   #71, #73, { home, pageup, }
   #79, #81, { end,  pgdown, }
   #72, #80 : if subactive then submenu^.handlestripped( ch ); { up & down }
   #75 : begin { go to prev one }
          subactive := false; { turn off submenu now }
          zmenu.handlestripped( #72 );
          if submenu <> nil then
           begin
            subactive := true;
            submenu^.reset;
            subactive := submenu^.high <> nil;
           end;
         end;
   #77 : begin { go to next one }
          subactive := false; { turn off submenu }
          zmenu.handlestripped( #80 );
           if submenu <> nil then
            begin
             subactive := true;
             submenu^.reset;
             subactive := submenu^.high <> nil;
            end;
         end;
    { and the alt keys: }
    #16..#25 : if shortcut( alt16to25[ byte( ch )-15 ] ) <> nil then
                setto(shortcut( alt16to25[ byte( ch )-15 ] ));
    #30..#38 : if shortcut( alt30to38[ byte( ch )-29 ] ) <> nil then
                setto(shortcut( alt30to38[ byte( ch )-29 ] ));
    #44..#50 : if shortcut( alt44to50[ byte( ch )-43 ] ) <> nil then
                setto(shortcut( alt44to50[ byte( ch )-43 ] ));
   else
    zmenu.handlestripped( ch );
  end;
 end;

procedure zmenubar.format( choice : pzchoice );
 begin
  zmenu.format( choice );
  choice^.y := ty;
  choice^.y2 := ty;
  choice^.x := tx + width;
  width := width + clength( choice^.st1 ) -1;
  choice^.x2 := tx + width;
 end;

function newmenubar( x, y : byte; p : string; e, a : boolean;
                     menu : pzchoice ) : pzmenubar;
 begin
  newmenubar := new( pzmenubar, init( x, y, p, e, a, menu ));
 end;

constructor ZInput.Init(a,b,tl,dl,tc,ac:byte; esc:boolean; start : string );
 begin
  zobj.init( a, b, a, b );
  tlen := tl;
  dlen := dl;
  tcol := tc;
  acol := ac;
  cpos := 1;
  escexits := esc;
  back := start;
  strg := start;
  isdone := false;
  frst := true;
  tovr := false;
  d1st := 1;
 end;

constructor ZInput.Default( a, b, tl, dl : byte; start : string );
 begin
  init( a, b, tl, dl, $4E, $07, true, start );
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
   length(strg) > dlen
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
   #27 : if escexits then
           begin      { esc }
            strg := back;
            finish;
           end;
   #71 : movecursor( 1 ); { home }
   #75 : movecursor( cpos-1 ); { left }
   #77 : movecursor( cpos+1 ); { right }
   #79 : begin
          movecursor( 1 );
          movecursor( length(strg)+1 ); { end }
         end;
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
  zinput.init(a,b,tl,dl,tc,ac,true,start);
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
  i.init( x + 1 + clength( s2 ), y + 2, l, l, $4E, $07, true, '' );
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