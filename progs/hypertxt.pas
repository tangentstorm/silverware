program hypertxt;
uses crt, crtstuff, zokstuff, filstuff,moustuff;

var
 dos : screentype;
 done : boolean;
 msg : string;

procedure updateclock;
 begin
  colorxy( 73, 1, $70, time );
 end;

procedure updatemsgbar( s : string );
 begin
  cwritexy( 1, 25, '|!k|K|#²80' );
  if s = '' then s := '|WHypertext Reader |B(|Wc|B)|W1994 '+silverware;
  ccenterxy( 41, 25, '±° |W'+s+'|K °±');
 end;

procedure drawscreen;
 begin
  cwritexy( 1, 1, '|!w|W|# 80' );
  cwritexy( 2, 1, '|kMenu|K=|bAlt' );
  updatemsgbar( msg );
  updateclock;
 end;

procedure init;
 begin
  dos := screen;
  msg := '';
  setupcrt;
  drawscreen;
  mouseon;
  showmouse( off );
 end;

procedure shutdown;
 begin
  doscursoron;
  screen := dos;
 end;

procedure domenu;
 begin
  done := true;
 end;

procedure main;
 var
  ch : char;
 begin
  done := false;
  repeat
   getmpos;
   if mousemoved then showmouse( on );
   case ms of
    1: {nextpage};
    2: domenu;
   end;
   if (shiftstate and altpressed <> 0) then domenu;
   if keypressed then
    begin
     ch := readkey;
     showmouse( off );
    end;
  until done;
 end;


begin
 init;
 main;
 shutdown;
end.