Program App;
Uses AppStuff,crt;

Var
 Progdone : Boolean;
 Counter : Word;
 ch : char;
 RND : ScreenSaver;
 X,Y : Byte;

Begin
 clrscr;
 rnd.init;
 While Keypressed do ch := Readkey;
 Counter := 0;
 X := 1;
 Y := 1;
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
         TextAttr := $0F;
         GotoXY( X, Y );
         write(ch);
         Rnd.GetScreen;
         X := WhereX;
         Y := WhereY;
        end;
      end;
     end;
  end;
End.