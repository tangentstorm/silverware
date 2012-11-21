Program Banana1;
Uses Crt,CrtStuff;


Procedure SetUpScreen;
Begin
  TextMode(co80);
  NoCursor;
End;


Begin
  SetUpScreen;
  Repeat
{    Sound(Random(20000)); }
  Until Keypressed;
  Nosound
End.