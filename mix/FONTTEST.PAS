Program FontTest;
{$X+}
Uses
  CRT,
  Common,
  ModeX;

Procedure smfont; external;
{$L smfont.obj}

Var
  lf, ff  : PrFontObj;
  x, y, i : Word;



BEGIN
  SetMode(MODE200, 0, 0);
  ff.FileInit('bor8x8.prf');
  lf.MemInit(@smfont);
  x := 0; y := 0;
{  For i := 1 To 10 Do
  Begin
    ff.SetFGColor(i+1);
    ff.WriteAt(x, y, 'This is a Test');
    Inc(x, 8);
    Inc(y, 4);
  End;
  ReadKey;
}
  ClearPage(0);
  For i := 1 To 10 Do
  Begin
    lf.SetFGColor(i + 1);
    lf.WriteAt(x, y, 'This is a Test');
    Inc(x, 18);
    Inc(y, 14);
  End;
  ReadKey;

{  ff.Done;}
  SetTextMode;
END.