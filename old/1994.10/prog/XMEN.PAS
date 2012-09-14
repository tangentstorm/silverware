{$M 22408,0,15000} {needs larger than normal stack, not as much heap}
program xmen;
uses crtstuff, zokstuff, crt, filstuff, moustuff, dos;

const
 version = '1.75à';

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


const
 prompt1 = '|_|B|^P|_|Rxmenu|Y>|W';
 prg = true;
 sub = false;

var
 z : zinput;
 p : zpassword;
 exitchoice : boolean;
 xcs : string; {xmenu command string}
 xf : text;
 xprompt : string;
 xmenubar : zmenubar;
 appmenu : zmenu;
 emenu : zbouncemenu;
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
 begin
  col := bannerback * 16 + clockcol;
  colorxy( 60, 1, col, stardate );
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

procedure aboutxmenu;
 var
  ss : word;
  x,y :byte;
  ch : char;
 begin
  x := txpos; y := typos;
  dosscreen := screen;
  doscursoroff;
  ss := shiftstate;
  metalbar( 14, 5, 67, 7 );
  ccenterxy( 40, 6, '|!w|bÄ|BÍ|CÍ|b[|W XMenu '+version+
               ' |kor|W DOS : The Next Generation |b]|CÍ|BÍ|bÄ');
  ccenterxy( 40, 11, '|!k');
  repeat getmpos until keypressed or (ms <> 0) or (ss <> shiftstate);
  while keypressed do ch := readkey;
  repeat getmpos until (shiftstate and altpressed = 0) and (ms=0);
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
  cwriteln('|Ynote|w..........|Wwrite a note or read notes');
  cwriteln('|Yshotime|w.......|Wshow the time and date');
  cwriteln('|Ytrash|w.........|Wshows the TRASH directory');
  cwriteln('|b|#Ä55');
  cwriteln('|WPlacing a semicolon |r(|Y;|r)|W at the start of the command|_'+
           'line removes XMenu from memory while the program runs|r.');
  cwriteln('|b|#Ä55');
 end;

procedure adl( cline : string );
 begin
  crtstuff.adl( cline );
 end;

procedure cd( cline : string );
 begin
  {$I-}
  chdir( cline );
  {$I+}
  if IOResult <> 0 then
   cwriteln('|WNo can do|r, |Wman|r...');
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
  adl( 'c:\extras\trash' );
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
    new.init( txpos, typos+1, 78, 78, $0B, $00, xprompt );
    cline := new.get;
   end;
  xprompt := cline;
  if upstr(cline) = 'DEFAULT' then xprompt := prompt1;
  savestuff;
 end;

procedure quit( cline : string );
 begin
  done := true;
 end;

procedure note( cline : string );
 var
  f : text;
  s : string;
  i : word;
 begin
  cwriteln('|b|#Ä50');
  assign( f, 'C:\extras\notes.txt' );
  if nwords( cline ) > 0 then
   begin
    if fileexists('C:\EXTRAS\NOTES.TXT') then
     append( f )
    else
     rewrite( f );
    for i := 1 to nwords( cline ) do
    write(f, wordn( cline, i )+' ');
    writeln(f);
    cwriteln('|WGot it|r!');
   end
  else
   begin
    if not fileexists('C:\EXTRAS\NOTES.TXT') then
     begin
      cwriteln('|GNothing in notepad file|g...');
      cwriteln('|b|#Ä50');
      exit;
     end;
    reset( f );
    while not eof( f ) do
     begin
     readln( f, s );
     cwriteln( '|w'+s );
    end;
   end;
  cwriteln('|b|#Ä50');
  close( f );
 end;

