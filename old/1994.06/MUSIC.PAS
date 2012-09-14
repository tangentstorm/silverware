Program Music;

uses crt, crtstuff, zokstuff, moustuff, sndstuff;
{$I MUSIC1.PAS}
{$I MUSIC2.PAS}
{$I MUSIC3.PAS}

type
 notes = ( c, csharp, d, eflat, e, f, fsharp, g, aflat, a, bflat, b,
           whole, half, quarter, eigth, sixteenth, thirtysecondth,
           dotted, voice0, voice1, voice2, voice3 );
 noteset = set of notes;

const               {1234567890AB}
 notestr : string = 'CcDeEFfGaAbB';
 cancan = 'C.C..DFEDG.G..GAEFD.D..DFEDC.';
                { bitmapped tone/chord: }
                { 2^X: FEDCBA987654   32   1   0 }
                { Bit: þþþþþþþþþþþþ | þþ | þ | þ }
                { Map: BbAaGfFeEDcC | Ln | ^ | ú }


type
 noteobj = object
  tone, data : word;
  procedure init( _tone : noteset );
  procedure play;
{  procedure draw; virtual;}
 end;

procedure noteobj.init( _tone : noteset );
 var
  counter : notes;
 begin
  for counter := c to b do if counter in _tone then
    tone := tone + ( power(2,ord(counter)) shl 4 );
 end;

