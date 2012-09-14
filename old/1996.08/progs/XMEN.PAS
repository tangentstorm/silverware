{$M 20284,0,20000} {needs larger than normal stack, not as much heap}
{$R-}
{$S-}
program xmen;
uses vuestuff,crtstuff, zokstuff, crt, filstuff, moustuff, dos;

{$I XMTAGG}

const
 version = '1.9à';

procedure savestuff; forward;


procedure exec( Path, CmdLine: string );
 begin
  swapvectors;
  dos.exec( path, cmdline );
  swapvectors;
  if doserror <> 0 then
   begin
    cwrite('|_|Y<|RErRoR|G!!|Y> |W');
    case doserror of
      2 : cwrite('|CCOMMAND|c.|CCOM|W not found');
      3 : cwrite('Path not found');
      5 : cwrite('Access denied');
      6 : cwrite('Invalid handle');
      8 : cwrite('Not enough memory|r:|W try putting a |r"|Y;|r"|W before the command');
     10 : cwrite('Invalid environment');
     11 : cwrite('Invalid format');
     18 : cwrite('No more files');
    else
     cwrite('Somethin|r''|Ws screwed|r...'+
     ' |WGlad |r-|R=|Y=|r[|WI|r]|Y=|R=|r- |Wdidn|r''|Wt do it');
    end;
    cwriteln('|r...');
  end;
 end;

type
 xmproc = procedure( cline : string );
 xmcomm = record
  s : string;
  p : xmproc;
 end;
 options = record
  shortcut,
  MenuText ,
  Path     ,
  Filename : String;
 end;
 xlistviewer = object (listviewer)
  procedure dowhilelooping; virtual;
 end;


const
 prompt1 = '|_|B|^P|_|Rxmenu|Y>|W';
 prg = true;
 sub = false;

