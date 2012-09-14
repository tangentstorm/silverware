{ Hertz - one cycle per second }

uses crt,vgastuff,dos,crtstuff;
{$I alfscr.pas}

const
 hz : word = 4;
 done : boolean = false;

var
 h, m, s, hund : Word;
 min,om : word;

function time : boolean;
 begin
  GetTime(h,m,s,hund);
  time := m <> om;
  if m <> om then inc( min );
  om := m;
 end;


procedure flash;
 begin
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  setcolor( 0, 00, 63, 63 );
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  setcolor( 0, 0, 0, 0 );
 end;

begin
  titlescreen;
  clrscr;
  GetTime(h,om,s,hund);
  min := 0;
  hz := 13;
  done := false;
  repeat
   if time then case min of
{(*invoked a lucid dream once *)    1 .. 10 : hz := hz - 2;}
{        310 .. 320 : hz := hz + 2;}
{        321 : done := true;}
         30 : done := true;
   end;
   delay( 1000 div hz );
   flash;
  until done or (keypressed and (readkey = #27));
 doscursoron;
 end.