Program App;
Uses AppStuff,crt,crtstuff;

Var
 Progdone : Boolean;
 Counter : Word;
 ch : char;
 RND : ScreenSaver;

Begin
 doscursoroff;
 textattr := $0F;
 clrscr;
 rnd.init;
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
         cwrite(ch);
         Rnd.GetScreen;
        end;
      end;
     end;
  end;
  doscursoron;
End.