procedure shotime( cline : string );
 begin
  cwriteln(#13'|C|^D');
 end;

{$F-}

const
 numcommands = 12;
 commandset : array[ 0 .. numcommands ] of xmcomm =
    ( ( s:       '?'; p : help ),
      ( s:       'X'; p : quit ),
      ( s:     'ADL'; p : adl ),
      ( s:      'CD'; p : cd ),
      ( s:     'CLS'; p : cls ),
      ( s:    'ECHO'; p : echo ),
      ( s:   'TRASH'; p : trash ),
      ( s:   'EMPTY'; p : empty ),
      ( s:     'DEL'; p : del ),
      ( s:     'VER'; p : ver ),
      ( s:  'PROMPT'; p : prompt ),
      ( s:    'NOTE'; p : note ),
      ( s: 'SHOTIME'; p : shotime ) );


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
  if not (found or done) then
   begin
    Exec( getenv('COMSPEC'), '/c ' + s );
    txpos := wherex;
    typos := wherey;
   end;
 end;

procedure makemenu;
 begin
  xmenubar.init( on );
  xmenubar.add( 2, 1, '|!w|b ð ', '|!b|Y ð ', on, 'ð', 0 );
  xmenubar.add( 5, 1, '|!w|b X|kMenu ', '|!bY X|WMenu ', off, 'X', 0 );
  appmenu.init( on );
  appmenu.add ( 1, 2, '|!w|kÚ|#Ä20¿|!k ', '', false, #255, 0 );
  appmenu.add ( 1, 3, '|!w|k³ |bð|k About XMenu ...  ³|!k ',
                      '|!w|k³|!b |Yð|W About XMenu ...  |!w|k³|!k ', on, ' ', 253 );
  if fileexists( 'c:\extras\zmenu.dat') then
   begin
    appmenu.add ( 1, 4, '|!w|kÃ|#Ä20´|!k ', '', false, #255, 0 );
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
        appmenu.add( 1, numentries + 4,
              '|!w|k³(|b' + shortcut + '|k) ' +
               padstr( MenuText, 16, ' ') + '³|!k ',
               '|!w|k³|!b|W(|Y' + shortcut + '|W) ' +
               padstr( MenuText, 16, ' ') + '|!w|k³|!k ',
               true, shortcut[1], numentries );
     end;
  end; { if fileexists }
  if exitchoice then
   begin
    appmenu.add ( 1, numentries+5, '|!w|kÃ|#Ä20´|!k ', '', false, #255, 0 );
        appmenu.add( 1, numentries + 6,
              '|!w|k³(|bþ|k) Exit XMenu      ³|!k ',
               '|!w|k³|!b|W(|Yþ|W) Exit XMenu      |!w|k³|!k ',
               true, #254, 254 );
    inc(numentries,2);
   end;
   appmenu.add ( 1, numentries+5, '|!w|kÀ|#Ä20Ù|!k ', '', false, ' ', 0 );
   appmenu.add ( 2, numentries+6, '|!k|# 22', '', false, #255, 0 );
   appmenu.seton( appmenu.shortcut( ' ' ) );
   close( xf );
   xmenubar.addsub( 'ð', @appmenu );
 end;

procedure loadstuff;
 var
  stuff : file;
 begin
  if not fileexists( 'c:\extras\xmenu.cfg' ) then exit;
  filereset( stuff, 'c:\extras\xmenu.cfg');
  xprompt := nextstring( stuff );
  close( stuff );
 end;

procedure savestuff;
 var
  stuff : file;
 begin
  filerewrite( stuff, 'c:\extras\xmenu.cfg');
  savestring( stuff, xprompt );
  close( stuff );
 end;


procedure init;
 begin
  clockcol := blue;
  bannerback := lightgray;
  bannertext := black;
  xprompt := prompt1;
  loadstuff;
  checkbreak := false;
  done := false;
  if paramstr(1) <> '!' then
   begin
    cwriteln( '|!k'#13'|WXMenu version |Y'+version+' |B(|Wc|B)|W1994 '+
     '|b[|WS|Ca|WBR|Ce|WN|b]|W and '+ silverware+' |WAll rights reserved|r.' );
    shotime( '' );
    note( '' );
    cwriteln( '|WHit |B<|WALT|B>|W for menu or type |B"|W?|B"|W for help|r...');
   end;
  exitchoice := (paramcount > 1) and (paramstr(2) = '!');
  makemenu;
  cwritexy( 1,1, '|!w|%  |bð  X|kMenu |!k');
  tymin := 2;
  if paramcount > 2 then parse( paramstr( 3 ) );
  z.init( 6, 1, 74, 74, $0F, $0F, '' );
  p.init( 6, 1, 74, 74, $09, $0F, 'þ', '' );
 end;

begin
 init;
 repeat
  tymin := 1;
  cwritexy( 1,1, '|!w|%  |bð  X|kMenu |!k');
  tymin := 2;
  cwrite( xprompt );
  greyshadow( 1, 1, 80, 1 );
  z.y := typos +1;
  z.x := txpos; {covers for prompt length changes}
  z.back := '';
  z.strg := '';
  mouseon;
  setmpos(0,0);
  showmouse( off );
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
       xmenubar.reset;
       result := xmenubar.get;
       showmouse( off );
       screen := dosscreen;
       tymin := 2;
       z.reset;
       if result = 253 then aboutxmenu;
       if result = 254 then begin z.isdone := true; parse('x'); end;
       if (result > 0) and (result <20) then
        with data[result] do
         begin
          parse( 'echo |_|WXMenu|r: |WRunning |Y'+ menutext + '|r...' );
          parse( 'cd ' + path  );
          parse( filename );
          z.isdone := true;
         end;
      end;
    end
   else
    if keypressed then begin showmouse(off); z.handle(readkey); end;
  until z.isdone;
  z.reset;
  if z.strg <> '' then parse( z.strg );
 until done;
 cwriteln('');
 doscursoron;
end.