procedure noteobj.play;
 var
  foundnote : boolean;
  counter : integer;
  chord : word;
  ch : char;
 begin
  {this will have to be redone for soundblaster}
  foundnote := false;
  counter := 0;
  chord := tone shr 4;
  repeat
   if
    (power( 2, counter ) and chord) <> 0
   then
    begin
     ch := notestr[ counter + 1 ];
     spkr.ansiplay( ch );
     foundnote := true;
    end
   else
    counter := counter + 1;
  until foundnote or (counter = 12);
  if counter = 12 then delay( 10 ); {this is nasty.. it's a rest, though}
 end;

procedure flashcards;
 begin
  scrollright( 1, 80, 3, 18, screentype(music2));
  getenter;
  scrolldown( 1, 80, 3, 18, screentype(music1));
 end;

procedure objectlab;
 var
  mynote1, mynote2 : noteobj;
 begin
  showmouse( off );
  cwritexy( 1, 1, '|!k|R Objectlab|Y: |WWhere happy objects go for fun|M...|W|%');
  showmouse( on );
  mynote1.init( [c] );
  mynote2.init( [c,e,f] );
  with spkr do
  begin
   spkr.sbinit;
   sbiset( 0, imarimba );
   ansiplay( cancan );
  end;
 end;


procedure instruments;
 var
  yo : sbimember;
  menu : zmenu;
  scroller1, scroller2 : zvscroller;
  counters : array[ sbiset ] of zhexcounter;
  countersbi : sbi;
  window : boolean;
  x, x2, y, y2 : byte;
  temp : screentype;
  ch : char;
 begin
  showmouse(off);
  cwritexy( 2, 1, '|RInstrument Panel|Y: |WKeyboard users press |B<|WTAB|B>|W to switch windows|M...|%');
  writeto := @temp;
  temp := screentype(music1);
  fillbox( 1, 3, 80, 17, bluebox );
  x := 7; y := 6;
  x2 := 47; y2 := 4;
  crtstuff.bar( x,y,x+32,y+9,$08);
  greyshadow( x,y,x+32,y+9 );
  crtstuff.bar( x2, y2, x2+21, y2+13, $08);
  greyshadow(   x2, y2, x2+21, y2+13 );
  menu.init(  on );
  menu.add( x+ 1, y+ 8, '|B[|WD|wemo|B]', '|!r|Y[|WD|Yemo]|!k', on, 'D', 1 );
  menu.add( x+ 7, y+ 8, '|B[|WR|weset|B]', '|!r|Y[|WR|Yeset]|!k', on, 'R', 2 );
  menu.add( x+14, y+ 8, '|B[|WL|woad|B]', '|!r|Y[|WL|Yoad]|!k', on, 'L', 3 );
  menu.add( x+20, y+ 8, '|B[|WS|wave|B]', '|!r|Y[|WS|Yave]|!k', on, 'S', 4 );
  menu.add( x+26, y+ 8, '|B[|WQ|wuit|B]', '|!r|Y[|WQ|Yuit]|!k', on, 'Q', 255 );
  menu.show;
  cwritexy( x2+2, y2+ 1, '|!k|WMMult|M:');
  cwritexy( x2+2, y2+ 2, '|!k|WMLevl|Y:');
  cwritexy( x2+2, y2+ 3, '|!k|WMAttk|M:');
  cwritexy( x2+2, y2+ 4, '|!k|WMDcay|Y:');
  cwritexy( x2+2, y2+ 5, '|!k|WMSust|M:');
  cwritexy( x2+2, y2+ 6, '|!k|WMRlse|Y:');
  cwritexy( x2+2, y2+ 7, '|!k|WCMult|M:');
  cwritexy( x2+2, y2+ 8, '|!k|WCLevl|Y:');
  cwritexy( x2+2, y2+$9, '|!k|WCAttk|M:');
  cwritexy( x2+2, y2+$a, '|!k|WCDcay|Y:');
  cwritexy( x2+2, y2+$b, '|!k|WCSust|M:');
  cwritexy( x2+2, y2+$c, '|!k|WCRlse|Y:');
  for yo := modmult to carrel do
   begin
    counters[ yo ].init( x2+11, y2+1+ord(yo), 13+(ord(yo) mod 2), $0C, 0,
     byte(boolchar( ((ord(yo)) mod 6) >= 2, #$F, #$FF)), idefault[yo] );
    counters[ yo ].show;
   end;
  scroller1.default( x2 + 9, y2+1, 0, 11, 0 );
  writeto := @screen;
  scrollright( 1, 80, 4, 18, temp );
  showmouse(on);
  repeat
   ch := ' ';
   if keypressed then
    begin
     ch := upcase( readkey );
     if not (ch = #0) then
      case ch of
       #9 {tab} : window := not window;
       else
        menu.handle( ch );
      end
     else
      begin
       ch := readkey;
       if window then
       case ch of
        #72, #80 : scroller1.handle( ch );
        #75, #77 : counters[ sbiset(scroller1.value) ].handle( ch );
       end
       else
        menu.handlestripped( ch );
       ch := ' ';
      end;
    end;
   for yo := modmult to carrel do
    counters[ yo ].domousestuff;
   scroller1.domousestuff;
   menu.domousestuff;
   if menu.endloop then
    begin
     menu.reset;
     case menu.value of
      1: begin
          for yo := modmult to carrel do
           countersbi[ yo ] := counters[ yo ].value;
          spkr.sbiset( 0, countersbi );
          spkr.ansiplay( 'l8 '+cancan );
         end;
      255 : ch := #27;
     end;
    end
   until (ch = #27) or (ms and $02 <> 0);
  showmouse( off );
  cwritexy( 2, 1, '|RInstruments|Y: |WByebyes|M!|%');
  scrollright( 1, 80, 4, 18, screentype(music1));
  showmouse( on );
 end;

procedure domusicmenu; { main routine }
 var
  musicmenu : zbouncemenu;
  result : byte;
  done : boolean;
  sbcol1 : char;
 begin
  sbcol1 := Boolchar(spkr.sbon,'W','K');
  musicmenu.init( 25, 6, 30, '', yes,
   newline( '(|)|WF|()lashcards', '', on,'F', 1,
   newline( '|G(|)|WO|()bjectlab', '|!g(|WO|Y)bjectlab|# 02', on, 'O', 2,
   newline( '(|)|WM|()usic composition', '', on, 'M', 3,
   newline( '(|)|'+sbcol1+'I|()nstruments', '', spkr.sbon, 'I', 4,
   newline( '(|)|WP|()rint utilities', '', on, 'P', 5,
   newbar(
   newline( '(|)|WQ|()uit', '', on, 'Q', 255,
  nil ))))))));
  done := false;
  repeat
   result := musicmenu.get;
   screentype(music1) := screen;
   case result of
    1: flashcards;
    2: objectlab;
    4: instruments;
    255: done := true;
   end;
  until done;
 end;

procedure shutdown;
 begin
  showmouse( off );
  slidedownoff( DOSscreen );
  cwritexy( 1, dosypos, '|WThanks for using |RMAESTRO|M...|w'+#13);
  doscursoron;
  spkr.nosound;
 end;

 var
  moe : noteobj;
begin
 setupcrt;
 screen := screentype(music1);
 delay(250);
 cwrite('|!k|R MAESTRO|Y: |WInitiating stuff|M... |W');
 delay(500);
 mouseon;
 setmpos( 0, 0 );
 settcurson( #13, $0A );
{ spkr.sbon := false;}
 if spkr.sbon then cwrite('Using sound card|M... |W')
 else cwrite('Using PC speaker|M... |W');
      spkr.ansiplay('t320 l16'+cancan+'l8');
 cwriteln('Done|M!|w');
 domusicmenu;
 shutdown;
end.