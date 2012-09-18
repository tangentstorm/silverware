{ Hertz - one cycle per second }

uses crt,vgastuff,dos,crtstuff;
{$I alfscreen.pas}

const
 hz : word = 4;
 done : boolean = false;

var
 h, m, s, hund : Word;
 min,om : word;

procedure titlescreen;
 begin
  setupcrt;
  screen := screentype( alfscreen );
  getenter;
 end;

function time : boolean;
 begin
  GetTime(h,m,s,hund);
  time := m <> om;
  if m <> om then inc( min );
  om := m;
 end;

procedure spray;
 var
  x : integer;
 begin
  for x := 1 to 500 do
   putpixel( random( 320 ), random( 200 ), random( 256 ));
 end;

procedure flash;
 begin
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  setcolor( 0, 63, 63, 63 );
  repeat until (port[$3da] and $08 ) = 0;
  repeat until (port[$3da] and $08 ) <> 0;
  setcolor( 0, 0, 0, 0 );
 end;

begin
 titlescreen;
 min := 0;
 GetTime(h,om,s,hund);
 repeat
  setmode( $13 );
  hz := 21;
  spray;
  repeat
   if time then case min of
    1 .. 10 : hz := hz - 2;
    310 .. 320 : hz := hz + 2;
   end;
   delay( 1000 div hz );
   flash;
  until keypressed and (readkey = #27);
  setmode( $3 );
  done := false;
 until done;
 doscursoron;
end.