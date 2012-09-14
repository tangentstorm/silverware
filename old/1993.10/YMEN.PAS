{$M 17408,0,65536} {needs larger than normal stack, not as much heap}
program ymenu;
uses crt, crtstuff, zokstuff, filstuff,dos;

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
  Drive    : Char;   { = Å if blank }
  Path     : string;
  Filename : string[ 11 ];
  Paramchk : Boolean;
  Params   : String;
  ClrScrn  ,
  PausAftr : Boolean;
 end;
 borders = ( single, double, none, solid );

const
 nullchoice : menuchoice = (
   menutext : '                                    ';
   password : '';
   InfoText : '';
   InfoAttr : $07;
   PrgOrSub : prg;
   Drive    : 'Å';   
   Path     : '';
   Filename : '';
   Paramchk : false;
   Params   : '';
   ClrScrn  : false;
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
 menu : zmenu;
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
 background : word;
{--banner-box-variables--}
 bannerborder : borders;
 bannerfore,
 bannerback,
 clockcol,
 f1helpcol,
 bannertext : byte;
 bannerstring : string[ 58 ];
{--menu-box-variables--}
 menuborder : borders;
 menufore,
 menuback,
 menutext,
 highfore,
 highback,
 menunums,
 menuparentheses  : byte;
{--info-box-variables--}
 infoborder : borders;
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

procedure loadconfig;
 var
  cfg : file;
 begin
  if
   fileexists('YMENU.CFG')
  then
   begin
    filereset( cfg, 'YMENU.CFG')
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
    background := bluebox;
    bannerborder := single;
    bannerfore := darkgray;
    bannerback := black;
    clockcol := yellow;
    f1helpcol := yellow;
    bannertext := white;
    bannerstring := 'YMenu Version 1.0... After all, YNot? ';
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
 begin
  if
   paramcount = 0
  then
   menufile := 'YMENU.MNU'
  else
   begin
    menufile := paramstr( 1 );
    if
     paramcount >= 2
    then
     begin
      val( paramstr( 2 ), v, c );
      if c = 0 then choice := v;
     end;
   end;
 end;

procedure makemenu;
 var
  c, counter : byte;
  p,n,b,hf,hb,mb,mt : char;
  g : string[ 1 ];
 begin
  menu.init( menufile <> 'YMENU.MNU' );
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
       '~'+mb+' |'+p+'(|'+n+ N2S( c ) + '|'+p+') |'+mt + data[counter].MenuText,
       '~'+hb+' |'+p+'(|'+n+ N2S( c ) + '|'+p+') |'+hf + data[counter].MenuText,
       true, char( 48 + c ), counter );
   end;
   g := n2s( choice mod 10 );
   menu.setto( menu.shortcut( g[1] ) );
 end;

procedure loadchoices( whichmenu : string );
 var
  yfile   : file of menuchoice;
  counter : byte;
 begin
  if
   fileexists( whichmenu )
  then
   begin
    { load menu from disk }
    assign( yfile, whichmenu );
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
  assign( yfile, whichmenu );
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