type
 zprompt = object( zinput )
   history : array[ $0 .. $F ] of string;
   historyx, historyr : byte;
   procedure inithist;
   Procedure handlestripped( ch : char ); virtual;
 end;
 zxmenu = object( zmenu )
  procedure dowhilelooping; virtual;
 end;

 procedure zprompt.inithist;
  var counter : byte;
  begin
   for counter := $0 to $F do history[counter] := ''; {clear thing, x=9}
   historyr := 0;
   historyx := 0;
  end;

 procedure zprompt.handlestripped( ch : char );
  begin
   case ch of
    #27 : begin strg := ''; handlestripped( #79 ); end;
    #61,  {f3}
    #72 : begin {show last one}
           strg := history[historyx];
           historyx := decwrap( historyx, 1, $0, $F );
           handlestripped( #79 );
          end; { show last one}
    #80 : begin {show next one}
           strg := history[historyx];
           historyx := incwrap( historyx, 1, $0, $F );
           handlestripped( #79 );
          end;
    else zinput.handlestripped( ch );
   end;
  end;


var
 h, m, s, hund : Word;
 min,om : word;
 z : zprompt;
 p : zpassword;
 dirtemp : string;
 exitchoice : boolean;
 xcs : string; {xmenu command string}
 xf : text;
 xprompt : string;
 appmenu : zxmenu;
 result : byte;
 refresh, done : boolean;
 clockon : boolean;
 menufile : string;
 numentries : byte;
 choice : byte;
 counter : byte;
 data : array[ 1 .. 20 ] of options;
 confirm : zconfirmbox;
{---}
 clockcol,bannerback, bannerfore : byte;
 diaback, diafore, diatext, diafieldback, diafieldfore : byte;
 bannertext : byte;
 bannerstring : string;

procedure drawclock;
 var
  col : byte;
  q : pointer;
 begin
  q := writeto;
  writeto := @screen;
  col := bannerback * 16 + clockcol;
  colorxy( 59, 1, col, stardate + ' ' );
  GetTime(h,m,s,hund);
  if m <> om then inc( min );
  om := m;
  if min >= 2 then
   begin
    tymax := 29;
    rnd;
    tymax := 25;
    GetTime(h,om,s,hund);
    min := 0;
   end;
  writeto := q;
 end;

 procedure zxmenu.dowhilelooping;
  begin
   drawclock;
  end;

 procedure xlistviewer.dowhilelooping;
  begin
   drawclock;
  end;



function pwok : boolean;
 begin
{  if (data[choice].password = '') then begin pwok := true; exit; end;
  showmouse(false);
  refresh := true;
  bar( 25, 10, 53, 12, diaback * 16 + diafore );
  greyshadow( 25, 10, 53, 12 );
  colorxy( 26, 11, diaback * 16 + diatext, ' Password: ');
    p.init( 37, 11, 15, 15, diafieldback * 16 + diafieldfore,
                            diaback * 16 + diafore, 'þ', '' );
  pwok := upstr( p.get) = upstr( data[choice].password); }
 end;

procedure Navigator;
 var
  x,y,i :byte;
  ch : char;
  dirmenu: Zxmenu;
  quitdir : boolean;
  derror : word;
  dirinfo : searchrec;
  blah : pointer;
 begin
  x := txpos; y := typos;
  dosscreen := screen;
  tymin := 1;
  doscursoroff;
  quitdir := no;
  repeat
   mark( blah );
   showmouse(off);
   screen := dosscreen;
   showmouse(on);
   dirmenu.init( on, on, on,
    newchoicexy( 1, 2, '|!w|kÚ|#Ä10¿|!k ', '', false, #255, 0, nil, nil ));
   numentries := 0;
   findfirst('*.*', anyfile, DirInfo);
   derror := doserror;
   while derror = 0 do
    begin
     if ((dirinfo.attr and directory) <> 0)
     and ((dirinfo.attr and hidden) = 0) then
      begin
       if dirinfo.name = '.' then dirinfo.name := '\';
       dirmenu.add( newchoicexy( 1, numentries + 3,
                   '|!w|k³|k '+padstr(Dirinfo.name,8,' ')+' ³|!k ',
                   '|!w|k³|!b|W '+padstr(Dirinfo.name,8,' ')+' |!w|k³|!k ',
                   true, #255, 50, nil, nil ));
       inc( numentries );
      end;
     findnext(dirinfo);
     derror := doserror;
    end;
   for i := 3 to 26 do
     if (disksize(i) <> -1) then
      begin
       dirmenu.add( newchoicexy( 1, numentries + 3,
                    '|!w|k³|k|# 03['+char(i+ord('a')-1)+':]|# 03³|!k ',
                 '|!w|k³|!b|W|# 03['+char(i+ord('a')-1)+':]|# 03|!w|k³|!k ',
                 true, #255, i, nil, nil ));
       inc( numentries );
      end;
   dirmenu.add (
    newchoicexy( 1, numentries+3, '|!w|kÀ|#Ä10Ù|!k ', '', false, ' ', 0, nil,
    newchoicexy( 2, numentries+4, '|!k|# 12', '', false, #255, 0, nil, nil )));
  i := dirmenu.get;
  case i of
   255 : quitdir := true;
   50 : {$i-} chdir( wordn(cstrip(dirmenu.high^.st1),2)); {$i+}
   3..26 :{$i-} chdir( char(i+ord('a')-1)+':' );{$i+}
  end; {case}
  release( blah );
 until quitdir;
  showmouse( off );
  tymin := 2;
  screen := dosscreen;
  gotoxy( x + txmin - 1, y + tymin - 1);
  doscursoron;
 end;

{$F+}
procedure help( cline : string );
 begin
  cwriteln('|b|#Ä55');
  cwriteln('|WXMenu commands |r(|WRegular DOS commands also valid|r):');
  cwriteln('|b|#Ä55|W');
  cwriteln('|Y?|w.............|Wthis help message');
  cwriteln('|Yx|w.............|Wexit XMenu');
  cwriteln('|Yadl|w...........|WAdvanced Directory Lister');
  cwriteln('|Ycd|w............|Wchange directory');
  cwriteln('|Ycls|w...........|Wclear the screen');
  cwriteln('|YEcho|w..........|WEcho something');
  cwriteln('|YEmpty|w.........|WEmpties trash');
  cwriteln('|YPrompt|w........|WSet the Prompt');
  cwriteln('|Ynow|w.......|Wshow the time and date');
  cwriteln('|Yrnd|w...........|Wturns on the screen saver');
  cwriteln('|Ytrash|w.........|Wshows the TRASH directory');
  cwriteln('|b|#Ä55');
  cwriteln('|WPlacing a semicolon |r(|Y;|r)|W at the start of the command|_'+
           'line removes XMenu from memory while the program runs|r.');
  cwriteln('|b|#Ä55');
 end;

procedure moo( cline : string );
 begin
  word(writeto) := word(@screen) + 4000;
  colorxy( 1, 1, 8, chntimes( 'Ä', 80 ) );
  colorxy( 1, 2, 8, chntimes( ' ', 80 ) );
  colorxy( 1, 3, 8, chntimes( ' ', 80 ) );
  colorxy( 1, 4, 8, chntimes( ' ', 80 ) );
  writeto := @screen;
 end;

procedure cd( cline : string );
 begin
  {$I-}
  chdir( wordn( cline,1 ) );
  if IOResult <> 0 then
   cwriteln('|WNo can do|r, |Wman|r...');
  {$I+}
 end;

procedure cls( cline : string );
 begin
  cwrite('|$');
 end;

procedure del( cline : string );
 begin
  exec( getenv( 'COMSPEC' ), '/c move '+ cline + ' c:\extras\trash')
 end;

procedure empty( cline : string );
 begin
  exec( getenv( 'COMSPEC' ), '/c del c:\extras\trash');
 end;

procedure echo( cline : string );
 begin
  cwriteln( cline );
 end;

procedure trash( cline : string );
 begin
  exec( getenv( 'COMSPEC' ), '/c adl c:\extras\trash' );
 end;

procedure ver( cline : string );
 begin
  cwrite( '|_|WXMenu version |Y'+ version + '|r...' );
  exec( getenv( 'COMSPEC' ), '/c ver' );
  txpos := wherex + txmin -1;
  typos := wherey + tymin -1;
 end;

procedure prompt( cline : string );
 var
  new : zinput;
 begin
  if cline = '' then
   begin
    cwrite('|_|WPrompt|r: |Wedit prompt|r, |Wor type |r"|Wdefault|r"|W for '+
     'standard prompt|r...|_|Y>');
    new.init( txpos, typos+1, 78, 78, $0B, $00, true, xprompt );
    cline := new.get;
   end;
  xprompt := cline;
  if upstr(cline) = 'DEFAULT' then xprompt := prompt1;
  savestuff;
 end;

procedure quit( cline : string );
 begin
  settextheight(15);
  done := true;
 end;

procedure now( cline : string );
 begin
  cwriteln(#13'|C|^D');
 end;

procedure rnd( cline : string );
 begin
  tymax := 29;
  crtstuff.rnd;
  tymax := 25;
 end;

{$F-}

const
 numcommands = 12;
 commandset : array[ 0 .. numcommands ] of xmcomm =
    ( ( s:       '?'; p : help ),
      ( s:       'X'; p : quit ),
      ( s:      'CD'; p : cd ),
      ( s:     'CLS'; p : cls ),
      ( s:    'ECHO'; p : echo ),
      ( s:   'TRASH'; p : trash ),
      ( s:   'EMPTY'; p : empty ),
      ( s:     'DEL'; p : del ),
      ( s:     'VER'; p : ver ),
      ( s:  'PROMPT'; p : prompt ),
      ( s:     'RND'; p : rnd ),
      ( s:     'MOO'; p : moo ),
      ( s:     'NOW'; p : now ) );


procedure parse( s : string );
 var
  i,j : byte;
  m, cl : string;
  found : boolean;
 begin
  cwriteln('');
  found := false;
  j := 1;
  while j <= length( s ) do
   begin
    if s[j] = '/' then
     begin
      insert( ' ', s, j );
      inc( j );
     end;
    inc( j );
   end;
  m := upstr( wordn( s, 1 ) );
  cl := copy( s, length( m )+2, length( s ) - length( m )-1 );
  if (length( s ) = 2) and (s[2] = ':') then
   begin
    found := true;
    cd( s );
   end
  else
    if (length( s ) > 1 ) and (s[1] = ';') then
    begin
     z.historyr := incwrap( z.historyr, 1, $0, $F );
     z.historyx := z.historyr;
     z.history[z.historyr] := z.strg;
     savestuff;
     delete( s, 1, 1 );
     assign( xf, 'c:\extras\xtemp.bat' );
     rewrite( xf );
     writeln( xf, '@Call ' + s );
     writeln( xf, '@XMENU !');
     close( xf );
     done := true;
    end
   else { not a ;-command  }
    for i := 0 to numcommands do
     if
      m = commandset[i].s
     then
      begin
       found := true;
       commandset[i].p( cl );
      end;
  if not found then settextheight(15);
  if not (found or done) then
   begin
    Exec( getenv('COMSPEC'), '/c ' + s );
    txpos := wherex;
    typos := wherey;
    mouseon;
    showmouse( off );
   end;
 end;

procedure makemenu;
 begin
  appmenu.init( on, on, on,
     newchoicexy( 1, 2, '|!w|kÚ|#Ä20¿|!k ', '', false, #255, 0, nil, nil ));
  appmenu.add(
     newchoicexy( 1, 3, '|!w|k³ |bþ|k Navigator   ...  ³|!k ',
                        '|!w|k³|!b |Yþ|W Navigator   ...  |!w|k³|!k ',
                       on, ' ', 253, nil, nil ));
  if fileexists( 'c:\extras\zmenu.dat') then
   begin
    appmenu.add(
     newchoicexy(1, 4, '|!w|kÃ|#Ä20´|!k ', '', no, #255, 0, nil, nil ));
    assign( xf, 'C:\extras\zmenu.dat');
    reset( xf );
    numentries := 0;
    while
     not eof(xf)
    do
     begin
      inc( numentries, 1 );
      readln( xf, data[numentries].shortcut );
      readln( xf, data[numentries].MenuText );
      readln( xf, data[numentries].Path );
      readln( xf, data[numentries].Filename );
      with data[ numentries ] do
        appmenu.add( newchoicexy( 1, numentries + 4,
              '|!w|k³(|b' + shortcut + '|k) ' +
               padstr( MenuText, 16, ' ') + '³|!k ',
               '|!w|k³|!b|W(|Y' + shortcut + '|W) ' +
               padstr( MenuText, 16, ' ') + '|!w|k³|!k ',
               true, shortcut[1], numentries, nil, nil ));
     end;
  end; { if fileexists }
  if exitchoice then
   begin
    appmenu.add (
     newchoicexy( 1, numentries+5, '|!w|kÃ|#Ä20´|!k ', '', false, #255, 0, nil,
     newchoicexy( 1, numentries + 6,
              '|!w|k³(|bþ|k) Exit XMenu      ³|!k ',
               '|!w|k³|!b|W(|Yþ|W) Exit XMenu      |!w|k³|!k ',
               true, #254, 254, nil, nil )));
    inc(numentries,2);
   end;
   appmenu.add (
    newchoicexy( 1, numentries+5, '|!w|kÀ|#Ä20Ù|!k ', '', false, ' ', 0, nil,
    newchoicexy( 2, numentries+6, '|!k|# 22', '', false, #255, 0, nil, nil )));
   close( xf );
 end;

procedure loadstuff;
 var
  stuff : file;
  cnt : byte;
 begin
  if not fileexists( 'c:\extras\xmenu.cfg' ) then exit;
  filereset( stuff, 'c:\extras\xmenu.cfg');
  xprompt := nextstring( stuff );
  for cnt := 0 to $F do
   begin
    z.history[z.historyx] := nextstring( stuff );
    z.historyx := incwrap( z.historyx, 1, $0, $F );
   end;
  close( stuff );
 end;

procedure savestuff;
 var
  stuff : file;
  cnt : byte;
 begin
  filerewrite( stuff, 'c:\extras\xmenu.cfg');
  savestring( stuff, xprompt );
  for cnt := 0 to $F do
   begin
    savestring( stuff, z.history[z.historyx] );
    z.historyx := decwrap( z.historyx, 1, $0, $F );
   end;
  close( stuff );
 end;


procedure init;
 begin
  {If VGA Then} settextheight( 400 div 30 );
  clockcol := blue;
  bannerback := lightgray;
  bannertext := black;
  xprompt := prompt1;
  z.inithist;
  loadstuff;
  checkbreak := false;
  done := false;
  if paramstr(1) <> '!' then
   begin
    cwriteln( '|!k'#13'|WXMenu version |Y'+version+' |B(|Wc|B)|W1994 '+
     '|b[|B[|WS|Ca|WBR|Ce|WN|B]|b]|W and '+ silverware+' |WAll rights reserved|r.' );
    now( '' );
    parse('note');
    cwriteln( '|WHit |B<|WALT|B>|W for menu or type |B"|W?|B"|W for help|r...');
   end;
  exitchoice := (paramcount > 1) and (paramstr(2) = '!');
  makemenu;
  cwritexy( 1,1, '|!w|%  |bð  X|kMenu |!k');
  tymin := 2;
  if paramcount > 2 then parse( paramstr( 3 ) );
  z.init( txpos, typos+1, 255, 79-txpos, $0F, $0A, false, '' );
  p.init( 6, 1, 72, 74, $09, $0F, 'þ', '' );
  mouseon;
  setmpos(0,0);
  showmouse( off );
 end;


begin
 init;
 repeat
  doscursoroff;
  GetTime(h,om,s,hund);
  min := 0;
  tymin := 1;
  cwritexy( 1,1, '|!w  |bð  X|kMenu |# 47|b|^D |!k');
  tymin := 2;
  settextheight( 13 );
  move( xmtag, banner, sizeof( xmtag ));
  cwrite( '|_'+xprompt );
  greyshadow( 1, 1, 80, 1 );
  z.init( txpos, typos+1, 255, 79-txpos, $0F, $0A, false, '' );
  doscursoron;
  repeat
   getmpos;
   if mousemoved then showmouse( on );
   drawclock;
   if (shiftstate and altpressed <> 0) or (ms <> 0) then
    begin
     repeat getmpos until (shiftstate and altpressed = 0) and (ms=0);
     if not keypressed then
      begin
       showmouse( off );
       dosscreen := screen;
       showmouse( on );
       tymin := 1;
       doscursoroff;
       tcolor := $0F;
       appmenu.reset;
       result := appmenu.get;
       showmouse( off );
       screen := dosscreen;
       tymin := 2;
       z.reset;
       if result = 253 then
         begin
          getdir( 0, dirtemp );
          Navigator;
          if dirtemp <> thisdir then
           begin
            z.strg := '';
            z.isdone := true;
           end;
         end;
       if result = 254 then begin z.isdone := true; parse('x'); end;
       if (result > 0) and (result <20) then
        with data[result] do
         begin
          parse( 'echo |_|WXMenu|r: |WRunning |Y'+ menutext + '|r...' );
          parse( 'cd ' + path  );
          parse( filename );
          z.strg := '';
          z.isdone := true;
         end;
       doscursoron;
      end;
    end
   else
    if keypressed then
      begin showmouse(off);
       GetTime(h,om,s,hund);
       min := 0;
       z.handle(readkey);
      end;
  until z.isdone;
  z.reset;
  if z.strg <> '' then
   begin
    parse( z.strg );
    z.historyr := incwrap( z.historyr, 1, $0, $F );
    z.historyx := z.historyr;
    z.history[z.historyr] := z.strg;
   end;
 until done;
 cwriteln('');
 doscursoron;
end.