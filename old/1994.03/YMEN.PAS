{$M 28408,0,65536} {needs larger than normal stack, not as much heap}
program ymenu;
uses crt, crtstuff, zokstuff, filstuff, dos, moustuff;

const
 prg = true;
 sub = false;

type
 menuchoice = record
  MenuText : string[ 36 ];
  Password : string[ 15 ];
  InfoText : String[ 72 ];
  InfoAttr : Byte;
  PrgOrSub : boolean;
  Drive    : Char;   { = 0 if blank }
  Path     : string;
  Filename : string[ 11 ];
  Paramchk : Boolean;
  Params   : String;
  SaveParams,
  PausAftr : Boolean;
 end;
 zymenu = object( zmenu )
  procedure show; virtual;
  procedure handle( ch : char ); virtual;
 end;
const
 none   = 0;
 single = 1;
 double = 2;
 solid  = 3;
 nullchoice : menuchoice = (
   menutext : '                                    ';
   password : '';
   InfoText : '';
   InfoAttr : $07;
   PrgOrSub : prg;
   Drive    : '0';
   Path     : '';
   Filename : '';
   Paramchk : false;
   Params   : '';
   SaveParams  : false;
   PausAftr : false );
 clipbrd = 11;
 shell   = 0;

var
 done : boolean;
 refresh : boolean;
 temp : screentype;
 showtime : boolean;
 yf : text;
 menufile : string;
 choice : byte;
 data : array[ shell .. clipbrd ] of menuchoice; { 12 total : 10, clip, shell }
 menu : zymenu;
 eraser : pointer;
{--general-variables--}
 blinkon    ,
 banneron   ,
 f1helpon   ,
 clockon    ,
 shadowson  ,
 infoboxon  ,
 startupPW  ,
 menubarPW  : boolean;
 sPassword  ,
 mPassword  : string[ 15 ];
 pausestr   : string;
 aPassword  : zpassword;
 background : word;
{--banner-box-variables--}
 bannerborder,
 bannerfore,
 bannerback,
 clockcol,
 f1helpcol,
 bannertext : byte;
 bannerstring : string[ 58 ];
{--menu-box-variables--}
 menuborder,
 menufore,
 menuback,
 menutext,
 highfore,
 highback,
 menunums,
 menuparentheses  : byte;
{--info-box-variables--}
 infoborder,
 infofore,
 infoback  : byte;
{--dialog/help-box-variables--}
 diafore,
 diaback,
 diatext,
 diahifore,
 diahiback,
 diafieldfore,
 diafieldback,
 diafieldcurs  : byte;
{--Confirmation-things--}
 confirm : zconfirmbox;

procedure stamptemp;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  screen := temp;
  showmouse( mv );
 end;

procedure savetemp;
 var
  mv : boolean;
 begin
  mv := mvisible;
  showmouse( off );
  temp := screen;
  showmouse( mv );
 end;