procedure edit;
 var
  t,t2 : screentype;
  editdone,
  editdone2 : boolean;
  editmenu,
  editmenu2 : zmenu;
  editptr,
  editptr2  : pointer;
  ntxt, htxt, rtxt : string[ 4 ];
  tcol, acol : byte;
  ch : char;
  mc : menuchoice;
  title,
  passwd,
  info : zinput;
  icolor : zcolor;
  progsub : ztoggle;

  procedure programedit;
   var
    drive,
    path,
    filenm,
    param : zinput;
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
    editmenu2.add( 31,  9, ntxt+'Path',      htxt+'Path',   true, '«', 2 );
    editmenu2.add(  7, 10, ntxt+'File',      htxt+'File',   true, '¬', 3 );
    editmenu2.add( 30, 10, ntxt+'Param',     htxt+'Param',  true, '­', 4 );
    editmenu2.add(  6, 12, ntxt+'Prompt for params', htxt+'Prompt for params', true, '®', 5 );
    editmenu2.add( 30, 12, ntxt+'Clear screen', htxt+'Clear screen', true, '¯', 6 );
    editmenu2.add( 49, 12, ntxt+'Wait for key when done', htxt+'Wait for key when done', true, '°', 7 );
    editmenu2.add( 33, 14, ntxt+'Save and Return', htxt+'Save and Return', true, '±', 8 );
    colorxy( 4, 11, diaback*16+diafore, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
    colorxy( 4, 13, diaback*16+diafore, 'Ã'+ chntimes( 'Ä', 72 ) + '´' );
    if mc.drive = 'Å' then mc.drive := 'C';
    d := mc.drive;
    drive.init( 13, 9, 1, 1, tcol, acol, d );
    drive.show;
    path.init( 37, 9, 50, 36, tcol, acol, mc.path );
    path.show;
    filenm.init( 13, 10, 12, 12, tcol, acol, mc.filename );
    filenm.show;
    param.init( 37, 10, 50, 36, tcol, acol, mc.params );
    param.show; doscursoroff;
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
      5 :;
      6 :;
      7 :;
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
  ntxt := '~'+ccolors[ diaback ] + '|' + ccolors[ diatext ];
  htxt := '~'+ccolors[ diahiback ] + '|' + ccolors[ diahifore ];
  rtxt := '~'+ccolors[ diaback ] + '|' + ccolors[ diafore ];
  statusline( '~k|w Use |B<|WTab|B>|K/|WShift|K-|B<|WTab|B>|w to move '+
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
  passwd.init( 61, 9, 15, 15, tcol, acol, mc.password );
  passwd.show;
  info.init( 13, 10, 72, 35, tcol, acol, mc.infotext );
  info.show; doscursoroff;
  progsub.init( 47, 12, tcol, 'Program', 'Submenu', mc.prgorsub );
  progsub.show;
  icolor.init( 61, 10, acol, mc.infoattr );
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

procedure drawclock;
 var
  pm : boolean;
  h, m, n : word;
 begin
  gettime( h, m, n, n );
  pm := h > 12;
  if h = 0 then h := 12;
  if
   pm
  then
   h := h mod 12;
  colorxy( 71, 2, clockcol, flushrt( n2s( h ), 2, '0' )
           +':'+ flushrt( n2s( m ), 2, '0' ) );
  if
   pm
  then
   colorxy( 77, 2, clockcol, 'pm' )
  else
   colorxy( 77, 2, clockcol, 'am' );
 end;

procedure drawbanner;
 begin
  if
   banneron
  then
   begin
    bar( 1, 1, 80, 3, bannerback * 16 + bannerfore );
    if shadowson then greyshadow( 1, 1, 79, 3 );
    if f1helpon then colorxy( 3, 2, f1helpcol, 'F1=Help' );
    colorxyc( 40, 2, bannertext, bannerstring );
    if showtime then drawclock;
   end;
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

procedure drawscreen;
 begin
  blinking( blinkon );
  writeto := @temp;
  fillscreen( background );
  drawbanner;
  drawinfobox;
  colorxy( 1, 25, $0F, chntimes( ' ', 80 ) );
  if
   menufile = 'YMENU.MNU'
  then
   statusline( '~k|WYM|Ge|WN|Gu |B(|WC|B)|W1993  '+STERLING+#8+SILVERWARE+
               '  |Ga|WLL R|Gi|WGHTS R|Ge|WS|Ge|WRV|Ge|WD|Y.'  )
  else
   statusline( '~k|WPress |B<|WEsc|B>|W to return to the previous menu|w...');
  bar( 19, 6, 61, 17, menuback * 16 + menufore );
  if shadowson then greyshadow( 19, 6, 61, 17 );
  menu.reset;
  screen := temp;
  writeto := @screen;
 end;

procedure init;
 begin
  done := false;
  refresh := false;
  choice := 1;
  randomize;
  mark( eraser );
  doscursoroff;
  loadconfig;
  checkparams;
  loadchoices( menufile );
  makemenu;
  drawscreen;
 end;

procedure doaltmenu;
 var
  altmenu : zmenu;
  altptr  : pointer;
  ch : char;
  v : byte;
 procedure dofilemenu;
  var
   filemenu : zbouncemenu;
   fileptr : pointer;
   g : byte;
  begin
   mark( fileptr );
   filemenu.init( 1, 3, 21, true,
    newline( ' !|WE@dit            ... ', '', true, 'E', 1,
    newline( ' !|WO@pen            <ÄÙ ', '', true, 'O', 2,
    newline( ' !|WC@opy       Ctrl-Ins ', '', true, 'C', 3,
    newline( ' !|WD@elete     Ctrl-Del ', '', true, 'D', 4,
    newline( ' !|WM@ove      Shift-Del ', '', true, 'M', 5,
    newbar(
    newline( ' !|WR@un             ... ', '', true, 'R', 6,
    newbar(
    newline( ' !|WQ@uit to DOS         ', '', true, 'Q', 7,
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
    if keypressed then filemenu.handle( readkey );
   until filemenu.endloop;
   g := filemenu.value;
   release( fileptr );
   case g of
    1 : begin screen := temp; edit; end;
    7 : begin choice := 255; done := true; end;
   end;
  end;
 begin
  mark( altptr );
  temp := screen;
  bar( 1, 1, 80, 3, menuback * 16 + menufore );
  cwritexy( 2, 2, '~k |B(|WF|B)|Wile  |B(|WO|B)|Wptions  |B(|WH|B)|Welp');
  drawclock;
  repeat until (shiftstate and altpressed = 0) or keypressed;
  altmenu.init( true );
  altmenu.add( 2, 2, '~k|B (|WF|B)|Wile ', '~r|Y |B(|WF|B)|Yile ',
               true, 'F', 1 );
  altmenu.add( 10, 2, '~k|B (|WO|B)|Wptions ', '~r|Y |B(|WO|B)|Yptions ',
               true, 'O', 2 );
  altmenu.add( 21, 2, '~k|B (|WH|B)|Welp ', '~r|Y |B(|WH|B)|Yelp ',
               true, 'H', 3 );
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
   drawclock;
   if
    (shiftstate and altpressed <> 0)
   then
    begin
     altmenu.endloop := true;
     repeat until (shiftstate and altpressed) =  0;
    end;
   if
    keypressed
   then
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
  screen := temp;
  drawclock;
 end;

procedure main;
 var
  ch : char;
  tempv  : byte;
 begin
  repeat
   drawclock;
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
    doaltmenu
   else { alt not pressed }
    if keypressed then
    begin
     ch := readkey;
     case upcase( ch ) of
      #27 : ;
      #13 : if
             data[ choice ].prgorsub = Sub
            then
             begin
              menufile := data[ choice ].filename;
              loadchoices( menufile );
              refresh := true;
             end
            else
             if
              data[ choice ].drive <> 'Å'
             then
              menu.handle( ch );
      '0'..'9' : begin
                  tempv := s2n( ch );
                  if tempv = 0 then tempv := 10;
                  choice := tempv;
                  if
                   data[ tempv ].prgorsub = sub
                  then
                   begin
                    menufile := data[ tempv ].filename;
                    loadchoices( menufile );
                    refresh := true;
                   end
                  else
                   if
                    data[ tempv ].drive = 'Å'
                   then
                    begin
                     menu.setto( menu.shortcut( ch ) );
                     menu.show;
                    end
                   else
                    menu.handle( ch );
                 end; { '0'..'9' : begin... }
      'S' : rnd;
     else
      menu.handle( ch );
     end;
     drawinfobox;
    end;
   if menu.endloop then done := true;
  until done;
 end;

procedure makebat;
 begin
  if
   choice <> 255
  then
   begin
    assign( yf, '\ytemp.bat' );
    rewrite( yf );
    writeln( yf, '@ECHO OFF' );
    writeln( yf, data[choice].drive + ':' );
    if
     data[choice].path <> ''
    then
     writeln( yf, 'cd ' + data[choice].path );
    writeln( yf, 'Call ' + data[choice].filename + ' '
                  + data[ choice ].params );
    writeln( yf, 'c:' );
    writeln( yf, 'cd \');
    writeln( yf, 'YMENU ' + menufile + ' ' + n2s( choice ));
    close( yf );
   end
  else
   { exit }
 end;

procedure shutdown;
 begin
  doscursoron;
  textattr := $0f;
  blinking( true );
  ClrScr;
 end;

begin
 init;
 main;
 makebat;
 shutdown;
end.