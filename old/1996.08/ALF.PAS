program alphaflight; {brainwave manipulation!}
uses crtstuff, sndstuff, crt, dos, vgastuff, zokstuff, filstuff;

{$I alfscr.pas}

var
 ch : char;
 sblast : sbobj;
 h, m, s, hund : Word;
 min,om : word;
 menu : zbouncemenu;

const
 hz : word = 4;
 done : boolean = false;

procedure superlearning;
 var
  script : string;
  spdone : boolean;
  sfile : text;
  box : zinputbox;
 begin
  spdone := false;
  randomize;
  clrscr;
  repeat
   box.init( 5, 5, $08,  '|W     Filename|w?      ','  |m'#16,
                'F:\HOT\PSYCH.XCL', 15, 30);
   script := box.get;
  until fileexists( script );
  clrscr;
  assign( sfile, script );
  reset( sfile );
  while not (eof( sfile ) or spdone) do
   begin
    clrscr;
    readln( sfile, script );
    ccenterxy( 40, random(20)+4, '|!k|'+ccolstr[random(6)+10]+script );
    delay( 4000 );  {four seconds}
    spdone := keypressed and (readkey = #27);
    clrscr;
    if not spdone then
     begin
      delay( 4000 );  {four seconds}
      spdone := keypressed and (readkey = #27);
     end;
   end;
  close( sfile );
 end;

procedure flash;
 begin
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  setcolor( 0, 00, 63, 00 );
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  setcolor( 0, 0, 0, 0 );
 end;

function time : boolean;
 begin
  GetTime(h,m,s,hund);
  time := m <> om;
  if m <> om then inc( min );
  om := m;
 end;

procedure ls;
 var
  ch : char;
  lsdone: boolean;
 begin
  while keypressed do ch := readkey;
  lsdone := false;
  GetTime(h,om,s,hund);
  min := 0;
  hz := 8;
  lsdone := false;
  sblast.init;
  sblast.pro;
  sblast.setpan( 0, $11 );
  sblast.setpan( 1, $21 );
  sblast.sound( 0, 200 );
  sblast.sound( 1, 200 + hz );
   repeat
    if time then case min of
 {(*invoked a lucid dream once *)    1 .. 10 : hz := hz - 2;}
 {        310 .. 320 : hz := hz + 2;}
 {        321 : lsdone := true;}
          30 : lsdone := true;
    end;
    delay( 1000 div hz );
    flash;
    if keypressed then ch := readkey;
   until lsdone or (ch in [ #13, #27 ]);
  if lsdone or (ch = #13) then
   begin
    sblast.nosound(0);
    sblast.nosound(1);
    sblast.nosound(2);
    sblast.nosound(3);
   end;
 end;


begin
 doscursoroff;
 done := false;
 screen := screentype( alfscr );
 getenter;
 menu.init( 1, 1, 13, 'wkkrY', off, off, newchoice
  ( 'L/S Session',  '', on, 'L', 1, nil, newchoice
  ( 'Superlearning','', on, 'S', 2, nil,newchoice
  ( 'Quit', '', on, 'Q', 0, nil, nil
 ))));
 repeat
  case menu.get of
   1 : ls;
   2 : superlearning;
   0 : done := true;
  end;
 until done;
 doscursoron;
end.


