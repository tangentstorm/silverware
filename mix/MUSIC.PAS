Program Music;

uses crt, crtstuff, zokstuff, moustuff, sndstuff, pntstuff;
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
  scrollright( 1, 80, 3, 18, @music2 );
  getenter;
 end;

type musicbug = object( zobj )
 s : string;
 constructor init( a, b : byte; str : string );
 procedure shownormal; virtual;
 function click : boolean; virtual;
end;

constructor musicbug.init( a, b : byte; str : string );
 begin
  x := a;
  x2 := a + 50;
  y :=  b;
  y2 := b;
  s := str;
  shownormal;
 end;

procedure musicbug.shownormal;
 begin
  colorxy( x, y, 9, s );
 end;

function musicbug.click;
 var
  c : boolean;
 begin
  c := zobj.click;
  if c then
   begin
    colorxy( x, y, $4E, s );
    spkr.ansiplay( s );
    shownormal;
   end;
  click := c;
 end;

function rs( s: string ) : string;
 var
  i : byte;
 begin
  for i := 1 to 25 do if random( 5 )+1 = 5
   then s[i] := char(random(6)+ord('A'));
  rs := s;
 end;

procedure objectlab;
 var
  s, ts : string;
  sm, s1, s2, s3 : musicbug;
  mm, m1, m2, m3 : ztext;
  i : integer;
 begin
  showmouse( off ); clrscr;
  cwritexy( 1, 1, '|!k|R Objectlab|Y: |WClick mutant to play or right click to spawn!|%');
  showmouse( on );
  randomize;
  s := chntimes( 'c',25 );
   mm.init( 70,  5, '|W|!b Keep ', '|W|!r Keep ' ); mm.shownormal;
   m1.init( 70,  7, '|W|!bMutate', '|W|!rMutate' ); m1.shownormal;
   m2.init( 70,  9, '|W|!bMutate', '|W|!rMutate' ); m2.shownormal;
   m3.init( 70, 11, '|W|!bMutate', '|W|!rMutate' ); m3.shownormal;
  repeat
   showmouse( off );
   sm.init( 15,  5, s );
   s1.init( 15,  7, rs(s) );
   s2.init( 15,  9, rs(s) );
   s3.init( 15, 11, rs(s) );
   mm.shownormal;
   showmouse( on );
   ts := '';
   repeat
    if sm.click or s1.click or s2.click or s3.click then {nothing};
    if mm.click then ts := s; {no change}
    if m1.click then ts := s1.s;
    if m2.click then ts := s2.s;
    if m3.click then ts := s3.s;
   until (ts <> '') or ((ms and 2) <> 0);
   s := ts;
  until (ms and 2) <> 0;
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
  ch : char;
 begin
  showmouse(off);
  cwritexy( 2, 1, '|RInstrument Panel|Y: |WKeyboard users press |B<|WTAB|B>|W to switch windows|M...|%');
  zokwork := screentype(music1);
  writeto := @zokwork;
  fillbox( 1, 3, 80, 17, bluebox );
  x := 7; y := 6;
  x2 := 47; y2 := 4;
  crtstuff.bar( x,y,x+32,y+9,$08);
  greyshadow( x,y,x+32,y+9 );
  crtstuff.bar( x2, y2, x2+21, y2+13, $08);
  greyshadow(   x2, y2, x2+21, y2+13 );
  menu.init(  on, on, on,
  newchoicexy( x+ 1, y+ 8, '|B[|WD|wemo|B]', '|!r|Y[|WD|Yemo]|!k', on, 'D', 1 , nil,
  newchoicexy( x+ 7, y+ 8, '|B[|WR|weset|B]', '|!r|Y[|WR|Yeset]|!k', on, 'R', 2, nil,
  newchoicexy( x+14, y+ 8, '|B[|WL|woad|B]', '|!r|Y[|WL|Yoad]|!k', on, 'L', 3, nil,
  newchoicexy( x+20, y+ 8, '|B[|WS|wave|B]', '|!r|Y[|WS|Yave]|!k', on, 'S', 4, nil,
  newchoicexy( x+26, y+ 8, '|B[|WQ|wuit|B]', '|!r|Y[|WQ|Yuit]|!k', on, 'Q', 255, nil,
  nil ))))));
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
  scrollright( 1, 80, 4, 18, @zokwork );
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
       begin
        writeto := @zokwork;
        zokwork := screen;
        case ch of
         #72, #80 : scroller1.handle( ch );
         #75, #77 : counters[ sbiset(scroller1.value) ].handle( ch );
        end;
        writeto := @screen;
        screen := zokwork;
       end
       else
        case ch of
         #75: menu.handlestripped( #72 );
         #77: menu.handlestripped( #80 );
         #72: ;
         #80: ;
         else
          menu.handlestripped( ch );
        end;
       ch := ' ';
      end;
    end;
   for yo := modmult to carrel do
    counters[ yo ].domousestuff;
   scroller1.domousestuff;
   menu.domousestuff;
   if menu.endloop then
    begin
     case menu.value of
      1: begin
          for yo := modmult to carrel do
           countersbi[ yo ] := counters[ yo ].value;
          spkr.sbiset( 0, countersbi );
          spkr.ansiplay( 'l8 '+cancan );
         end;
      255 : ch := #27;
     end;
    menu.reset;
    end;
   until (ch = #27) or (ms and $02 <> 0);
  showmouse( off );
  cwritexy( 2, 1, '|RInstruments|Y: |WByebyes|M!|%');
  showmouse( on );
 end;

type
 pnote = ^note;
 note = object( node )
  hz : word; {frequency}
  at : byte; {attributes}
  constructor init( h : word; a : byte );
 end;
 voice = object( list )
  counter : byte;
  slur : boolean;
  channel : byte;
  cursor : pnode;
  constructor init( chan : byte );
  procedure add( hz : word; at : byte );
  procedure home;
  procedure update;
  procedure play;
 end;

 constructor note.init( h : word; a : byte );
  begin
   hz := h;
   at := a;
  end;


 constructor voice.init( chan : byte );
  begin
   list.init;
   home;
   channel := chan;
  end;

 procedure voice.add( hz : word; at : byte );
  begin
   append( new ( pnote, init( hz, at ) ) );
  end;

 procedure voice.home;
  begin
   cursor := first;
   counter := 0;
   slur := false;
  end;

 procedure voice.update;
  var
   hz : word;
  begin
   if
    (counter > 0)
   then
    dec( counter )
   else
    begin
     if not slur then spkr.sbsetreg( $B0+channel, $00 );
     if cursor = nil then exit;
     slur := (pnote( cursor )^.at AND 128) = 128;
     counter := pnote( cursor )^.at AND 63;
     hz := pnote( cursor )^.hz;
     if hz <> 0 {rest} then
      begin
       spkr.sbSetreg( $A0+channel, lo( hz ));
       spkr.sbSetreg( $B0+channel, 32 + spkr.sboctave shl 2 + (hi( hz ) and $03) );
      end;
     cursor := cursor^.next;
    end;

{
 sound

    o  __  ooooo
    ^  ^^  ^^^^^^
    |  |     |___length of note ( in 32nd's of a whole note )
    |  |
    |  |_________unused
    |
    |____________turn channel off after this note?
}
  end;

 procedure voice.play;
  begin
   home;
   repeat
    update;
    delay( 10 ); (***** should be 1/32nd of a note, whatever that is.. ***)
   until cursor = nil; {which it becomes after the last note}
   home;
  end;

var
 voices : array[ 0..7 ] of voice;

procedure playvoices;
 var
  c : byte;
 begin
   for c := 0 to 7 do voices[c].home;
   repeat
    for c := 0 to 7 do voices[c].update;
    delay( 10 ); (***** should be 1/64th of a note, whatever that is.. ***)
   until voices[0].cursor = nil; {which it becomes after the last note}
 end;

procedure loadsong;
 begin
 end;

procedure compose;
 var
  done : boolean;
  c: byte;
 begin
  done := false;
  repeat
   for c := 0 to 7 do voices[c].init(c);
   cwriteln( '|$|# 15|R(|WMusic Composition|R)' );
   cwriteln( '|R(|WL|R)|Boad');
   cwriteln( '|R(|WP|R)|Blay' );
   cwriteln( '|R(|WQ|R)|Buit to main' );
   case upcase( readkey ) of
    'L' : loadsong;
    'P' : playvoices;
    'Q' : done := true;
   end;
  until done;
 end;

procedure domusicmenu; { main routine }
 var
  musicmenu : zbouncemenu;
  result : byte;
  done : boolean;
  sbcol1 : char;
 begin
  sbcol1 := Boolchar(spkr.sbon,'W','K');
  musicmenu.init( 25, 6, 30, '', yes, no,
   newchoice( '(|)|WF|()lashcards', '', on,'F', 1, nil,
   newchoice( '|G(|)|WO|()bjectlab', '|K³|!g(|WO|Y)bjectlab|# 19|!k|K³', on, 'O', 2, nil,
   newchoice( '(|)|WM|()usic composition', '', on, 'M', 3, nil,
   newchoice( '(|)|'+sbcol1+'I|()nstruments', '', spkr.sbon, 'I', 4, nil,
   newchoice( '(|)|WP|()rint utilities', '', on, 'P', 5, nil,
   newsepbar(
   newchoice( '(|)|WQ|()uit', '', on, 'Q', 255, nil,
  nil ))))))));
  done := false;
  repeat
   zokwork := screentype(music1);
   writeto := @zokwork;
   musicmenu.show;
   scrollright( 1, 80, 4, 18, @zokwork);
   writeto := @screen;
   result := musicmenu.get;
   case result of
    1: flashcards;
    2: objectlab;
    3: compose;
    4: instruments;
    255: done := true;
   end;
  until done;
 end;

procedure shutdown;
 begin
  showmouse( off );
  slidedownoff( @DOSscreen );
  cwritexy( 1, dosypos, '|WThanks for using |RMAESTRO|M...|w'+#13);
  doscursoron;
  spkr.nosound;
 end;

 var
  moe : noteobj;
begin
 setupcrt;
 loadfont('H:\FONT\MUSIC.fnt');
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