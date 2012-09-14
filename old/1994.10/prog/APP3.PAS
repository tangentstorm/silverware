Program App3;
Uses AppStuff,crt,crtstuff,TvrStuff;

const
 prompt = '|bÄ|BÄ|CÄ|W>';

Var
 Progdone : Boolean;
 Counter : Word;
 ch : char;
 RND : ScreenSaver;
 inp : input;
 s : string;

Procedure docommand( s : string );
 begin
  if
   s = ''
  then
   cwriteln( '|Yş |GEh|g?');
  if
   s = 'CLS'
  then
   begin
    cwcommand( cwclrscr , '');
    rnd.getscreen;
   end;
  if
   (s = 'QUIT') or (s = 'Q')
  then
   begin
    Cwriteln(' |Yş |GAre you |Ysure|G you want to quit|g? ');
   end;
  if
   (s = '/Q')
  then
    progdone := true;
  if
   (s = '/W') or (s = '/WHO')
  then
   begin
    cwriteln('');
    cwriteln('|KÄ|WUsers|KÄ|WOnline|KÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    cwriteln('|w Battle Axe    Cybernet - yay!');
    cwriteln('|w Pirate        Has anyone seen my bottle of rum?');
    cwriteln('|Yú|wFigment       ');
    cwriteln('|Yú|cSterling      |GWelcome to CyberNet|g...');
    cwriteln('|w Yagi Hito     ');
    cwriteln('|KÄ|WFree|KÄ|WLines|B:|KÄÄ|W05|KÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ');
    cwriteln('');
   end;
 end;

function parse( s : string ) : string;
 begin
  parse := Upstr( s );
 end;

Begin
 doscursoroff;
 textattr := $0F;
 clrscr;
 cwrite( prompt );
 rnd.init;
 inp.init( true );
 While Keypressed do ch := Readkey;
 Counter := 0;
 Progdone := false;
 While not ProgDone do
  begin
    RND.Handle( counter );
    Counter := Counter + 1;
    if keypressed then
     begin
      Counter := 0;
      RND.Handle( counter );
      ch := readkey;
      case ch of
       ^Q : Progdone := True;
       else
        begin
         inp.handle(ch);
         Rnd.GetScreen;
        end;
      end;
     end;
    if
     inp.readstring( s )
    then
     begin
      docommand( parse( s ) );
      cwrite( prompt );
      rnd.getscreen;
     end;
  end;
  doscursoron;
End.