procedure loadconfig;
 var
  cfg : file;
 begin
  if
   fileexists('YMENU.CFG')
  then
   begin
    filereset( cfg, 'YMENU.CFG');
    blinkon := nextboolean( cfg );
    banneron := nextboolean( cfg );
    f1helpon := nextboolean( cfg );
    clockon := nextboolean( cfg );
    shadowson := nextboolean( cfg );
    infoboxon := nextboolean( cfg );
    startupPW := nextboolean( cfg );
    menubarPW := nextboolean( cfg );
    sPassword := nextstring( cfg );
    mPassword := nextstring( cfg );
    Pausestr := nextstring( cfg );
    background := nextword( cfg );
    bannerborder := nextbyte( cfg );
    bannerfore := nextbyte( cfg );
    bannerback := nextbyte( cfg );
    clockcol := nextbyte( cfg );
    f1helpcol := nextbyte( cfg );
    bannertext := nextbyte( cfg );
    bannerstring := nextstring( cfg );
    menuborder := nextbyte( cfg );
    menufore := nextbyte( cfg );
    menuback := nextbyte( cfg );
    menutext := nextbyte( cfg );
    highfore := nextbyte( cfg );
    highback := nextbyte( cfg );
    menunums := nextbyte( cfg );
    menuparentheses := nextbyte( cfg );
    infoborder := nextbyte( cfg );
    infofore := nextbyte( cfg );
    infoback := nextbyte( cfg );
    diafore := nextbyte( cfg );
    diaback := nextbyte( cfg );
    diatext := nextbyte( cfg );
    diahifore := nextbyte( cfg );
    diahiback := nextbyte( cfg );
    diafieldfore := nextbyte( cfg );
    diafieldback := nextbyte( cfg );
    diafieldcurs := nextbyte( cfg );
   end
  else
   begin
    blinkon := true;
    banneron := true;
    f1helpon := true;
    clockon := true;
    shadowson := true;
    infoboxon := true;
    startupPW := false;
    menubarPW := false;
    sPassword := '';
    mPassword := '';
    Pausestr := '|BPress any key to return to |WYM|Ge|WN|Gu|B...';
    background := bluebox;
    bannerborder := single;
    bannerfore := darkgray;
    bannerback := black;
    clockcol := yellow;
    f1helpcol := yellow;
    bannertext := white;
    bannerstring := 'YMenu Version 1.0? But then, YNot? ';
    menuborder := single;
    menufore := darkgray;
    menuback := black;
    menutext := white;
    highfore := yellow;
    highback := red;
    menunums := white;
    menuparentheses := lightblue;
    infoborder := single;
    infofore := darkgray;
    infoback := black;
    diafore := darkgray;
    diaback := black;
    diatext := white;
    diahifore := lightcyan;
    diahiback := blue;
    diafieldfore := yellow;
    diafieldback := red;
    diafieldcurs := lightred;
   end;
  showtime := banneron and clockon;
 end;

procedure erasemenu;
 begin
  release( eraser );
 end;


procedure checkparams;
 var
  v, c : integer;
  ch : char;
 begin
  if
   paramcount = 0
  then
   menufile := 'YMENU'
  else
   begin
    menufile := upstr( paramstr( 1 ) );
    if
     paramcount >= 2
    then
     begin
      val( paramstr( 2 ), v, c );
      if c = 0 then choice := v;
     end;
   end;
  if (paramcount >= 3) and (paramstr(3) = 'PAUSE') then
   begin
    cwritexy( 1, 25, pausestr );
    repeat
     gettextmpos
    until keypressed or (ms and 3 <> 0);
    while keypressed do ch := readkey;
   end;
 end;

procedure makemenu;
 var
  c, counter : byte;
  p,n,b,hf,hb,mb,mt : char;
  g : string[ 1 ];
 begin
  menu.init( menufile <> 'YMENU' );
  p := ccolors[ menuparentheses ];
  n := ccolors[ menunums ];
  b := ccolors[ menuback ];
  hf := ccolors[ highfore ];
  hb := ccolors[ highback ];
  mb := ccolors[ menuback ];
  mt := ccolors[ menutext ];
  for
   counter := 1 to 10
  do
   begin
    if
     counter = 10
    then
     c := 0
    else
     c := counter;
    menu.add( 20, counter + 6,
       '|!'+mb+' |'+p+'(|'+n+ N2S( c ) + '|'+p+') |'+mt + data[counter].MenuText,
       '|!'+hb+' |'+p+'(|'+n+ N2S( c ) + '|'+p+') |'+hf + data[counter].MenuText,
       true, char( 48 + c ), counter );
   end;
   g := n2s( choice mod 10 );
   menu.seton( menu.shortcut( g[1] ) );
 end;

procedure loadchoices( whichmenu : string );
 var
  yfile   : file of menuchoice;
  counter : byte;
 begin
  if
   fileexists( whichmenu + '.MNU' )
  then
   begin
    { load menu from disk }
    assign( yfile, whichmenu + '.MNU' );
    reset( yfile );
    for
     counter := 1 to 10
    do
     begin
      read( yfile, data[ counter ] );
     end;
    close( yfile );
   end
  else
   begin
    { create a blank menu }
    for
     counter := 1 to 10
    do
     data[ counter ] := nullchoice;
   end;
 end;

procedure savechoices( whichmenu : string );
 var
  yfile   : file of menuchoice;
  counter : byte;
 begin
  assign( yfile, whichmenu + '.MNU' );
  rewrite( yfile );
  for
   counter := 1 to 10
  do
   begin
    write( yfile, data[ counter ] );
   end;
  close( yfile );
 end;

procedure statusline( s : string );
 begin
  fillbox( 1, 25, 80, 25, $0F20 );
  ccenterxy( 40, 25, s );
 end;

procedure delchoice;
 begin
  confirm.init( 30, 7, diaback * 16 + diafore,
   '|WReally Delete ##'+n2s(choice)+'?', 'Y/N' );
  if confirm.get then
   begin
    data[ choice ] := nullchoice;
    savechoices( menufile );
    refresh := true;
   end;
 end;

procedure edit;
 var
  t,t2 : screentype;
  editdone,
  editdone2 : boolean;
  editmenu,
  editmenu2 : zmenu;
  editptr,
  editptr2  : pointer;
  ntxt, htxt, rtxt : string[ 5 ];
  tcol, acol : byte;
  ch : char;
  mc : menuchoice;
  title,
  info : zinput;
  passwd : zpassword;
  icolor : zcolor;
  progsub : ztoggle;
  procedure programedit;
   var
    drive,
    path,
    filenm,
    param : zinput;
    sprm, pprm, wwd : zyesno;
    d : string;
   begin
    mark( editptr2 );
    t2 := screen;
    editdone2 := false;
    fillbox( 1, 6, 80, 18, background );
    bar( 4, 8, 77, 15, diaback * 16 + diafore );
    if shadowson then greyshadow( 4, 8, 77, 15 );
    editmenu2.init( true );
    editmenu2.add(  6,  9, ntxt+'Drive',     htxt+'Drive',  true, 'ª', 1 );
    cwritexy( 11, 9, rtxt+':');
    editmenu2.add( 31,  9, ntxt+'Path',      htxt+'Path',   true, '«', 2 );
    cwritexy( 35, 9, ':');
    editmenu2.add(  7, 10, ntxt+'File',      htxt+'File',   true, '¬', 3 );
    cwritexy( 11, 10, ':');
    editmenu2.add( 30, 10, ntxt+'Param',     htxt+'Param',  true, '­', 4 );
    cwritexy( 35, 10, ':');
    editmenu2.add(  7, 12, ntxt+'Prompt for params', htxt+'Prompt for params', true, '®', 5 );
    cwritexy( 24, 12, '?');
    editmenu2.add( 31, 12, ntxt+'Save params', htxt+'Save params', true, '¯', 6 );
    cwritexy( 42, 12, '?');
    editmenu2.add( 49, 12, ntxt+'Wait for key when done', htxt+'Wait for key when done', true, '°', 7 );
    cwritexy( 71, 12, '?');
    editmenu2.add( 33, 14, ntxt+'Save and Return', htxt+'Save and Return', true, '±', 8 );
    cwritexy( 48, 14, '...');
    colorxy( 4, 11, diaback*16+diafore, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
    colorxy( 4, 13, diaback*16+diafore, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
    d := mc.drive;
    drive.init( 13, 9, 1, 1, tcol, acol, d );
    drive.show;
    path.init( 37, 9, 50, 36, tcol, acol, mc.path );
    path.show;
    filenm.init( 13, 10, 12, 12, tcol, acol, mc.filename );
    filenm.show;
    param.init( 37, 10, 240, 36, tcol, acol, mc.params );
    param.show; doscursoroff;
    pprm.init( 26, 12, tcol, mc.paramchk );
    pprm.show;
    sprm.init( 44, 12, tcol, mc.saveparams );
    sprm.show;
    wwd.init( 72, 12, tcol, mc.pausaftr );
    wwd.show;
    editmenu2.show;
    repeat
     case editmenu2.get of
      1 : begin
           d := drive.get;
           mc.drive := d[ 1 ];
           editmenu2.setto( editmenu2.shortcut( '«' ) );
          end;
      2 : begin
           mc.path := path.get;
           editmenu2.setto( editmenu2.shortcut( '¬' ) );
          end;
      3 : begin
           mc.filename := filenm.get;
           editmenu2.setto( editmenu2.shortcut( '­' ) );
          end;
      4 : begin
           mc.params := param.get;
           editmenu2.setto( editmenu2.shortcut( '®' ) );
          end;
      5 : begin
           mc.paramchk := pprm.toggle;
           editmenu2.setto( editmenu2.shortcut( '¯' ) );
          end;
      6 : begin
           mc.saveparams := sprm.toggle;
           editmenu2.setto( editmenu2.shortcut( '°' ) );
          end;
      7 : begin
           mc.pausaftr := wwd.toggle;
           editmenu2.setto( editmenu2.shortcut( '±' ) );
          end;
      8 : begin
           data[ choice ] := mc;
           savechoices( menufile );
           refresh := true;
           editdone := true;
           editdone2 := true;
          end;
      255 : editdone2 := true; { discard changes, return to previous menu }
     end;
    until editdone2;
    screen := t2;
    release( editptr2 );
   end;

  procedure submenuedit;
   var
    filenm : zinput;
   begin
    mark( editptr2 );
    t2 := screen;
    editdone2 := false;
    fillbox( 1, 6, 80, 18, background );
    bar( 4, 9, 77, 13, diaback * 16 + diafore );
    if shadowson then greyshadow( 4, 9, 77, 13 );
    editmenu2.init( true );
    editmenu2.add( 25, 10, ntxt+'Submenu Filename', htxt+'Submenu Filename',  true, 'ª', 1 );
    editmenu2.add( 33, 12, ntxt+'Save and Return', htxt+'Save and Return', true, '«', 2 );
    cwritexy( 41, 10, rtxt+':' );
    colorxy( 4, 11, diaback*16+diafore, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
    filenm.init( 43, 10, 8, 8, tcol, acol, mc.filename );
    filenm.show; doscursoroff;
    editmenu2.show;
    repeat
     case editmenu2.get of
      1 : begin
           mc.filename := filenm.get;
           editmenu2.setto( editmenu2.shortcut( '«' ) );
          end;
      2 : begin
           data[ choice ] := mc;
           savechoices( menufile );
           refresh := true;
           editdone := true;
           editdone2 := true;
          end;
      255 : editdone2 := true; { discard changes, return to previous menu }
     end;
    until editdone2;
    screen := t2;
    release( editptr2 );
   end;

 begin
  mark( editptr );
  t := screen;
  editmenu.init( true );
  editdone := false;
  mc := data[ choice ];
  fillbox( 1, 6, 80, 18, background );
  fillbox( 1, 25, 80, 25, $0F20 );
  ntxt := '|!'+ccolors[ diaback ] + '|' + ccolors[ diatext ];
  htxt := '|!'+ccolors[ diahiback ] + '|' + ccolors[ diahifore ];
  rtxt := '|!'+ccolors[ diaback ] + '|' + ccolors[ diafore ];
  statusline( '|!k|w Use |B<|WTab|B>|K/|WShift|K-|B<|WTab|B>|w to move '+
              'cursor|K,|w press |B<|WEsc|B> |wto discard changes|K...' );
  bar( 4, 8, 77, 15, diaback * 16 + diafore );
  editmenu.add(  6,  9, ntxt+'Title',     htxt+'Title',     true, 'ª', 1 );
  editmenu.add( 51,  9, ntxt+'Password',  htxt+'Password',  true, '«', 2 );
  editmenu.add(  7, 10, ntxt+'Info',      htxt+'Info',      true, '¬', 3 );
  editmenu.add( 50, 10, ntxt+'InfoColor', htxt+'InfoColor', true, '­', 4 );
  editmenu.add( 27, 12, ntxt+'Program or Submenu', htxt+'Program or Submenu', true, '®', 5 );
  editmenu.add( 37, 14, ntxt+'More', htxt+'More', true, '¯', 6 );
  cwritexy( 11,  9, rtxt+':' ); {title}
  cwritexy( 11, 10, ':' );      {info}
  cwritexy( 59,  9, ':' );      {password}
  cwritexy( 59, 10, ':' );      {infocolor}
  cwritexy( 45, 12, '?' );      {prog/submenu}
  cwritexy( 41, 14, '...');     {more}
  tcol := diafieldback * 16 + diafieldfore;
  acol := diaback * 16 + diafore;
  title.init( 13, 9, 35, 35, tcol, acol, unpadstr(mc.menutext,' '));
  title.show;
  passwd.init( 61, 9, 15, 15, tcol, acol, 'þ', mc.password );
  passwd.show;
  info.init( 13, 10, 72, 35, tcol, acol, mc.infotext );
  info.show; doscursoroff;
  progsub.init( 47, 12, tcol, 'Program', 'Submenu', mc.prgorsub );
  progsub.show;
  icolor.init( 61, 10, tcol, acol, mc.infoattr );
  icolor.show;
  colorxy( 4, 11, acol, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
  colorxy( 4, 13, acol, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
  editmenu.show;
  if shadowson then greyshadow( 4, 8, 77, 15 );
  repeat
   case editmenu.get of
    1 : begin
         mc.menutext := padstr( title.get, 36, ' ' );
         editmenu.setto( editmenu.shortcut( '«' ) );
        end;
    2 : begin
         mc.password := passwd.get;
         editmenu.setto( editmenu.shortcut( '¬' ) );
        end;
    3 : begin
         mc.infotext := info.get;
         editmenu.setto( editmenu.shortcut( '­' ) );
        end;
    4 : begin
         mc.infoattr := icolor.get;
         editmenu.setto( editmenu.shortcut( '®' ) );
        end;
    5 : begin
         mc.prgorsub := progsub.toggle;
         editmenu.setto( editmenu.shortcut( '¯' ) );
        end;
    6 : if mc.prgorsub then programedit else submenuedit;
    255 : editdone := true; { discard changes }
   end;
  until editdone;
  screen := t;
  release( editptr );
 end;

procedure drawclock( banner : boolean );
 var
  col : byte;
 begin
  if
   banner then col := bannerback * 16 + clockcol
  else
   col := menuback * 16 + menutext;
  colorxy( 71, 2, col, time );
 end;

procedure drawbanner;
 begin
  if
   banneron
  then
   begin
    bar( 1, 1, 80, 3, bannerback * 16 + bannerfore );
    if shadowson then greyshadow( 1, 1, 80, 3 );
    if f1helpon then colorxy( 3, 2, bannerback*16+f1helpcol, 'F1=Help' );
    colorxyc( 40, 2, bannerback * 16 + bannertext, bannerstring );
    if showtime then drawclock( true );
   end;
 end;

procedure drawscreen;
 begin
  blinking( blinkon );
  writeto := @temp;
  fillscreen( background );
  drawbanner;
  colorxy( 1, 25, $0F, chntimes( ' ', 80 ) );
  if
   menufile = 'YMENU'
  then
   statusline( '|!k|WYM|Ge|WN|Gu |B(|WC|B)|W1993  '+STERLING+#8+SILVERWARE+
               '  |Ga|WLL R|Gi|WGHTS R|Ge|WS|Ge|WRV|Ge|WD|Y.'  )
  else
   statusline( '|!k|WPress |B<|WEsc|B>|W to return to the previous menu|w...');
  bar( 19, 6, 61, 17, menuback * 16 + menufore );
  if shadowson then greyshadow( 19, 6, 61, 17 );
  menu.reset;
  stamptemp;
  writeto := @screen;
 end;


function pwok : boolean;
 begin
  if (data[choice].password = '') then begin pwok := true; exit; end;
  showmouse(false);
  refresh := true;
  bar( 25, 10, 53, 12, diaback * 16 + diafore );
  greyshadow( 25, 10, 53, 12 );
  colorxy( 26, 11, diaback * 16 + diatext, ' Password: ');
    apassword.init( 37, 11, 15, 15, diafieldback * 16 + diafieldfore,
                            diaback * 16 + diafore, 'þ', '' );
  pwok := upstr( apassword.get) = upstr( data[choice].password);
 end;

procedure drawinfobox;
 begin
  if
   infoboxon
  then
   begin
    bar( 4, 20, 77, 22, infoback * 16 + infofore );
    if shadowson then greyshadow( 4, 20, 77, 22 );
    colorxyc( 40, 21, infoback * 16 + data[ menu.value ].infoattr,
                      data[ menu.value ].infotext )
   end;
 end;

procedure doaltmenu;
 var
  altmenu : zmenu;
  altptr  : pointer;
  ch : char;
  v : byte;
  mn, mp, mb, mf, mt, hb, hf : char;
  mv : boolean;
 procedure dofilemenu;
  var
   filemenu : zbouncemenu;
   fileptr : pointer;
   g : byte;
  begin
   tcolor := $08;
   mark( fileptr );
   filemenu.init( 1, 3, 21, mb+mf+mt+hb+hf, true,
    newline( ' |)|'+mn+'E|(dit            ... ', '', true, 'E', 1,
    newline( ' |)|'+mn+'O|(pen            <ÄÙ ', '', true, 'O', 2,
    newline( ' |)|'+mn+'C|(opy       Ctrl-Ins ', '', true, 'C', 3,
    newline( ' |)|'+mn+'D|(elete     Ctrl-Del ', '', true, 'D', 4,
    newline( ' |)|'+mn+'M|(ove      Shift-Del ', '', true, 'M', 5,
    newbar(
    newline( ' |)|'+mn+'R|(un             ... ', '', true, 'R', 6,
    newbar(
    newline( ' E|)|'+mn+'x|(it to DOS   Alt-X ', '', true, 'X', 7,
   nil ))))))))));
   filemenu.reset;
   repeat
    if
     (shiftstate and altpressed) <> 0
    then
     begin
      repeat until (shiftstate and altpressed) = 0;
      filemenu.handle( #27 );
     end;
    if
     not keypressed
    then
     begin
      gettextmpos;
      if mousemoved then showmouse( on );
      filemenu.domousestuff
     end
    else
     filemenu.handle( readkey );
    drawclock( false );
   until filemenu.endloop;
   g := filemenu.value;
   release( fileptr );
   case g of
    1 : if pwok then begin stamptemp; edit; end;            { edit }
    2 : menu.handle( #13 );                                 { open }
    4 : delchoice;
    7 : begin choice := 255; done := true; end;     { quit }
   end;
  end;
 begin
  mark( altptr );
  savetemp;
  mv := mvisible;
  showmouse( off );
  bar( 1, 1, 80, 3, menuback * 16 + menufore );
  showmouse( mv );
  drawclock( false );
  repeat until (shiftstate and altpressed = 0) or keypressed;
  mb := ccolors[ menuback ];
  mn := ccolors[ menunums ];
  mt := ccolors[ menutext ];
  mf := ccolors[ menufore ];
  mp := ccolors[ menuparentheses ];
  hb := ccolors[ highback ];
  hf := ccolors[ highfore ];
  altmenu.init( true );
  altmenu.add( 2, 2, '|!'+mb+'|'+mp+' (|'+mn+'F|'+mp+')|'+mt+'ile ',
    '|!'+hb+'|'+mp+' (|'+mn+'F|'+mp+')|'+hf+'ile ', true, 'F', 1 );
  altmenu.add( 10, 2,'|!'+mb+'|'+mp+' (|'+mn+'O|'+mp+')|'+mt+'ptions ',
    '|!'+hb+'|'+mp+' (|'+mn+'O|'+mp+')|'+hf+'ptions ', true, 'O', 2 );
  altmenu.add( 21, 2, '|!'+mb+'|'+mp+' (|'+mn+'H|'+mp+')|'+mt+'elp ',
    '|!'+hb+'|'+mp+' (|'+mn+'H|'+mp+')|'+hf+'elp ', true, 'H', 3 );
  altmenu.reset;
  if ( keypressed ) then ch := readkey;
  if ch = #0
   then
    begin
     ch := readkey;
     if
      alt2normal( ch ) in ['F','O','H']
     then
      begin
       altmenu.setto( altmenu.shortcut( alt2normal( ch )));
       altmenu.show;
      end;
    end;
  repeat
   drawclock( false );
   if
    (shiftstate and altpressed <> 0)
   then
    begin
     repeat until (shiftstate and altpressed) =  0;
     altmenu.handle( #27 );
    end;
   if
    not keypressed
   then
    begin
     gettextmpos;
     if mousemoved then showmouse( on );
     altmenu.domousestuff
    end
   else
    begin
     ch := readkey;
     if
      ch = #0
     then
      begin
       ch := readkey;
       if
        (ch = #80) or (ch = #72)
       then
        altmenu.handle( #13 )
       else
        altmenu.handlestripped( ch );
      end
     else
      begin
       altmenu.handle( ch );
      end
    end;
  until altmenu.endloop;
  v := altmenu.value;
  release( altptr );
  case v of
   1 : dofilemenu;
   2 : ;
   3 : ;
  end;
  stamptemp;
 end;


procedure zymenu.show;
 begin
  zmenu.show;
  drawinfobox;
 end;

procedure zymenu.handle( ch : char );
 begin
  if
   (ch = #27)
  then
   begin
    doaltmenu;
    exit;
   end;
  if
   (ch = #13)
  then
   begin
    choice := value;
    if data[ choice ].Drive = nullchoice.drive then exit;
    if not pwok then exit;
    if data[ choice ].prgorsub = Sub then
     begin
      menufile := upstr( data[ choice ].filename );
      loadchoices( menufile );
      exit;
     end;
    end;
  zmenu.handle( ch )
 end;

procedure init;
 begin
  done := false;
  refresh := false;
  choice := 1;
  randomize;
  mark( eraser );
  mouseon;
  setmpos( 0, 0 );
  showmouse(off);
  gettextmpos;
  gettextmpos;
  doscursoroff;
  loadconfig;
  checkparams;
  loadchoices( menufile );
  makemenu;
  drawscreen;
 end;

procedure main;
 var
  ch : char;
  tempv  : byte;
 begin
  repeat
   drawclock( true );
   choice := menu.value;
   if
    refresh
   then
    begin
     erasemenu;
     makemenu;
     drawscreen;
     refresh := false;
    end;
   if
    shiftstate and altpressed <> 0
   then
    begin
     repeat until (shiftstate and altpressed = 0) or keypressed;
     if
      not keypressed
     then
      doaltmenu
     else
      case readkey of
       #0 : case readkey of
             #45 : begin choice := 255; done := true; end; { alt-x }
            end;
      end;
    end
   else { alt not pressed }
    if not keypressed then
     begin
      gettextmpos;
      if mousemoved then showmouse( on );
      menu.domousestuff;
     end
    else
    begin
     showmouse( off );
     ch := readkey;
     case upcase( ch ) of
       #0 : begin
             ch := readkey;
             case ch of
              #83 : begin refresh := true; delchoice; end;
              else menu.handlestripped( ch );
             end;
            end;
      #27, #13 : menu.handle( ch );
      '0'..'9' : begin
                  menu.setto( menu.shortcut( ch ) );
                  menu.handle(#13);
                 end;
      'S' : rnd;
     else
      menu.handle( ch );
     end;
    end;
   if menu.endloop then done := true;
  until done;
 end;

procedure editparams;
 var
  newparams : zinputbox;
 begin
  tcolor := diaback * 16 + diatext;
  newparams.init( 27, 9,  diaback * 16 + diafore,
                  ' Input new parameters. ', ' ', 240);
  newparams.i.dlen := 20;
  newparams.i.acol := diaback * 16 + diafore;
  newparams.i.strg := data[choice].params;
  newparams.i.back := data[choice].params;
  data[choice].params := newparams.get;
  if data[choice].saveparams then savechoices(menufile);
 end;

procedure makebat;
 begin
  if
   choice <> 255
  then
   begin
    showmouse(off);
    assign( yf, '\ytemp.bat' );
    rewrite( yf );
    writeln( yf, '@ECHO OFF' );
    writeln( yf, data[choice].drive + ':' );
    if
     data[choice].path <> ''
    then
     writeln( yf, 'cd ' + data[choice].path );
    if data[choice].paramchk then editparams;
    writeln( yf, 'Call ' + data[choice].filename + ' '
                  + data[ choice ].params );
    writeln( yf, 'c:' );
    writeln( yf, 'cd \');
    write( yf, 'YMENU ' + menufile + ' ' + n2s( choice ));
    if
     data[choice].pausaftr
    then
     writeln( yf, ' PAUSE' )
    else
     writeln( yf );
    close( yf );
   end
  else
   { exit }
 end;

procedure shutdown;
 begin
  showmouse( off );
  doscursoron;
  textattr := $0f;
  blinking( true );
  clrscr;
 end;

begin
 init;
 main;
 makebat;
 shutdown;
end.